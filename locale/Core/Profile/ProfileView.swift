//
//  ProfileView.swift
//  locale
//
//  Created by Sachin Gala on 6/26/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(spacing: 50) {
                Text(user.fullname)
                Text(user.email)
                Button("Log Out")
                {
                    viewModel.signOut()
                }
                Button("Delete Account")
                {
                    showingDeleteAlert = true
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Confirm Account Deletion?"),
                        message: Text("There is no undoing this action"),
                        primaryButton: .destructive(Text("Delete")) {
                            Task{
                                await viewModel.deleteAccount()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                
            }
        }
    }
}

#Preview {
    ProfileView()
}
