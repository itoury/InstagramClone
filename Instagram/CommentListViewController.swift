//
//  CommentListViewController.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/18.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class CommentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var postData: PostData!
    var commentsArray: [CommentData] = []
    
    var listener: ListenerRegistration!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postNib, forCellReuseIdentifier: "PostCell")
        let commentNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(commentNib, forCellReuseIdentifier: "CommentCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DEBUG_PRINT: viewWillAppear")

        if Auth.auth().currentUser != nil {
            if listener == nil {
                let commentsRef = Firestore.firestore().collection(Const.PostPath).document(self.postData.id).collection(Const.CommentPath).order(by: "date", descending: true)
                listener = commentsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    self.commentsArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let commentData = CommentData(document: document)
                        return commentData
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                commentsArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            //cell.commentListButton.isHidden = true
            cell.setPostData(self.postData)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell.setCommentData(commentsArray[indexPath.row - 1])
            return cell
        }
    }
}
