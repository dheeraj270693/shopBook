//
//  ChatTableViewCell.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.numberOfLines = 0
        userImageView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setValues(post: Post){
        contentLabel.text = post.postContent
        postImageView.setImageFromUrl(myUrl: post.postImageUrl)
        userImageView.setImageFromUrl(myUrl: post.userImageUrl)
        
        userNameLabel.text = post.userName
        //postImageView.image = UIImage(data: pic, scale: 1.0)
        //        let myManager2 = FirebaseManager()
        //        myManager2.getUserData(for: post.userID, completionBlock: { (success, resultDic) in
        //            let values = resultDic.count
        //            let author = values > 0 ? resultDic["name"] as! String : "New User"
        //            DispatchQueue.main.async {
        //                self.userNameLabel.text = author
        //            }
        //        })
    }
}
