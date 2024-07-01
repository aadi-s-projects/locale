//
//  PostViewModel.swift
//  locale
//
//  Created by Sachin Gala on 7/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class PostViewModel : ObservableObject {
    @Published var posts = [Post]()
    
    private var db = Firestore.firestore()
    
    func fetchData() async {
        do {
            let querySnapshot = try await db.collection("posts").getDocuments()
            for document in querySnapshot.documents {
                let post = try document.data(as: Post.self)
                posts.append(post)
            }
        } catch {
          print("Error getting documents: \(error)")
        }

    }
    
    func addPost(post: Post) async throws {
        do {
            let encodedPost = try Firestore.Encoder().encode(post)
            try await Firestore.firestore().collection("posts").document(post.id!).setData(encodedPost)
        } catch {
            print("DEBUG: Failed to create post with error \(error.localizedDescription)")
        }
    }
}
