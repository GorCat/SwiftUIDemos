//
//  ResultModel.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/11/10.
//

import Foundation

struct ResultModel {
    var key = ""
    var en = ""
    var ar = ""
    var tr = ""
    
}
extension ResultModel: Identifiable {
    var id: String {
        key
    }
    
    
}

extension ResultModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

extension ResultModel {
    init(languages: [String]) {
        en = languages[0]
        ar = languages[1]
        tr = languages[2]

        key = en.enumTextFormatter.filter{ $0.isLetter }
    }
}

fileprivate extension StringProtocol {
    var enumTextFormatter: String {
        return prefix(1).lowercased() + self.capitalized.dropFirst()
    }
}
