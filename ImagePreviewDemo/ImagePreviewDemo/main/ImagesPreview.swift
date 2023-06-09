//
//  ImagesPreview.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI

struct ImagesPreview: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectedIndex = 0
    var imageURLs: [URL]
    
    init(_ selectedIndex: Int = 0, imageURLs: [URL]) {
        self._selectedIndex = State(wrappedValue: selectedIndex)
        self.imageURLs = imageURLs
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .zIndex(2)
            TabView(selection: $selectedIndex) {
                ForEach(imageURLs.indices, id: \.self) { index in
                    ImagePreviewItemView(imageURLs[index])
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            UIView.setAnimationsEnabled(true)
        }
    }
    
}

struct ImagesPreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagesPreview(0, imageURLs: [
            "https://r.iwlive.club/photos/cfd29a04e8817f92698816085488921b.jpg",
            "https://r.iwlive.club/photos/0e4fe405f66d34a23e01b1ecbdf06535.jpg"
        ].compactMap{ URL(string: $0) })
    }
}
