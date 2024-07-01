//
//  ContentView.swift
//  locale
//
//  Created by Sachin Gala on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var postViewModel : PostViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                TabView {
                    MapView()
                        .environmentObject(PostViewModel())
                        .environmentObject(LocalSearchService())
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
