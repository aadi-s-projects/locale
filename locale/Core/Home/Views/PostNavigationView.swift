//
//  PostNavigationView.swift
//  locale
//
//  Created by Sachin Gala on 7/10/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI

struct PostNavigationView: View {
    @EnvironmentObject var viewModel : PostViewModel

    @FirestoreQuery(collectionPath: "posts") var photos: [Photo]
    @FirestoreQuery(collectionPath: "comments") var comments: [PostComment]

    var selectedPost : Post
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack{
                    VStack (alignment: .leading){
                        Text(selectedPost.name)
                            .font(Font.custom("Manrope-Bold", size: CGFloat(40)))
                        Text(selectedPost.title)
                            .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                            .opacity(0.5)
                        Text("Posts:")
                            .font(Font.custom("Manrope-Bold", size: CGFloat(25)))
                            .padding(.top, 5)
                    }
                    Spacer()
                }
                .padding()
                ScrollView {
                    VStack  (spacing: 0){
                        ForEach(viewModel.posts.sorted(by: { lhs, rhs in
                            lhs.tags == selectedPost.tags
                        }), id: \.self) { post in
                            if post.title == selectedPost.title {
                                NavigationLink{
                                    PostDetailsView(post: post, photos: photos, comments: comments)
                                        .environmentObject(PostViewModel())
                                        .environmentObject(AuthViewModel())
                                        .onAppear {
                                            $photos.path = "posts/\(post.id!)/photos"
                                            $comments.path = "posts/\(post.id!)/comments"
                                        }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack{
                                                Text("vibe: \(post.tags.joined(separator: ", "))")
                                                    .font(Font.custom("Manrope-Bold", size: CGFloat(18)))
                                                    .foregroundStyle(.white)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text("by: \(post.userCreator.lowercased())")
                                                    .font(Font.custom("Manrope-Bold", size: CGFloat(18)))
                                                    .foregroundStyle(.white)
                                                    .lineLimit(1)
                                            }
                                            Text(post.description.lowercased())
                                                .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                                                .foregroundStyle(.white)
                                                .lineLimit(2)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 5)
                                    }
                                    .padding()
                                    .border(Color(UIColor.systemGray4), width: 0.5)
                                }
                            }
                        }
                    }
                }
            }
            .background(.black)
        }
        .onAppear() {
            Task {
                await self.viewModel.fetchData()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapView(tabSelection: .constant(1))
        .environmentObject(PostViewModel())
}
