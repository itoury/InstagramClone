//
//  PostData.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/14.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()

        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()

        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            if self.likes.firstIndex(of: myid) != nil {
                self.isLiked = true
            }
        }
    }
}
