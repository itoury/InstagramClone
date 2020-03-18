//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/14.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCommentData(_ postData: PostData, _ commentData: CommentData,  _ text: String) {
        let commentRef = Firestore.firestore().collection(Const.CommentPath).document()
        let name = Auth.auth().currentUser?.displayName
        
        self.commenterNameLabel.text = name!
        self.commentLabel.text = text
        
        let commentDic = [
            "postId" : postData.id,
            "name" : name!,
            "comment" : text,
            "date" : FieldValue.serverTimestamp(),
            ] as [String : Any]
        commentRef.setData(commentDic)
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
