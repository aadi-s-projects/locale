//
//  CustomSecureFieldView.swift
//  locale
//
//  Created by Sachin Gala on 7/4/24.
//

import SwiftUI

struct CustomSecureFieldView: View {
    var titleKey : String
    var textSize : Int
    @Binding var text: String
    var body: some View {
        SecureField(titleKey, text: $text, prompt: Text(titleKey).foregroundStyle(Color.gray))
                .padding()
                .border(Color(UIColor.systemGray4), width: 0.5)
                .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                .textInputAutocapitalization(.never)
    }
}

#Preview {
    CustomSecureFieldView(titleKey : "preview", textSize: 18, text: .constant(""))
}
