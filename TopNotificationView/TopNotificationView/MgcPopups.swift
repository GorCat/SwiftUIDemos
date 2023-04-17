//
//  MgcPopups.swift
//  GameComunity
//
//  Created by GorCat on 2023/3/10.
//

import SwiftUI

struct MgcPopups: View {
    let model = PopupItemModel(imageName: "mgc_popups_Notification", title: "Notification", message: "some message")
    
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var count = 0
    @State private var yOffset: CGFloat = -200
    @State private var originalY: CGFloat?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .edgesIgnoringSafeArea(.all )
            PopupItem(model: model)
                .offset(y: yOffset)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { action in
                            stopTimer()
                            let y = action.location.y
                            guard let oY = originalY else {
                                originalY = y
                                return
                            }
                            if y > oY {
                                // disabled move down gesture
                                return
                            }
                            let offset = y - oY
                            if offset < -45 {
                                autoDismiss()
                                return
                            }
                            yOffset = offset
                            print("offset\(yOffset)")
                        }
                        .onEnded { action in
                            startTimer()
                            originalY = nil
                        }
                )
        }
        .onReceive(timer) { _ in
            count -= 1
            if count == 0 {
                autoDismiss()
            }
        }
        .onAppear {
            show()
        }
    }
    
    func startTimer() {
        count = 3
        timer = Timer.publish(every: 1, on: .main, in: .common)
        _ = timer.connect()
    }
    
    func stopTimer() {
        timer.connect().cancel()
    }
    
    
    func show() {
        withAnimation {
            yOffset = 0
        }
        startTimer()
    }
    
    func autoDismiss() {
        withAnimation {
            yOffset = -200
        }
        stopTimer()
    }
}

struct MgcPopups_Previews: PreviewProvider {
    static var previews: some View {
        MgcPopups()
    }
}

struct PopupItemModel {
    var imageName: String
    var title: String
    var message: String
    let date = Date()
}

struct PopupItem: View {
    let model: PopupItemModel
    
    
    var body: some View {
        HStack(alignment: .top) {
            Image(model.imageName)
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.system(size: 16).weight(.semibold))
                Text(model.message)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 96)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}
