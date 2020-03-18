//
//  HomeViewController.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/11.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var commentArray: [CommentData] = []
    
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")

        if Auth.auth().currentUser != nil {
            if listener == nil {
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    
                    self.tableView.reloadData()
                }
                
                let commentsRef = Firestore.firestore().collection(Const.CommentPath).order(by: "date", descending: true)
            }
            
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
        
        cell.commentButton.addTarget(self, action:#selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")

        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let postData = postArray[indexPath!.row]

        if let myid = Auth.auth().currentUser?.uid {
            var updateValue: FieldValue
            if postData.isLiked {
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                updateValue = FieldValue.arrayUnion([myid])
            }
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")

        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let postData = postArray[indexPath!.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
        /*
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        commentViewController.contributorName = postData.name
        commentViewController.postId = postData.id
        self.present(commentViewController, animated: true, completion: nil)
 */
        var alertTextField: UITextField?

            let alert = UIAlertController(
                title: "\(postData.name)さんにコメント",
                message: "コメント内容を入力",
                preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    alertTextField = textField
                    textField.text = self.label1.text
            })
            alert.addAction(
                UIAlertAction(
                    title: "キャンセル",
                    style: UIAlertAction.Style.cancel,
                    handler: nil))
            alert.addAction(
                UIAlertAction(
                    title: "コメントする",
                    style: UIAlertAction.Style.default) { _ in
                    if let text = alertTextField?.text {
                        self.label1.text = text
                        let commentRef = Firestore.firestore().collection(Const.CommentPath).document()
                        SVProgressHUD.show()
                        let name = Auth.auth().currentUser?.displayName
                        let commentDic = [
                            "postId" : postData.id,
                            "name" : name!,
                            "comment" : text,
                            "date" : FieldValue.serverTimestamp(),
                            ] as [String : Any]
                        commentRef.setData(commentDic)
                        SVProgressHUD.showSuccess(withStatus: "コメントしました")
                        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            )

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
