//
//  Structs.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import Foundation
let defaultImage = "purpleLeaves"

struct Profile: Encodable, Decodable{
    var uid: String
    var name: String
    var email: String
    var birthday : String
    var pic: String
    //var key: String
    //var image: UIImage
//    func getKey() -> String{
//        return key
//    }
    func getDict()-> [String:Any]{
        let myDict: [String:Any] = ["uid":self.uid, "name":self.name, "email":self.email, "birthday" : self.birthday, "url" : self.pic]
        return myDict
    }
}

struct Post{
    var postContent: String
    var userID: String
    var userName: String
    var userImageUrl: String
    var postImageUrl: String
    var timeStamp: String
    var isLiked: Bool
    var isDeleted: Bool
//    var postPhotoData: Data?
    
    //var picData : Data?
//    func getKey() -> String{
//        return self.key
//    }
    func getDict()-> [String:Any]{
        let myDict: [String:Any] = ["postContent":self.postContent, "userID":self.userID, "userName" : self.userName, "timeStamp": self.timeStamp, "userImageUrl": self.userImageUrl, "postImageUrl":self.postImageUrl, "isLiked": self.isLiked, "isDeleted": self.isDeleted]
        return myDict
    }
}
