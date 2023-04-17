//
//  MgcPopups.swift
//  GameComunity
//
//  Created by GorCat on 2023/3/10.
//

import SwiftUI

struct MgcPopups: View {
//    let model = PopupItemModel(imageName: "mgc_popups_Notification", title: "Notification", message: "some message")
    
    @State private var willDismissModel: PopupItemModel?
    @State private var dismissY: CGFloat = 0
    
    @Binding var willShowModel: PopupItemModel?
    @State private var showY: CGFloat = -200
    
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var count = 0
    @State private var originalY: CGFloat?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .edgesIgnoringSafeArea(.all )
            if let model = willDismissModel {
                PopupItem(model: model)
                    .offset(y: dismissY)
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
                                    dismiss()
                                    return
                                }
                                dismissY = offset
                                print("offset\(dismissY)")
                            }
                            .onEnded { action in
                                startTimer()
                                originalY = nil
                            }
                    )
            }
            if let model = willShowModel {
                PopupItem(model: model)
                    .offset(y: showY)
            }
        }
        .onChange(of: willShowModel, perform: { newValue in
            if newValue != nil {
                show()
            }
        })
        .onReceive(timer) { _ in
            count -= 1
            if count == 0 {
                dismiss()
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
        withAnimation(.linear(duration: 0.15)) {
            showY = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            willDismissModel = willShowModel
            willShowModel = nil
            showY = -200
        }
        startTimer()
    }
    
    func dismiss() {
        withAnimation(.linear(duration: 0.15)) {
            dismissY = -200
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//        withAnimation(.linear(duration: 2).delay(2)) {
            willDismissModel = nil
            dismissY = 0
        }
        stopTimer()
    }
}

struct MgcPopups_Previews: PreviewProvider {
    static var previews: some View {
        MgcPopups(willShowModel: .constant( PopupItemModel(imageName: "mgc_popups_Notification", title: "Notification", message: "some message")))
    }
}

struct PopupItemModel {
    var imageName: String
    var title: String
    var message: String
    let date = Date()
    let uuid = UUID()
    
}
extension PopupItemModel: Equatable {
    
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
