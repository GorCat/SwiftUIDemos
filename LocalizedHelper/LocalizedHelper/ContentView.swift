//
//  ContentView.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    @State var step = 1
    
    var state: AppState {
        store.state
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("1.Process CSV") {
                    step = 2
                    store.dispatch(.processLanguageFiles)
                }
                
                Button("2.Conbine Datas") {
                    step = 3
                    store.dispatch(.conbineDatas)
                }
                
                Button("3.General Files") {
                    store.dispatch(.generalFiles)
                }
            }
            
            if step < 3 {
                lanuageFilesView
            } else {
                combineDatasView
            }
            
        }
        .padding()
    }
    
    var combineDatasView: some View {
        List(state.allKeys, id:\.self) { key in
            HStack(alignment: .bottom) {
                Text(key)
                    .textSelection(.enabled)
                
                Spacer()
                
                Text(state.enDictionary[key] ?? "")
                    .textSelection(.enabled)
                
                Spacer()
                
                Text(state.arDictionary[key] ?? "")
                    .textSelection(.enabled)
            }
            .border(.blue)
        }
    }
    
    var lanuageFilesView: some View {
        HStack {
            keyValueListView("Enum", keys: state.enumKeys, values: state.enumValues)
            keyValueListView("CSV", keys: state.enFileValues, values: state.arFileValues)
        }
    }
    
    func keyValueListView(_ title: String, keys: [String], values: [String]) -> some View {
        VStack {
            Text(title)
                .fontWeight(.semibold)
            List(keys.indices, id: \.self) { index in
                Text("\(keys[index])    \(values[index])")

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
