//
//  ContentView.swift
//  RouteLite
//
//  Created by shayanbo on 2023/7/24.
//

import SwiftUI
import Router

struct ContentView: View {
    
    @StateObject var navigation = Navigation()

    var body: some View {
        NavigationStack(path: $navigation.path) {
            Page(title: "Page1", linkTitle: "Go To Page2", url: "page2")
                .enableRouter()
        }
        .environmentObject(navigation)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
