//
//  RouterStorage.swift
//  Router
//
//  Created by shayanbo on 2023/7/25.
//

import Foundation

struct Storage {
    
    struct Scheme {
        
        struct Host {
            
            struct PathComponent {
                
                var content: ( (Router.RouterURLInfo)-> Router.Result )?
                
                var subComponents = [String: PathComponent]()
            }
            
            var paths = [String: PathComponent]()
        }
        
        var hosts = [String: Host]()
    }
    
    var schemes = [String: Scheme]()
}

extension Storage {
    
    mutating func add(_ urlString: String) {
        
        guard let url = URLComponents(string: urlString) else {
            return
        }
        
        guard let scheme = url.scheme, let host = url.host else {
            return
        }
        
        if self.schemes[scheme] == nil {
            self.schemes[scheme] = Scheme()
        }
        
        if self.schemes[scheme]?.hosts[host] == nil {
            self.schemes[scheme]?.hosts[host] = Scheme.Host()
        }
        
        guard var components = self.schemes[scheme]?.hosts[host]?.paths else {
            return
        }
        
        let originalPaths = components
        let newPaths = url.path.components(separatedBy: "/")
        for newPath in newPaths {
            if components[newPath] == nil {
                components[newPath] = Scheme.Host.PathComponent()
            }
        }
    }
}
