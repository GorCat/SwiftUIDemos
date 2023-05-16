//
//  BellRingManager.swift
//  GameComunity
//
//  Created by GorCat on 2023/5/15.
//

import Foundation
import AudioToolbox

enum BellRingType: Int {
    case call = 0
    case send
    case message
    
    var fileName: String {
        switch self {
        case .call:
            return "callRing"
        case .send:
            return "sendRing"
        case .message:
            return "messageRing"
        }
    }
    
    static let all = Array(0...2).compactMap{ BellRingType(rawValue: $0) }
    
    var soundID: SystemSoundID {
        SystemSoundID(self.rawValue)
    }
    
}

class BellRingManager {
    static let share = BellRingManager()
    var soundIDs = BellRingType.all.map{ $0.soundID }
    
    init() {
        for (index, type) in BellRingType.all.enumerated() {
            if let soundURL = Bundle.main.url(forResource: type.fileName, withExtension: "mp3") {
                AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundIDs[index])
            }
        }
    }
    
    func play(_ sound: BellRingType) {
        AudioServicesPlaySystemSound(soundIDs[sound.rawValue])
    }
}
