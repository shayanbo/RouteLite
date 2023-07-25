//
//  Navigation.swift
//  hit_test
//
//  Created by shayanbo on 2023/7/24.
//

import Foundation
import SwiftUI

public class Navigation : ObservableObject {
    
    @Published public var path = NavigationPath()
    
    public init() { }
}

/// NavigationController
public extension Navigation {
    
    func push<Data>(_ data: Data) where Data :  Hashable {
        path.append(data)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func pop(count: Int) {
        path.removeLast(count)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

fileprivate struct RoutePath : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
    
    static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        lhs.path == rhs.path
    }
    
    let path: String
    let resolvedView: any View
}

/// Router
public extension Navigation {
    
    func process(_ p: String) {
        
        guard let result = try? Router.shared.resolve(p) else {
            return
        }
        switch result {
        case .none: return
        case .forward(let path):
            return process(path)
        case .target(let view):
            path.append(RoutePath(path: p, resolvedView: view))
        }
    }
}

//IMPORTANT: called by the root view of NavigationStack
public extension View {
    
    func enableRouter() -> some View {
        navigationDestination(for: RoutePath.self) { routePath in
            AnyView(routePath.resolvedView)
        }
    }
}

public struct RouterMatchedView : View {
    
    private let path: String
    
    public init(_ path: String) {
        self.path = path
    }
    
    public var body: some View {
        Router.shared.match(path)
    }
}
