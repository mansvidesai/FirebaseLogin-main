//
//  FirebaseLoginApp.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 05/12/23.
//

import SwiftUI

import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import FirebaseDynamicLinks
import FacebookCore



class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
          )
    FirebaseApp.configure()
      DynamicLinks.performDiagnostics(completion: nil)

      Messaging.messaging().delegate = self
              UNUserNotificationCenter.current().delegate = self


    return true
  }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           if Auth.auth().canHandleNotification(userInfo) {
               completionHandler(.noData)
               return
           }
           // Handle your app-specific logic here
       }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
          return
        }
        ApplicationDelegate.shared.application(
          UIApplication.shared,
          open: url,
          sourceApplication: nil,
          annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
      }
    
    
}




@main
struct FirebaseLoginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
            
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
