//
//  SignUpView.swift
//  locale
//
//  Created by Aadi Gala on 6/26/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmation: String = ""
    @State private var fullname: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Form {
                TextField("Full Name", text: $fullname)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmation)
                Button("Sign Up") {
                    Task {
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                    }
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .cornerRadius(8)
            .scrollDisabled(true)
            
            Button {
                dismiss()
            } label: {
                Text("Log In")
            }

        }
        .padding()
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5 && !fullname.isEmpty && confirmation == password
    }
}

#Preview {
    SignUpView()
}
