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

struct ProcessCSVCommand: AppCommand {
    let csvModel: CSVModel
    
    func execute(in store: Store) {
        /* 通过 i18N 文件来解析
        guard let csvPath = Bundle.main.path(forResource: "i18N", ofType: "csv") else { return }
        do {
            let csvString = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8).trimmingCharacters(in: .whitespacesAndNewlines)
         
         } catch {
             print(error)
         }
         */
        
        let languegesArray = getLanguagesArray(from: csvModel)
        let results = tranformLanguagesArrayToModels(languegesArray)
        
        store.dispatch(.processCSVStringDone(results))
    }
    
    func getLanguagesArray(from csvModel: CSVModel) -> ([[String]]) {
        let csvString = csvModel.content
        let lineSeperator = csvModel.lineSeperator
        let itemSeperator = csvModel.itemSeperator
        
        var results: [[String]] = []
        let csvItems = csvString.components(separatedBy: lineSeperator)
        for csvItem in csvItems {
            if csvItem.isEmpty {
                continue
            }
            let textItems = csvItem.components(separatedBy: itemSeperator)
            if textItems.isEmpty {
                continue
            }
            
            var translateTexts: [String] = []
            
            // 1.en
            let en = textItems[0].trimmingCharacters(in: .whitespacesAndNewlines).formatterTranlatedText(en: "")
            if en.noContent {
                continue
            }
            translateTexts.append(en)
            
            // 2.ar、tr、...
            for item in textItems.dropFirst() {
                let translateText = item.trimmingCharacters(in: .whitespacesAndNewlines).formatterTranlatedText(en: en)
                translateTexts.append(translateText)
            }
            
            results.append(translateTexts)
        }
        
        return results
    }
    
    func tranformLanguagesArrayToModels(_ languegesArray: [[String]]) -> [ResultModel] {
        var models: [ResultModel] = []
        
        for item in languegesArray {
            let model = ResultModel(languages: item)
            models.append(model)
        }
        
        // 1.去重
        let modelsSet = Set(models)
        
        // 2.排序
        let results = modelsSet.sorted(by: { $0.key < $1.key})
        
        return results
    }
}

struct GeneralFilesCommand: AppCommand {
    
    func execute(in store: Store) {
        let appState = store.state
        
        var enumString = ""
        var enString = ""
        var arString = ""
        var trString = ""
        
        let results = appState.results
        for item in results {
            
            let key = item.key
            enumString.append("case \(key)\n")
            
            let en = "\"\(key)\" = \"\(item.en)\";\n"
            enString.append(en)
            
            let ar = "\"\(key)\" = \"\(item.ar)\";\n"
            arString.append(ar)
            
            let tr = "\"\(key)\" = \"\(item.tr)\";\n"
            trString.append(tr)
        }
        
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let enumPath = documentsUrl.appendingPathComponent("EnumResults")
        let enPath = documentsUrl.appendingPathComponent("EnLocalized")
        let arPath = documentsUrl.appendingPathComponent("ARLocalized")
        let trPath = documentsUrl.appendingPathComponent("TRLocalized")
        NSWorkspace.shared.activateFileViewerSelecting([documentsUrl])

        do {
            try enumString.write(to: enumPath, atomically: true, encoding: String.Encoding.utf8)
            try enString.write(to: enPath, atomically: true, encoding: String.Encoding.utf8)
            try arString.write(to: arPath, atomically: true, encoding: String.Encoding.utf8)
            try trString.write(to: trPath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            debugPrint(error.localizedDescription)
        }
            
            
    }
}

fileprivate extension StringProtocol {
    var noContent: Bool {
        self.replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .isEmpty
    }
}

fileprivate extension String {
    
    func formatterTranlatedText(en: String) -> String {
        var result = self
        if result.hasPrefix("\"") {
            result = String(result.dropFirst())
        }
        if result.hasSuffix("\"") {
            result = String(result.dropLast())
        }
        // 不翻译
        if ["无", "无需"].contains(result) {
            result = en
        }
        return result
    }
    
}

