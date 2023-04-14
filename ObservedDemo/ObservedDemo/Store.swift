//
//  Store.swift
//  ObservedDemo
//
//  Created by GorCat on 2023/4/6.
//

import Foundation
import Combine
import SwiftUI

class Store: ObservableObject {
    @Published var state = AppState()
    
    @Published var message1 = MessageState()
    
    var disposeBag = Set<AnyCancellable>()
    
    init() {
        CustomMananger.share.countPublisher
            .sink { count in
                print("=======\(count)")
            }
            .store(in: &disposeBag)
    }
}

struct AppState {
    var appState = 0
    
    mutating func add() {
        appState += 1
    }
}

class MessageState: ObservableObject {
    @Published var count = 0
    
    @Published var manager = CustomMananger.share
    var disposeBag = Set<AnyCancellable>()
    
    init() {}
    
    
    
    func add() {
        count += 1
        objectWillChange.send()
    }
}

class CustomMananger: ObservableObject {
    
    @Published var count = 0
    
    static let share = CustomMananger()
    private init() {
//        super.init()
    }
    
    func add() {
        count += 1
        objectWillChange.send()
    }
    
    
    var countPublisher: AnyPublisher<Int, Never> {
        return $count
            .eraseToAnyPublisher()
    }
}
