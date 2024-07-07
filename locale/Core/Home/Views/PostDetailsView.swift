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
    
    var body: some View {
        VStack{
            HStack{
                VStack (alignment: .leading){
                    Text(post.name)
                        .font(Font.custom("Manrope-Bold", size: CGFloat(50)))
                    Text(post.title)
                        .font(Font.custom("Manrope-Light", size: CGFloat(25)))
                        .opacity(0.5)
                    Text(post.description)
                        .font(Font.custom("Manrope-Light", size: CGFloat(30)))
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
    PostDetailsView(post: Post(name: "Starbucks", title: "123 Sesame St.", coordinate: GeoPoint(latitude: 37.33233141, longitude: -122.03121860), tag: "chill", description: "nice hang out spot"))
}
