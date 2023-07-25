//
//  Transfer_ExampleApp.swift
//  Transfer-Example
//
//  Created by shayanbo on 2023/7/25.
//

import SwiftUI
import Router
import UIKit

@main
struct ExampleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Router.shared.register("youtube://video/{videoId}") { _ in
            Text("Youtube Video Scene")
        }
        
        Router.shared.registerHttpTransfer("www.youtube.com") { originalUrl in
            guard let components = URLComponents(string: originalUrl) else {
                return originalUrl
            }
            if components.path == "/watch" {
                if let videoId = components.queryItems?.first.value {
                    return "youtube://video/\(videoId)"
                }
            }
            return originalUrl
        }
        
        return true
    }
}
