//
//  MindYourScreenApp.swift
//  MindYourScreen
//
//  Created by Mac on 29/08/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import ActivityKit
import UIKit

@main
struct MindYourScreenApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    print("Firebase is configured...!")
//    return true
//  }
//}
