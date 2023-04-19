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
    
    init(_ progress: Int) {
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: Double(progress) / 100)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: Double(progress) / 100)

        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(50)
    }
}
