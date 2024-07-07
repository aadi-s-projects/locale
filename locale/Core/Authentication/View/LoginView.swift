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
                Spacer()
                
                HStack{
                    Text("welcome to locale")
                        .font(Font.custom("Manrope-Bold", size: CGFloat(30)))
                    Spacer()
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.horizontal, 5)
                }
                .padding(.bottom)
                
                CustomTextFieldView(titleKey: "email", textSize: 18, text: $email)
                    .padding(.bottom, 5)
                    .autocorrectionDisabled()
                CustomSecureFieldView(titleKey: "password", textSize: 18, text: $password)
                    .padding(.bottom, 5)
                    .autocorrectionDisabled()
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    CustomButtonLabel(label: "log in", textSize: 18, disabled: !formIsValid)
                }
                .disabled(!formIsValid)
                
                Spacer()
                
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden()
                } label: {
                    CustomButtonLabel(label: "sign up", textSize: 18, primary: false)
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
    /*
    init() {
        for family in UIFont.familyNames {
            print(family)
            
            for fontName in UIFont.fontNames(forFamilyName: family){
                print("--\(fontName)")
            }
        }
    }
     */
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
}
