//
//  localeApp.swift
//  locale
//
//  Created by Sachin Gala on 6/25/24.
//

import SwiftUI
import Firebase

@main
struct localeApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
