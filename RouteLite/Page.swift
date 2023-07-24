//
//  Page1.swift
//  hit_test
//
//  Created by shayanbo on 2023/7/24.
//

import SwiftUI

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

struct Page1: View {
    
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        Form {
            Cell("Go To Page2")
                .onTapGesture {
                    navigation.process("page2")
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
                    navigation.popTo(2)
                }
        }
        .navigationBarTitle("Page1")
    }
}

struct Page2: View {
    
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        Form {
            Cell("Go To Page3")
                .onTapGesture {
                    navigation.process("page3")
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
                    navigation.popTo(2)
                }
        }
        .navigationBarTitle("Page2")
    }
}

struct Page3: View {
    
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        Form {
            Cell("Go To Page1")
                .onTapGesture {
                    navigation.process("page1")
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
                    navigation.popTo(2)
                }
        }
        .navigationBarTitle("Page3")
    }
}
