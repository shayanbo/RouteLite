//
//  ContentView.swift
//  Transfer-Example
//
//  Created by shayanbo on 2023/7/25.
//

import SwiftUI
import Router

struct ContentView: View {
    
    @StateObject var navigation = Navigation()
    
    var body: some View {
        
        NavigationStack(path: $navigation.path) {
            Button("Youtube Video: n4vJ_0B5ssc") {
                navigation.process("https://www.youtube.com/watch?v=n4vJ_0B5ssc")
            }
            .enableRouter()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
