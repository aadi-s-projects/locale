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
            Spacer()
            
            HStack{
                Text("welcome to locale")
                    .font(Font.custom("Manrope-Medium", size: CGFloat(30)))
                Spacer()
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.horizontal, 5)
            }
            .padding(.bottom)
            
            CustomTextFieldView(titleKey: "full name", textSize: 18, text: $fullname)
                .padding(.bottom, 5)
                .autocorrectionDisabled()
            CustomTextFieldView(titleKey: "email", textSize: 18, text: $email)
                .padding(.bottom, 5)
                .autocorrectionDisabled()
            CustomSecureFieldView(titleKey: "password", textSize: 18, text: $password)
                .padding(.bottom, 5)
                .autocorrectionDisabled()
            CustomSecureFieldView(titleKey: "confirm password", textSize: 18, text: $confirmation)
                .padding(.bottom, 5)
                .autocorrectionDisabled()
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                }
            } label: {
                CustomButtonLabel(label: "sign up", textSize: 18, disabled: !formIsValid)
            }
            .disabled(!formIsValid)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                CustomButtonLabel(label: "log in", textSize: 18, primary: false)
            }
        }
        .padding()
        .preferredColorScheme(.dark)
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
