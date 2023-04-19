//
//  ImagePreviewItemView.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import Combine


@available(iOS 13.0, *)
public struct ImagePreviewItemView<Placeholder: View>: View {
    private var imageURL: URL
    private var placeholderView: Placeholder
    
    @State private var dragOffset: CGSize = CGSize.zero
    @State private var dragOffsetPredicted: CGSize = CGSize.zero
    
    @State private var showProgress = true
    @State private var progress: Int = 0
    
    
    public init(_ url: URL, @ViewBuilder placeholderView: () -> Placeholder) {
        self.imageURL = url
        self.placeholderView = placeholderView()
    }

    @ViewBuilder
    public var body: some View {
        ZStack {
            WebImage(url: imageURL)
                .onSuccess {_,_,_ in
                    showProgress = false
                }
                .onProgress { (installed, total) in
                    guard installed > 0, total > 0 else {
                        return
                    }
                    showProgress = true
                    progress = installed * 100 / total // 0~100
                }
                .onFailure { error in
                    showProgress = false
                }
                .placeholder {
                    placeholderView
                }
                .resizable()
                .offset(x: self.dragOffset.width, y: self.dragOffset.height)
                .rotationEffect(.init(degrees: Double(self.dragOffset.width / 30)))
                .pinchToZoom()
            
            if showProgress {
                CircularProgressView(progress)
                    .frame(width: 45, height: 45)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)).edgesIgnoringSafeArea(.all))
        .zIndex(1)
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
        .onAppear() {
            self.dragOffset = .zero
            self.dragOffsetPredicted = .zero
        }
    }
}

extension ImagePreviewItemView where Placeholder == Rectangle {
    public init(_ url: URL) {
        self.imageURL = url
        self.placeholderView = Rectangle()
    }
}

struct ImagePreviewItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewItemView(URL(string: "https://r.iwlive.club/photos/cfd29a04e8817f92698816085488921b.jpg")!)
    }
}
