//
//  PostView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI
import MapKit

struct PostView: View {
    @State private var search: String = ""
    @State private var tag: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationStack {
            VStack { 
                HStack{
                    Text("Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        
                    }
                    .padding(.horizontal)
                
                List(1...20, id: \.self) { index in
                    Text("Landmarks will be displayed here.")
                }
                
                Spacer()
                /*
                Form {
                    TextField("Tag", text: $tag)
                    TextEditor(text: $description)
                    Button("Post") {
                        
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .cornerRadius(8)
                .scrollDisabled(true)
                 */
            }
        }
    }
}

extension PostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return true
    }
}

#Preview {
    PostView()
}
