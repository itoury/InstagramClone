//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 伊藤龍哉 on 2020/03/14.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCommentData(_ postData: PostData) {
        
     
    }

}
