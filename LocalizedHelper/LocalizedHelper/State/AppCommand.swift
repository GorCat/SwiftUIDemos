//
//  AppCommand.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import Foundation
import AppKit


protocol AppCommand {
    func execute(in store: Store)
}

struct ProcessEnumCommand: AppCommand {
    
    func execute(in store: Store) {
        var results: ([String], [String]) = ([], [])
        guard let enumPath = Bundle.main.path(forResource: "EnumFile", ofType: "") else { return }
        
        do {
            let enumString = try String(contentsOfFile: enumPath, encoding: String.Encoding.utf8).trimmingCharacters(in: .whitespacesAndNewlines)
            let array = enumString.components(separatedBy: "case")
            for item in array {
                if item.isEmpty {
                    continue
                }
                
                let itemArray = item.components(separatedBy: "=")
                let itemKey = itemArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let itemValue = itemArray[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\"", with: "")
                results.0.append(itemKey)
                results.1.append(itemValue)
            }
        } catch{
            print(error)
        }
        
        store.dispatch(.processEnumDone(results))
    }
}

struct ProcessLanguageCommand: AppCommand {
    
    func execute(in store: Store) {
        var results: ([String], [String]) = ([], [])
        
        
        guard let csvPath = Bundle.main.path(forResource: "i18N", ofType: "csv") else { return }
        do {
            let csvString = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8).trimmingCharacters(in: .whitespacesAndNewlines)
            let csvArray = csvString.components(separatedBy: ",NNNNNNNN,")
            
            for csvItem in csvArray {
                if csvItem.isEmpty {
                    continue
                }
                let items = csvItem.components(separatedBy: ",GGGGG,")
                if items.isEmpty {
                    continue
                }
                
                var en = items[0].trimmingCharacters(in: .whitespacesAndNewlines)
                var ar = items[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if en.noContent {
                    continue
                }
                if en.hasPrefix("\"") {
                    en = String(en.dropFirst())
                }
                if en.hasSuffix("\"") {
                    en = String(en.dropLast())
                }
                
                if ar.hasPrefix("\"") {
                    ar = String(ar.dropFirst())
                }
                if ar.hasSuffix("\"") {
                    ar = String(ar.dropLast())
                }
                
                results.0.append(en)
                results.1.append(ar)
            }
            
            
        } catch {
            print(error)
        }
        store.dispatch(.processLanguageFilesDone(results))
    }
}

struct ConbineDatasCommand: AppCommand {
    
    func execute(in store: Store) {
        let appState = store.state
        
        var allkeys: [String] = []
//        var lowercasedEnumKey: [String] = []
        var arDictionary: [String: String] = [:]
        var enDictionary: [String: String] = [:]
        for item in zip(appState.enumKeys, appState.enumValues) {
            let key = item.0
            allkeys.append(key)
//            lowercasedEnumKey.append(key.lowercased())
            
            enDictionary[key] = item.1
            arDictionary[key] = ""
        }
        
        for item in zip(appState.enFileValues, appState.arFileValues) {
            var key = item.0.enumTextFormatter.filter{ $0.isLetter }
            if let keyIndex = allkeys.firstIndex(of: key) {
                key = allkeys[keyIndex]
            } else {
                allkeys.append(String(key))
            }
            enDictionary[key] = item.0
            if item.1.isEmpty {
                arDictionary[key] = item.0
            } else {
                arDictionary[key] = item.1
            }
        }
        
        let set = Set(allkeys)
        allkeys = set.sorted()
        
        // deduplication
        store.dispatch(.conbineDatasDone((allkeys, enDictionary, arDictionary)))
    }
}

struct GeneralFilesCommand: AppCommand {
    
    func execute(in store: Store) {
        let appState = store.state
        
        var enumString = ""
        var enString = ""
        var arString = ""
        for keyItem in appState.allKeys {
            enumString.append("case \(keyItem)\n")
            
            let en = "\"\(keyItem)\" = \"\(appState.enDictionary[keyItem] ?? "")\";\n"
            enString.append(en)
            
            let ar = "\"\(keyItem)\" = \"\(appState.arDictionary[keyItem] ?? "")\";\n"
            arString.append(ar)
        }
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let enumPath = documentsUrl.appendingPathComponent("EnumResults")
        let enPath = documentsUrl.appendingPathComponent("EnLocalized")
        let arPath = documentsUrl.appendingPathComponent("ARLocalized")
        NSWorkspace.shared.activateFileViewerSelecting([documentsUrl])

        do {
            try enumString.write(to: enumPath, atomically: true, encoding: String.Encoding.utf8)
            try enString.write(to: enPath, atomically: true, encoding: String.Encoding.utf8)
            try arString.write(to: arPath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            debugPrint(error.localizedDescription)
        }
            
            
    }
}

extension StringProtocol {
    var noContent: Bool {
        self.replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .isEmpty
    }
    
    var enumTextFormatter: String {
        return prefix(1).lowercased() + self.capitalized.dropFirst()
    }
}
