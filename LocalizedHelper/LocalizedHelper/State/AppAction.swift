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
    case processEnum
    case processEnumDone(_ result: ([String], [String]))
    case processLanguageFiles
    case processLanguageFilesDone(_ result: ([String], [String]))
    case conbineDatas
    case conbineDatasDone(_ result: ([String], [String: String], [String: String]))
    case generalFiles
}
