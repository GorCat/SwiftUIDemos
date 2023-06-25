//
//  AppState.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import Foundation


struct AppState {
    
    var step: Step = .processEnum
    
    var enumKeys: [String] = []
    var enumValues: [String] = []
    
    var enFileValues: [String] = []
    var arFileValues: [String] = []
    
    
    var allKeys: [String] = []
    var arDictionary: [String: String] = [:]
    var enDictionary: [String: String] = [:]
    
}
