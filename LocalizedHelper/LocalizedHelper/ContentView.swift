//
//  ContentView.swift
//  LocalizedHelper
//
//  Created by GorCat on 2023/6/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    @State var text = ""
    @State var lineSeperator = ",NNNNNNNN"
    @State var itemSeperator = ",GGGGG,"
    
    var state: AppState {
        store.state
    }
    
    var stateBinding: Binding<AppState> {
        $store.state
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Button("Process CSV") {
                    let model = CSVModel(content: text, lineSeperator: lineSeperator, itemSeperator: itemSeperator)
                    
                    store.dispatch(.processCSVString(scvModel: model))
                }
                
                Button("General File") {
                    store.dispatch(.generalFiles)
                }
                
                Button("Clear") {
                    text = ""
                }
            }
            
            HStack {
                TextField("Line Seperator", text: $lineSeperator)
                TextField("Item Seperator", text: $itemSeperator)
            }
            TextEditor(text: $text)
                .frame(height: 300)
            resultsList
                .frame(height: 300)
        }
        .padding()
    }
    
    var resultsList: some View {
        
        List(stateBinding.results) { modelBinding in
            let model = modelBinding.wrappedValue
            HStack(alignment: .bottom) {
                Text(model.key)
                    .textSelection(.enabled)
                
                Spacer()
                
                Text(model.en)
                    .textSelection(.enabled)
                
                Spacer()
                
                Text(model.ar)
                    .textSelection(.enabled)
                Spacer()
                
                Text(model.tr)
                    .textSelection(.enabled)
            }
            .border(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}
