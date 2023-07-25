//
//  Router.swift
//  RouteLite
//
//  Created by shayanbo on 2023/7/24.
//

import Foundation
import SwiftUI

public class Router {
    
    public enum Result {
        case none
        case target(AnyView)
        case forward(String)
    }
    
    public static let shared = Router()
    
    fileprivate var routes = [String: (RouterURLInfo)-> Result]()
    
    fileprivate var transfers = [String: (String)->String]()
    
    public func match(_ path: String) -> AnyView? {
        guard let result = try? resolve(path) else {
            return nil
        }
        switch result {
        case .none: return nil
        case .forward(let path):
            return match(path)
        case .target(let view):
            return view
        }
    }
    
    public func resolve(_ path: String) throws -> Result {
        
        var path = path
        
        if path.hasPrefix("http") || path.hasPrefix("https") {
            path = transfer(path)
        }
        
        let routerURLInfo = try parse(path)
        
        guard let content = lookup(routerURLInfo.path) else {
            throw Error.notRegistered
        }
        
        return content(routerURLInfo)
    }
    
    public func register(_ path: String, content: @escaping (RouterURLInfo)-> Result) {
        guard routes[path] == nil else {
            fatalError("Router has been registered [\(path)]")
        }
        routes[path] = content
    }
    
    public func register(_ path: String, content: @escaping (RouterURLInfo)->String) {
        register(path) {
            .forward(
                content($0)
            )
        }
    }
    
    public func register(_ path: String, content: @escaping (RouterURLInfo)->some View) {
        register(path) {
            .target(
                AnyView(content($0))
            )
        }
    }
    
    private func lookup(_ path: String) -> ((RouterURLInfo)-> Result)? {
        if let content = routes[path] {
            return content
        }
        
        let lookupComponents = path.components(separatedBy: "/")
        
        let key = routes.keys.filter { rulePath in
            rulePath.components(separatedBy:"/").contains { component in
                component.hasSuffix("}") || component.hasPrefix("{")
            }
        }.first { fuzzyPath in
            let fuzzyComponents = fuzzyPath.components(separatedBy: "/")
            if fuzzyComponents.count != lookupComponents.count {
                return false
            }
            for i in 0..<fuzzyComponents.count {
                let lookupComponent = lookupComponents[i]
                let fuzzyComponent = fuzzyComponents[i]
                if !fuzzyComponent.hasPrefix("{") && !fuzzyComponent.hasSuffix("}") {
                    if fuzzyComponent != lookupComponent {
                        return false
                    }
                }
            }
            return true
        }
        
        guard let key = key else {
            return nil
        }
        
        return routes[key]
    }
}

public extension Router {
    
    enum Error: Swift.Error {
        case invalidateUrl
        case notRegistered
    }
}

public extension Router {
    
    func registerHttpTransfer(_ host: String, transfer: @escaping (String)->String) {
        guard transfers[host] == nil else {
            fatalError("Transfer has been registered [\(host)]")
        }
        transfers[host] = transfer
    }
    
    fileprivate func transfer(_ url: String) -> String {
        guard let components = URLComponents(string: url) else {
            return url
        }
        guard let host = components.host else {
            return url
        }
        guard let transferTask = transfers[host] else {
            if let defaultTask = transfers["*"] {
                return defaultTask(url)
            } else {
                return url
            }
        }
        return transferTask(url)
    }
}

extension Router {
    
    public struct RouterURLInfo {
        public let path: String
        public let params: [String:String]
    }
    
    fileprivate func parse(_ path: String) throws -> RouterURLInfo {
        guard let url = URL(string: path) else {
            throw Error.invalidateUrl
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw Error.invalidateUrl
        }
        
        guard let queryItems = components.queryItems else {
            return RouterURLInfo(path: path, params: [:])
        }
        
        var params = [String:String]()
        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value
        }
        components.query = nil
        return RouterURLInfo(path: components.string!, params: params)
    }
}
