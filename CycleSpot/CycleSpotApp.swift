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
      print("✅ Firebase configured successfully")

    return true

  }

}


@main
struct CycleSpotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var rackView = BikeRackView()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rackView)
        }
    }
}

