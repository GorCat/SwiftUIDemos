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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var dragOffset: CGSize = CGSize.zero
    @State private var dragOffsetPredicted: CGSize = CGSize.zero
    
    @State private var showProgress = true
    @State private var progress: Int = 0
    
    @State private var image: UIImage?
    
    private var backgroudOpacity: CGFloat {
        let halfScreenHeight = UIScreen.main.bounds.height / 2
        let opacity = (1.0 - abs(dragOffset.height) / halfScreenHeight)
        debugPrint(opacity)
        return opacity
    }
    
    public init(_ url: URL, @ViewBuilder placeholderView: () -> Placeholder) {
        self.imageURL = url
        self.placeholderView = placeholderView()
    }

    @ViewBuilder
    public var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.12, blue: 0.12, opacity: backgroudOpacity)
                .edgesIgnoringSafeArea(.all)

            
            WebImage(url: imageURL)
                .onSuccess {image, data, type in
                    showProgress = false
                    self.image = image
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
                .aspectRatio(contentMode: .fit)
                .offset(y: dragOffset.height)
                .pinchToZoom()
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            self.dragOffset = value.translation
                            self.dragOffsetPredicted = value.predictedEndTranslation
                        }
                        .onEnded { value in
                            if backgroudOpacity < 0.35 {
                                withAnimation(.spring()) {
                                    self.dragOffset = self.dragOffsetPredicted
                                }
                                presentationMode.wrappedValue.dismiss()
                                return
                            }
                            withAnimation(.interactiveSpring()) {
                                self.dragOffset = .zero
                            }
                        }
                    )

            if showProgress {
                CircularProgressView(progress)
                    .frame(width: 45, height: 45)
            }
            
            if let image = image {
                saveImageItem(image)
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
        .onAppear() {
            self.dragOffset = .zero
            self.dragOffsetPredicted = .zero
        }
    }
    
    func saveImageItem(_ image: UIImage) -> some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(11)
                    .frame(width: 45)
                    .onTapGesture {
                        ImageSaver().writeToPhotoAlbum(image: image)
                    }
                    .padding()
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.horizontal)
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
