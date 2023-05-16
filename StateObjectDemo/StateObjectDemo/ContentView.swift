//
//  ContentView.swift
//  StateObjectDemo
//
//  Created by GorCat on 2023/5/7.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button("BELL RING") {
                    BellRingManager.share.play(.call)
                }
                Button("BELL RING") {
                    BellRingManager.share.play(.message)
                }
                Button("BELL RING") {
                    BellRingManager.share.play(.send)
                }
                Button("BELL RING") {
                    
                    AudioServicesPlaySystemSound(1002)
                }
                Button("BELL RING") {
                    
                    AudioServicesPlaySystemSound(1004)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
