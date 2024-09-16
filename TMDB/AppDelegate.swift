//
//  AppDelegate.swift
//  TMDB
//
//  Created by Francisco Obarrio on 15/09/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        // Show Loader
        self.startLoaderView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startMainAppFlow()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func startMainAppFlow() {
        // Create the main navigation controller to be used for our app
        let navController = UINavigationController()
        
        // Initialize the coordinator with the navController and keep a strong reference to it
        coordinator = AppCoordinator()
        coordinator?.start()
        
        // Transition to the main app flow
        window?.rootViewController = navController
    }
    
    private func startLoaderView() {
        // Let's show the loader VC First
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoaderVC")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}

