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
}

/// NavigationController
extension Navigation {
    
    public func push<Data>(_ data: Data) where Data :  Hashable {
        path.append(data)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popTo(_ count: Int) {
        path.removeLast(count)
    }
    
    public func popToRoot() {
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
extension Navigation {
    
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
extension View {
    func enableRouter(_ router: Router = .shared) -> some View {
        navigationDestination(for: RoutePath.self) { routePath in
            AnyView(routePath.resolvedView)
        }
    }
}

