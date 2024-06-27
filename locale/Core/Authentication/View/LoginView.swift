//
//  LoginView.swift
//  locale
//
//  Created by Sachin Gala on 6/25/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Form {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                    Button("Log In") {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .cornerRadius(8)
                .scrollDisabled(true)
                
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Sign Up")
                }
            }
            .padding()
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
}
