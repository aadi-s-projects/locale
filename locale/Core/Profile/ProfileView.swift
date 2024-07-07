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
    
    @Binding var tabSelection: Int
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack() {
                Button
                {
                    showingDeleteAlert = true
                } label: {
                    CustomButtonLabel(label: "delete account", textSize: 18, primary: false, textColor: .red)
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
                
                Spacer()
                
                HStack{
                    VStack (alignment: .leading){
                        Text(user.fullname.lowercased())
                            .font(Font.custom("Manrope-Bold", size: CGFloat(60)))
                        Text(user.email.lowercased())
                            .font(Font.custom("Manrope-Light", size: CGFloat(30)))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
                
                Button
                {
                    viewModel.signOut()
                } label: {
                    CustomButtonLabel(label: "log out", textSize: 18)
                }
                .padding(.bottom, 150)
                
                
                Spacer()
                
                
            }
            .preferredColorScheme(.dark)
            .padding()
        }
    }
}

#Preview {
    ProfileView(tabSelection: .constant(3))
        .environmentObject(AuthViewModel())
}
