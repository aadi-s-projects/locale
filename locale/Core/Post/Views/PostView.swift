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
    @State private var tag: String = ""
    @State private var description: String = ""
    @EnvironmentObject var localSearchService:  LocalSearchService
    @State private var selectedLandmark : Landmark?
    
    @EnvironmentObject var viewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
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
                Form {
                    if selectedLandmark != nil {
                        NavigationLink {
                            MapSearchView(selectedLandmark: $selectedLandmark)
                                .environmentObject(LocalSearchService())
                                .environmentObject(PostViewModel())
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text(selectedLandmark!.name)
                        }
                    } else {
                        NavigationLink("Select Address") {
                            MapSearchView(selectedLandmark: $selectedLandmark)
                                .environmentObject(LocalSearchService())
                                .environmentObject(PostViewModel())
                                .navigationBarBackButtonHidden()
                        }
                    }
                    TextField("Vibe", text: $tag)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(5)
                    Button("Post") {
                        let geoPoint = GeoPoint(latitude: selectedLandmark!.coordinate.latitude, longitude: selectedLandmark!.coordinate.longitude)
                        let post = Post(name: selectedLandmark!.name, title: selectedLandmark!.title, coordinate: geoPoint, tag: tag, description: description)
                        Task {
                            try await self.viewModel.addPost(post: post)
                            tabSelection = 1
                        }
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .cornerRadius(8)
                .scrollDisabled(true)
            }
        }
    }
}

extension PostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return selectedLandmark != nil && !description.isEmpty
    }
}

#Preview {
    PostView(tabSelection: .constant(2))
        .environmentObject(LocalSearchService())
        .environmentObject(PostViewModel())
}
