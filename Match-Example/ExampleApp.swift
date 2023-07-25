//
//  Match_ExampleApp.swift
//  Match-Example
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
        
        Router.shared.register("match://tab1") { _ in
            Text("Tab1")
        }
        Router.shared.register("match://tab2") { _ in
            Text("Tab2")
        }
        Router.shared.register("match://tab3") { _ in
            Text("Tab3")
        }
        Router.shared.register("match://tab4") { _ in
            Text("Tab4")
        }
        
        return true
    }
}
