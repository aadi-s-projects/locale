//
//  CustomButton.swift
//  locale
//
//  Created by Sachin Gala on 7/4/24.
//

import SwiftUI

struct CustomButtonLabel: View {
    let label: String
    var textSize : Int
    var disabled : Bool = false
    var primary : Bool = true
    var textColor : Color = .white

    var body: some View {
        if primary {
            if disabled{
                HStack{
                    Spacer()
                    Text(label)
                        .opacity(disabled ? 0.5 : 1.0)
                        .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemGray5))
            } else {
                HStack{
                    Spacer()
                    Text(label)
                        .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                    Spacer()
                }
                .padding()
                .background(.white)
                .foregroundStyle(.black)
            }
        } else {
            HStack{
                Spacer()
                Text(label)
                    .font(Font.custom("Manrope-Light", size: CGFloat(textSize)))
                Spacer()
            }
            .padding()
            .border(Color(UIColor.systemGray4), width: 0.5)
            .foregroundStyle(textColor)
        }
    }
}

#Preview {
    CustomButtonLabel(label: "press me", textSize: 18, disabled: true)
}
