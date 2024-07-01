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
    @State private var tabSelection = 1
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                TabView (selection: $tabSelection) {
                    MapView(tabSelection: $tabSelection)
                        .environmentObject(PostViewModel())
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }
                        .tag(1)
                    PostView(tabSelection: $tabSelection)
                        .environmentObject(PostViewModel())
                        .environmentObject(LocalSearchService())
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Post")
                        }
                        .tag(2)
                    ProfileView(tabSelection: $tabSelection)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(3)
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
