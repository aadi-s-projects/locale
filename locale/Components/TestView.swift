//
//  TestView.swift
//  locale
//
//  Created by Sachin Gala on 7/12/24.
//

import SwiftUI
import WrappingHStack

struct TestView: View {
    var body: some View {
        WrappingHStack {
            Text("WrappingHStack")
                .padding()
                .font(.title)
                .border(Color.black)
            
            Text("can handle different element types")
            
            Image(systemName: "scribble")
                .font(.title)
                .frame(width: 200, height: 20)
                .background(Color.purple)
            
            Text("and loop")
                .bold()
            
            WrappingHStack(1...20, id:\.self) {
                Text("Item: \($0)")
                    .padding(3)
                    .background(Rectangle().stroke())
            }.frame(minWidth: 250)
        }
        .padding()
        .border(Color.black)
    }
}

#Preview {
    TestView()
}

/*
 //
 //  DropDownView.swift
 //  locale
 //
 //  Created by Sachin Gala on 6/30/24.
 //

 import SwiftUI
 import WrappingHStack

 struct DropDownView: View {
     var hint: String
     var options: [String]
     @Binding var selections: [String]
     @State private var showOptions: Bool = false
     @Environment(\.colorScheme) private var scheme
     @SceneStorage("drop_down_zindex") private var index = 1000.0
     @State private var zIndex: Double = 1000.0
     
     var body: some View {
         VStack {
             WrappingHStack(selections.indices, id: \.self, spacing: .constant(0)) { index in
                 Group {
                     Button {
                         selections.remove(at: index)
                     } label: {
                         HStack {
                             Text("\(selections[index])  X")
                                 .font(Font.custom("Manrope-Light", size: 18))
                         }
                         .padding(.horizontal, 10)
                         .padding(.vertical, 5)
                         .background(.white)
                         .foregroundStyle(.black)
                     }
                 }
                 .padding(4)
             }
             
             GeometryReader {
                 let size = $0.size
                 VStack(spacing: 0) {
                     HStack(spacing: 0) {
                         Text(hint)
                             .foregroundStyle(.gray)
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
                     
                     if showOptions {
                         OptionsView()
                     }
                 }
                 .clipped()
                 .contentShape(.rect)
                 .background(.black, in: .rect(cornerRadius: 0))
                 .frame(height: size.height, alignment: .top)
                 .border(Color(UIColor.systemGray4), width: 0.5)
                 
             }
             .frame(height: 60)
             .zIndex(zIndex)
         }
     }
     
     @ViewBuilder
     func OptionsView() -> some View {
         VStack(spacing: 0) {
             WrappingHStack(options, id: \.self, spacing: .constant(0)) { option in
                 if !selections.contains(option) {
                     Button {
                         selections.append(option)
                     } label: {
                         Group {
                             HStack {
                                 Text("+ \(option.lowercased())")
                                     .font(Font.custom("Manrope-Light", size: 18))
                             }
                             .padding(.horizontal, 10)
                             .padding(.vertical, 5)
                             .background(.white)
                             .foregroundStyle(.black)
                         }
                         .padding(4)
                     }
                 }
             }
         }
         .padding()
         .transition(.move(edge: .top))
     }
     
     enum Anchor {
         case top
         case bottom
     }
 }

 #Preview {
     struct BindingViewExamplePreviewContainer : View {
         @State private var selections : [String] = []
         
         var body: some View {
             DropDownView(hint: "hint", options: ["test1", "test2", "test3", "test4", "test5", "test6"], selections: $selections)
                 .padding()
         }
     }

     return BindingViewExamplePreviewContainer()
 }

 */
