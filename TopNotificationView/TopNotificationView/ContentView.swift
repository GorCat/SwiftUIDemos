//
//  ContentView.swift
//  TopNotificationView
//
//  Created by GorCat on 2023/4/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            MgcPopups(imageName: "mgc_popups_Notification", title: "Success", message: "This is a message")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
