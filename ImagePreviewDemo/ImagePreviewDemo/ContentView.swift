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
    
    @State var images = [
            "https://r.iwlive.club/photos/cfd29a04e8817f92698816085488921b.jpg",
            "https://r.iwlive.club/photos/0e4fe405f66d34a23e01b1ecbdf06535.jpg",
            "https://r.iwlive.club/photos/b2ccfb7e1b7863888278c3299757f5ba.jpg",
            "https://r.iwlive.club/photos/b5fd62f48248486310cf9e1be4df2d2f.jpg",
            "https://r.iwlive.club/22m/AndroidImage/1679378222628_my_pic1679378222396.jpg",
            "https://r.iwlive.club/22m/AndroidImage/1679378232431_my_pic1679378231890.jpg",
            "https://r.iwlive.club/22m/AndroidImage/1679378244214_my_pic1679378244129.jpg",
            "https://r.iwlive.club/22m/AndroidImage/1679378251982_my_pic1679378251663.jpg"]
    
    var body: some View {
        ZStack {
            Text("Example!")
                .onTapGesture {
                    showImageViewer = true
                }
            
            if showImageViewer {
                ImageViewerRemote(URL(string: images[1])!) {
                    Rectangle()
                        .fill(Color.white)
                        .overlay(
                            Image("image_placeholder")
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
