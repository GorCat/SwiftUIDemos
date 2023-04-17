//
//  ContentView.swift
//  TopNotificationView
//
//  Created by GorCat on 2023/4/14.
//

import SwiftUI

struct ContentView: View {
    
    @State var model: PopupItemModel?
    var body: some View {
        ZStack {
            Spacer()
            VStack {
                Button("Show Notification") {
                    model = PopupItemModel(imageName: "mgc_popups_Notification", title: "Notification", message: "some message")
                }
                Button("Show Success") {
                    model = PopupItemModel(imageName: "mgc_popups_Success", title: "Success", message: "some message")
                }
                Button("Show Faild") {
                    model = PopupItemModel(imageName: "mgc_popups_Error", title: "Faild", message: "some message")
                }
            }
            .padding()
            
            MgcPopups(willShowModel: $model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
