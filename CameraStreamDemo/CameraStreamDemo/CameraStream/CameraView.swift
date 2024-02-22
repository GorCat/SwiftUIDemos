//
//  CameraView.swift
//  CameraStreamDemo
//
//  Created by GorCat on 2024/2/22.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
 
    private static let barHeightFactor = 0.15
    
    @State private var dataTask: Task<Void, Error>?
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                ViewfinderView(image:  $model.viewfinderImage )
                    .overlay(
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(
                                Rectangle()
                                    .fill(Color.black.opacity(0.75))
                            )
                    )
            }
        }
        .onAppear {
            dataTask = Task {
                await model.camera.start()
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Button {
                model.camera.offOrOnCamera()
            } label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 45)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
