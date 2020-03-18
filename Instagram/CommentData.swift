//
//  CommentData.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/14.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class CommentData: NSObject {
    var commentId: String
    var postId: String?
    var name: String?
    var comment: String?
    var date: Date?

    init(document: QueryDocumentSnapshot) {
        self.commentId = document.documentID
        let commentDic = document.data()
        self.postId = commentDic["postId"] as? String
        self.name = commentDic["name"] as? String
        self.comment = commentDic["comment"] as? String

        let timestamp = commentDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
}
