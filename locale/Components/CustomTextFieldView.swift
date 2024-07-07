//
//  CustomTextFieldView.swift
//  locale
//
//  Created by Sachin Gala on 7/3/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    var titleKey : String
    var textSize : Int
    var textEditor : Bool = false
    var lineLimit : Int = 5
    @Binding var text: String
    var body: some View {
        if !textEditor {
            TextField(titleKey, text: $text, prompt: Text(titleKey).foregroundStyle(Color.gray))
                    .padding()
                    .border(Color(UIColor.systemGray4), width: 0.5)
                    .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                    .textInputAutocapitalization(.never)
        } else {
            TextField(titleKey, text: $text, prompt: Text(titleKey).foregroundStyle(Color.gray), axis: .vertical)
                    .padding()
                    .border(Color(UIColor.systemGray4), width: 0.5)
                    .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                    .textInputAutocapitalization(.never)
                    .lineLimit(lineLimit)
        }
    }
}

#Preview {
    CustomTextFieldView(titleKey : "preview", textSize: 18, text: .constant(""))
}
