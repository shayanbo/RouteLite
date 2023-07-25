//
//  Page1.swift
//  hit_test
//
//  Created by shayanbo on 2023/7/24.
//

import SwiftUI
import Router

struct Cell : View {
    
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct Page: View {
    
    @EnvironmentObject var navigation: Navigation
    
    let title: String
    let linkTitle: String
    let url: String
    
    @State var text = ""
    
    var body: some View {
        Form {
            Cell(linkTitle)
                .onTapGesture {
                    navigation.process(url)
                }
            Cell("Pop")
                .onTapGesture {
                    navigation.pop()
                }
            Cell("Pop To Root")
                .onTapGesture {
                    navigation.popToRoot()
                }
            Cell("Pop Twice")
                .onTapGesture {
                    navigation.pop(count: 2)
                }
            HStack {
                TextField("type in URL here...", text: $text)
                Button("GO") {
                    navigation.process(text)
                }.buttonStyle(.borderedProminent)
            }
        }
        .navigationBarTitle(title)
    }
}
