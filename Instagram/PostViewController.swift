//
//  PostViewController.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/11.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func handlePostButton(_ sender: Any) {
        let imageData = image.jpegData(compressionQuality: 0.75)
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name" : name!,
                "caption" : self.textField.text!,
                "date" : FieldValue.serverTimestamp(),
                ] as [String : Any]
            postRef.setData(postDic)
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
