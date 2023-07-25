//
//  ContentView.swift
//  Match-Example
//
//  Created by shayanbo on 2023/7/25.
//

import SwiftUI
import Router

struct ContentView: View {
    var body: some View {
        TabView {
            RouterMatchedView("match://tab1").tabItem {
                Text("A")
            }
            RouterMatchedView("match://tab2").tabItem {
                Text("B")
            }
            RouterMatchedView("match://tab3").tabItem {
                Text("C")
            }
            RouterMatchedView("match://tab4").tabItem {
                Text("D")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
