//
//  CommentDisplayView.swift
//  locale
//
//  Created by Sachin Gala on 7/9/24.
//

import SwiftUI

struct CommentDisplayView: View {
    let comment : PostComment
    
    var body: some View {
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

#Preview {
    CommentDisplayView(comment: PostComment(id: "id", userCreator: "creator", comment: "comment"))
}
