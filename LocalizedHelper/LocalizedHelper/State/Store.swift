//
//  Store.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import Foundation

enum Step {
    case processEnum
    case processCSV
}

class Store: ObservableObject {
    
    @Published var state = AppState()
    
    func dispatch(_ action: AppAction) {
        debugPrint("[Action]: \(action)")
        let result = Store.reduce(state: state, action: action)
        state = result.0
        if let command = result.1 {
            debugPrint("[Command]: \(command)")
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .processEnum:
            appCommand = ProcessEnumCommand()
        case .processEnumDone(let results):
            appState.enumKeys = results.0
            appState.enumValues = results.1
            appState.step = .processCSV
        case .processLanguageFiles:
            appCommand = ProcessLanguageCommand()
        case .processLanguageFilesDone(let result):
            appState.enFileValues = result.0
            appState.arFileValues = result.1
        case .conbineDatas:
            appCommand = ConbineDatasCommand()
        case .conbineDatasDone(let result):
            appState.allKeys = result.0
            appState.enDictionary = result.1
            appState.arDictionary = result.2
        case .generalFiles:
            appCommand = GeneralFilesCommand()
        }
        
        return (appState, appCommand)
    }
}
