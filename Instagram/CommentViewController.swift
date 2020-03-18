//
//  CommentViewController.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/14.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    var contributorName: String!
    var postId: String!
    
    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func handleCommentButton(_ sender: Any) {
        let commentRef = Firestore.firestore().collection(Const.CommentPath).document()
        SVProgressHUD.show()
        let name = Auth.auth().currentUser?.displayName
        let commentDic = [
            "postId" : self.postId!,
            "name" : name!,
            "comment" : self.commentTextField.text!,
            "date" : FieldValue.serverTimestamp(),
            ] as [String : Any]
        commentRef.setData(commentDic)
        SVProgressHUD.showSuccess(withStatus: "コメントしました")
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contributorNameLabel.text = ">>\(contributorName!)さんにコメント"
    }

}
