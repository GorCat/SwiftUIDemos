//
//  AppAction.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import Foundation

enum AppError: Error {
    case message
}

enum AppAction {
    case processCSVString(scvModel: CSVModel)
    case processCSVStringDone(_ result: [ResultModel])
    case generalFiles
}
