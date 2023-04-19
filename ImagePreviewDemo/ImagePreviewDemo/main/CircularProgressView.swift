//
//  CircularProgressView.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI

struct CircularProgressView: View {
    
    /// 0~100
    let progress: Int
    
    private let lineWith: CGFloat = 8
    private let color: Color = .gray

    
    init(_ progress: Int) {
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: lineWith
                )
            Circle()
                .trim(from: 0, to: Double(progress) / 100)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWith,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: Double(progress) / 100)
            
            Text("\(progress)%")
                .font(.system(size: 12))
                .foregroundColor(.white)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            CircularProgressView(50)
                .frame(width: 45, height: 45)
        }
    }
}
