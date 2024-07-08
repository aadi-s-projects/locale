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
    
    var body: some View {
        VStack{
            HStack{
                VStack (alignment: .leading){
                    Text(post.name)
                        .font(Font.custom("Manrope-Bold", size: CGFloat(50)))
                    Text(post.title)
                        .font(Font.custom("Manrope-Light", size: CGFloat(25)))
                        .opacity(0.5)
                    Text(post.description.lowercased())
                        .font(Font.custom("Manrope-Light", size: CGFloat(30)))
                    ScrollView {
                        VStack {
                            ForEach(photos) { photo in
                                let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                                
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
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
                    Text("posted by: \(post.userCreator.lowercased())")
                        .font(Font.custom("Manrope-Light", size: CGFloat(25)))
                        .opacity(0.5)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    PostDetailsView(post: Post(userCreator: "Test Name", name: "Starbucks", title: "123 Sesame St.", coordinate: GeoPoint(latitude: 37.33233141, longitude: -122.03121860), tag: "chill", description: "nice hang out spot"), photos: [])
        .environmentObject(PostViewModel())
}
