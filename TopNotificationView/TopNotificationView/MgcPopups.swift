//
//  MgcPopups.swift
//  GameComunity
//
//  Created by GorCat on 2023/3/10.
//

import SwiftUI

struct MgcPopups: View {
    var imageName: String
    var title: String
    var message: String
    
    @State var yOffset: CGFloat = 0
    @State var originalY: CGFloat?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .edgesIgnoringSafeArea(.all )
            contentView
                .offset(y: yOffset)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { action in
                            let y = action.location.y
                            print("====\(y)")
                            guard let oY = originalY else {
                                originalY = y
                                print("Saved!")
                                return
                            }
                            if y > oY {
                                return
                            }
                            yOffset = y - oY
                            
                            print("offset\(yOffset)")
                        }
                        .onEnded { action in
                            originalY = nil
                        }
                )
        }
    }
    
    var contentView: some View {
        HStack(alignment: .top) {
            Image(imageName)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16).weight(.semibold))
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 96)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}

struct MgcPopups_Previews: PreviewProvider {
    static var previews: some View {
        MgcPopups(imageName: "mgc_popups_Notification", title: "Success", message: "This is a message")
    }
}
