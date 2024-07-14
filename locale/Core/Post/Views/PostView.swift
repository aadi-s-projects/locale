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
import PhotosUI

struct PostView: View {
    @State private var tags: [String] = []
    @State private var description: String = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @EnvironmentObject var localSearchService:  LocalSearchService
    @State private var selectedLandmark : Landmark?
    
    @EnvironmentObject var postViewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
    @StateObject var imagePicker = ImagePicker()
    let columns = [GridItem(.adaptive(minimum: 100))]
    @State var loading = false
    
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
                
                DropDownView(hint: "select vibe", options: postViewModel.universalData.validTags, selections: $tags)
                    .padding(.bottom, 5)
                    .zIndex(2)
                
                CustomTextFieldView(titleKey: "description", textSize: 18, textEditor: true, text: $description)
                    .padding(.bottom, 5)
                    .zIndex(1)
                
                PhotosPicker(selection: $imagePicker.imageSelections, maxSelectionCount: 5, matching: .images, photoLibrary: .shared()) {
                    if imagePicker.images.isEmpty {
                        CustomButtonLabel(label: "select images", textSize: 18)
                    } else {
                        CustomButtonLabel(label: "reselect images", textSize: 18, primary: false)
                    }
                }
                .padding(.bottom, 5)
                
                if !imagePicker.images.isEmpty {
                    ScrollView {
                        LazyVGrid (columns: columns, spacing: 20) {
                            ForEach(0..<imagePicker.images.count, id: \.self) { index in
                                imagePicker.images[index]
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .padding(5)
                    }
                    .padding(.vertical, 5)
                    .overlay{
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color(UIColor.systemGray4), style: StrokeStyle(lineWidth: 0.5, dash: [10, 5]))
                    }
                }
                
                Button {
                    loading = true
                    let geoPoint = GeoPoint(latitude: selectedLandmark!.coordinate.latitude, longitude: selectedLandmark!.coordinate.longitude)
                    let post = Post(userCreator: authViewModel.currentUser!.fullname, name: selectedLandmark!.name, title: selectedLandmark!.title, coordinate: geoPoint, tags: tags.sorted(), description: description)
                    Task {
                        try await self.postViewModel.addPost(post: post)
                        try await self.postViewModel.saveImagesToPost(post: post, images: imagePicker.selectedUIImages)
                        selectedLandmark = nil
                        tags = []
                        description = ""
                        imagePicker.images = []
                        imagePicker.selectedUIImages = []
                        loading = false
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
        .onAppear() {
            Task {
                await postViewModel.fetchUniversalData()
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension PostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return selectedLandmark != nil && !description.isEmpty && !tags.isEmpty && !loading
    }
}

#Preview {
    PostView(tabSelection: .constant(2))
        .environmentObject(LocalSearchService())
        .environmentObject(PostViewModel())
        .environmentObject(AuthViewModel())
}
