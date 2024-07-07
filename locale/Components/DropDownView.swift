//
//  DropDownView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI

struct DropDownView: View {
    var hint: String
    var options: [String]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = UIScreen.main.bounds.width - 25
    @Binding var selection: String?
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                if showOptions && anchor == .top {
                    OptionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selection ?? hint)
                        .foregroundStyle(selection == nil ? .gray : .primary)
                        .lineLimit(1)
                        .font(Font.custom("Manrope-Light", size: 18))
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                }
                .padding(.horizontal)
                .frame(width: size.width, height: size.height)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .background(.black)
                .zIndex(10)
                
                if showOptions && anchor == .bottom {
                    OptionsView()
                }
            }
            .clipped()
            .contentShape(.rect)
            .background(.black, in: .rect(cornerRadius: 0))
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
            .border(Color(UIColor.systemGray4), width: 0.5)
            
        }
        .frame(height: 60)
        .zIndex(zIndex)
    }
    
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                VStack{
                    HStack(spacing: 0) {
                        Text(option.lowercased())
                            .font(Font.custom("Manrope-Light", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .opacity(selection == option ? 1 : 0)
                            .font(.caption)
                    }
                    .padding()
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 60)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOptions = false
                    }
                }
                .border(Color(UIColor.systemGray4), width: 0.5)
            }
        }
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
    
    enum Anchor {
        case top
        case bottom
    }
}

#Preview {
    MapView(tabSelection : .constant(1))
}
