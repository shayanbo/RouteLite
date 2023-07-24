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

/// Router
extension Navigation {
    
    fileprivate struct RoutePath : Hashable {
        let path: String
    }
    
    func process(_ p: String) {
        
        guard let result = try? Router.shared.resolve(p) else {
            return
        }
        switch result {
        case .none: return
        case .forward(let path):
            return process(path)
        case .target(_):
            path.append(RoutePath(path: p))
        }
    }
}

//IMPORTANT: called by the root view of NavigationStack
extension View {
    func enableRouter(_ router: Router = .shared) -> some View {
        navigationDestination(for: Navigation.RoutePath.self) { routePath in
            if let result = try? router.resolve(routePath.path) {
                if case let .target(view) = result {
                    AnyView(view)
                }
            }
        }
    }
}

