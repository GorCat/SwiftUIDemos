//
//  TransparentBackground.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import SwiftUI

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
    func clearfullScreen<T>(_ isPresent: Binding<Bool>, backgroudColor: Color? = .clear, content: @escaping () -> T) -> some View where T: View {
        self.fullScreenCover(isPresented: isPresent) {
            content()
                .edgesIgnoringSafeArea(.bottom)
                .background(
                    TransparentBackground()
                        .onTapGesture {
                            isPresent.wrappedValue = false
                        }
                )
        }
    }
}
