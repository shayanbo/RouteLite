//
//  RouteLiteApp.swift
//  RouteLite
//
//  Created by shayanbo on 2023/7/24.
//

import SwiftUI
import Router

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
        
        Router.shared.register("page1") { _ in
            Page(title: "Page1", linkTitle: "Go To Page2", url: "page2")
        }
        Router.shared.register("page2") { _ in
            Page(title: "Page2", linkTitle: "Go To Page3", url: "page3")
        }
        Router.shared.register("page3") { _ in
            Page(title: "Page3", linkTitle: "Go To Page1", url: "page1")
        }
        Router.shared.register("page") { routerURLInfo in
            guard let idxString = routerURLInfo.params["idx"], let idx = Int(idxString) else {
                return .none
            }
            if idx == 1 {
                return .forward("page2")
            } else if idx == 2 {
                return .forward("page3")
            } else if idx == 3 {
                return .forward("page1")
            } else {
                return .none
            }
        }
        
        return true
    }
}
