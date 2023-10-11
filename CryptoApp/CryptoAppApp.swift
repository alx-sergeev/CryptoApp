//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 11.09.2023.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject private var homeVM = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeVM)
        }
    }
}
