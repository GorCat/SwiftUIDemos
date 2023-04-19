//
//  ContentView.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI

struct ContentView: View {
    @State var showImageViewer: Bool = false
    @State var imgURL: String = "https://ilivegirl.s3.amazonaws.com/photos/7bf24171b485a35b4005304d25a316cb.jpg"
    
    var body: some View {
        VStack {
            Text("Example!")
                .onTapGesture {
                    showImageViewer = true
                }
        }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(ImageViewerRemote(imageURL: self.$imgURL, viewerShown: self.$showImageViewer))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
