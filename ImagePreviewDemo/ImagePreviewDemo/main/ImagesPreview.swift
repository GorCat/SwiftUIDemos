//
//  ImagesPreview.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI

struct ImagesPreview: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        ZStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(UIColor.white))
                    .font(.system(size: UIFontMetrics.default.scaledValue(for: 24)))
            }
        }
    }
}

struct ImagesPreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagesPreview()
    }
}
