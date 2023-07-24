//
//  Router.swift
//  RouteLite
//
//  Created by shayanbo on 2023/7/24.
//

import Foundation
import SwiftUI

class Router {
    
    enum Result {
        case none
        case target(any View)
        case forward(String)
    }
    
    static let shared = Router()
    
    fileprivate var routes = [String: (RouterURLInfo)-> Result]()
    
    func resolve(_ path: String) throws -> Result {
        
        let routerURLInfo = try parse(path)
        
        guard let content = routes[routerURLInfo.path] else {
            throw Error.notRegistered
        }
        
        return content(routerURLInfo)
    }
    
    func register(_ path: String, content: @escaping (RouterURLInfo)-> Result) throws {
        guard routes[path] == nil else {
            fatalError("Router has been registered [\(path)]")
        }
        routes[path] = content
    }
}

extension Router {
    
    enum Error: Swift.Error {
        case invalidateUrl
        case notRegistered
    }
}

extension Router {
    
    struct RouterURLInfo {
        let path: String
        let params: [String:String]
    }
    
    func parse(_ path: String) throws -> RouterURLInfo {
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
