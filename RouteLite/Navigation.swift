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
    
    fileprivate var routes = [String: ()-> any View]()
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
    
    fileprivate func resolve(_ path: String) -> any View {
        guard let content = routes[path] else {
            fatalError("Route Not Found")
        }
        return content()
    }
    
    func register(_ path: String, content: @escaping ()-> some View) {
        routes[path] = content
    }
    
    func process(_ p: String) {
        path.append(RoutePath(path: p))
    }
}

//IMPORTANT: called by the root view of NavigationStack
extension View {
    func enableRoute(_ navigation: Navigation) -> some View {
        navigationDestination(for: Navigation.RoutePath.self) { routePath in
            AnyView(navigation.resolve(routePath.path))
        }
    }
}
