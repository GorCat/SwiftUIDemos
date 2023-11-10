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
        case .processCSVString(let scvModel):
            appCommand = ProcessCSVCommand(csvModel: scvModel)
        case .processCSVStringDone(let result):
            appState.results = result
        case .generalFiles:
            appCommand = GeneralFilesCommand()
        }
        
        return (appState, appCommand)
    }
}
