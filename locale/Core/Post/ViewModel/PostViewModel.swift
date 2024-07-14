//
//  PostViewModel.swift
//  locale
//
//  Created by Sachin Gala on 7/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import PhotosUI

@MainActor
class PostViewModel : ObservableObject {
    @Published var posts = [Post]()
    @Published var universalData : UniversalData = UniversalData(validTags: ["loading tags"])

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
    
    func saveImageToPost(post: Post, image: UIImage) async throws
    {
        guard let postID = post.id else { return }
        let photoName = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(postID)/\(photoName)")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.5) else { return }
        
        var imageURLString = ""
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: nil)
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)"
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let collectionString = "posts/\(postID)/photos"
        
        do {
            let newPhoto = Photo(imageURLString: imageURLString)
            let encodedPhoto = try Firestore.Encoder().encode(newPhoto)
            try await db.collection(collectionString).document(photoName).setData(encodedPhoto)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImagesToPost(post: Post, images: [UIImage]) async throws
    {
        for image in images {
            try await saveImageToPost(post: post, image: image)
        }
    }
    
    func saveCommentToPost(post: Post, comment: PostComment) async throws
    {
        guard let postID = post.id else { return }
        let collectionString = "posts/\(postID)/comments"
        
        do {
            let encodedComment = try Firestore.Encoder().encode(comment)
            try await db.collection(collectionString).document(comment.id!).setData(encodedComment)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchUniversalData() async
    {
        do {
            let document = try await db.collection("universalData").document("universalData").getDocument()
            universalData =  try document.data(as: UniversalData.self)
            universalData.validTags.sort()
        } catch {
            print("Error getting tags from Universal Data: \(error)")
            universalData = UniversalData(validTags: ["error"])
        }
    }
}
