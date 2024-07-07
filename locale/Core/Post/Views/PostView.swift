//
//  PostView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

struct PostView: View {
    @State private var search: String = ""
    @State private var tag: String? = nil
    @State private var description: String = ""
    @EnvironmentObject var localSearchService:  LocalSearchService
    @State private var selectedLandmark : Landmark?
    
    @EnvironmentObject var viewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("post")
                        .font(Font.custom("Manrope-Bold", size: 30))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom)
                
                NavigationLink {
                    MapSearchView(selectedLandmark: $selectedLandmark)
                        .environmentObject(LocalSearchService())
                        .environmentObject(PostViewModel())
                        .navigationBarBackButtonHidden()
                } label: {
                    if selectedLandmark != nil {
                        CustomButtonLabel(label: selectedLandmark!.name, textSize: 18, primary: false)
                    } else {
                        CustomButtonLabel(label: "select location", textSize: 18)
                    }
                }
                .padding(.bottom, 5)
                
                DropDownView(hint: "select vibe", options: ["chill", "busy", "day", "night"], selection: $tag)
                    .padding(.bottom, 5)
                
                CustomTextFieldView(titleKey: "description", textSize: 18, textEditor: true, text: $description)
                    .padding(.bottom, 5)
                
                Button {
                    
                } label: {
                    CustomButtonLabel(label: "select image", textSize: 18)
                }
                
                Button {
                    let geoPoint = GeoPoint(latitude: selectedLandmark!.coordinate.latitude, longitude: selectedLandmark!.coordinate.longitude)
                    let post = Post(name: selectedLandmark!.name, title: selectedLandmark!.title, coordinate: geoPoint, tag: tag!.lowercased(), description: description.lowercased())
                    Task {
                        try await self.viewModel.addPost(post: post)
                        tabSelection = 1
                    }
                } label: {
                    CustomButtonLabel(label: "post", textSize: 18, disabled: !formIsValid)
                }
                .disabled(!formIsValid)
                .padding(.bottom)
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

extension PostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return selectedLandmark != nil && !description.isEmpty && tag != nil
    }
}

#Preview {
    PostView(tabSelection: .constant(2))
        .environmentObject(LocalSearchService())
        .environmentObject(PostViewModel())
}
