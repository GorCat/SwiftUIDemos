//
//  SVGAPlayerView.swift
//  SVGDemo
//
//  Created by GorCat on 2023/4/13.
//

import SwiftUI
import SVGAPlayer

struct SVGAPlayerView:UIViewRepresentable
{
    var url:URL
    
    func makeUIView(context: Context) -> SVGAPlayer {
        let player = SVGAPlayer()
        let parser = SVGAParser()
        parser.parse(with: url) { videoItem in
            if let item = videoItem {
                player.videoItem = item
                player.startAnimation()
            }
        }
        return player
    }
    
    func updateUIView(_ uiView: SVGAPlayer, context: Context) {
    }
}


struct SVGAPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SVGAPlayerView(url: URL(string: "https://iulia.iwlive.club/gift/private-chat/xj-1.svga")!)
    }
}
