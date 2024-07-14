//
//  PostDetailsView.swift
//  locale
//
//  Created by Sachin Gala on 7/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PostDetailsView: View {
    var post : Post
    var photos: [Photo]
    var comments: [PostComment]
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postViewModel : PostViewModel
    @State private var commentText: String = ""
    
    var body: some View {
        VStack{
            ScrollView {
                HStack{
                    VStack (alignment: .leading){
                        Text(post.name)
                            .font(Font.custom("Manrope-Bold", size: CGFloat(40)))
                        Text(post.title)
                            .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                            .opacity(0.5)
                        Text(post.description.lowercased())
                            .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                        if !photos.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(photos) { photo in
                                        let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                                        
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                        } placeholder: {
                                            ProgressView()
                                        }
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
                        Text("posted by: \(post.userCreator.lowercased())")
                            .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                            .opacity(0.5)
                    }
                    Spacer()
                }
                .padding()
                
                VStack(spacing: 0) {
                    ForEach(comments) { comment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("by: \(comment.userCreator.lowercased())")
                                    .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                                    .opacity(0.5)
                                Text(comment.comment.lowercased())
                                    .font(Font.custom("Manrope-Light", size: CGFloat(18)))
                            }
                            Spacer()
                        }
                        .padding()
                        .border(Color(UIColor.systemGray4), width: 0.5)
                    }
                }
            }
            
            Spacer()
            
            HStack(alignment: .bottom) {
                CustomTextFieldView(titleKey: "comment", textSize: 18, textEditor: true, lineLimit: 3, text: $commentText)
            
                Button{
                    let postComment = PostComment(userCreator: authViewModel.currentUser!.fullname, comment: commentText)
                    Task {
                        try await self.postViewModel.saveCommentToPost(post: post, comment: postComment)
                        commentText = ""
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 57, height: 57)
                            .foregroundStyle(.white)
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    .padding(.leading, 5)
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .padding()
        }
        .background(.black)
        .preferredColorScheme(.dark)
    }
}

extension PostDetailsView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !commentText.isEmpty
    }
}

#Preview {
    PostDetailsView(post: Post(userCreator: "Test Name", name: "Starbucks", title: "123 Sesame St.", coordinate: GeoPoint(latitude: 37.33233141, longitude: -122.03121860), tags: ["chill"], description: "nice hang out spot"), photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/locale-27533.appspot.com/o/1E22A182-4F14-4D11-8A09-8576C507D66E%2FA1E6CE3E-8754-4493-82C9-12EE6A1AAF08?alt=media&token=0be5a7c9-8ec9-4fb6-8d58-7210c3227ea6"), Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/locale-27533.appspot.com/o/1E22A182-4F14-4D11-8A09-8576C507D66E%2FA1E6CE3E-8754-4493-82C9-12EE6A1AAF08?alt=media&token=0be5a7c9-8ec9-4fb6-8d58-7210c3227ea6")], comments: [PostComment(userCreator: "aadi", comment: "this is a comment"), PostComment(userCreator: "aadi", comment: "this is a comment"), PostComment(userCreator: "aadi", comment: "this is a comment"), PostComment(userCreator: "aadi", comment: "this is a comment"), ])
        .environmentObject(PostViewModel())
        .environmentObject(AuthViewModel())
}
