//
//  CycleSpotApp.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 10/15/25.
//

import SwiftUI
import CoreLocation
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct CycleSpotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
