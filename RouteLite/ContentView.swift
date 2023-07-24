//
//  ContentView.swift
//  RouteLite
//
//  Created by shayanbo on 2023/7/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var navigation = Navigation()

    var body: some View {
        NavigationStack(path: $navigation.path) {
            Page1()
                .enableRoute(navigation)
        }
        .environmentObject(navigation)
        .onAppear {
            navigation.register("page1") { Page1() }
            navigation.register("page2") { Page2() }
            navigation.register("page3") { Page3() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
