//
//  fireBase.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    var ref : DatabaseReference! = Database.database().reference()
    
    func uploadProfile(userId: String, dict : [String:Any]){
        ref.child("profiles").child(userId).setValue(dict)
    }
    func uploadPost(postId: String, dict : [String:Any]){
        ref.child("posts").child(postId).setValue(dict)
    }
    
    func getUserData(for uid: String, completionBlock:@escaping (_ success: Bool, _ snapshot: [String:Any])->Void){
        // let uid = Auth.auth().currentUser?.uid
        var postDict : [String : Any] = [:]
        ref.child("profiles/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            postDict = snapshot.value as? [String : Any] ?? [:]
            completionBlock(true,postDict)
        }) { (error) in
            print(error.localizedDescription)
            completionBlock(false, postDict)
        }
    }
    
//    func getUserName(for uid: String, completionBlock:@escaping (_ success: Bool, _ snapshot: [String:Any])->Void){
//        // let uid = Auth.auth().currentUser?.uid
//        var postDict : [String : Any] = [:]
//        ref.child("profiles/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
//            postDict = snapshot.value as? [String : Any] ?? [:]
//            completionBlock(true,postDict)
//        }) { (error) in
//            print(error.localizedDescription)
//            completionBlock(false, postDict)
//        }
//    }
    
    func getPosts(completionBlock:@escaping (_ success: Bool, _ snapshot: [String:Any])->Void){
        var postDict : [String : Any] = [:]
        ref.child("posts").queryOrdered(byChild: "timeStamp").observe(.value, with: { (snapshot) in
            postDict = snapshot.value as? [String : Any] ?? [:]
            completionBlock(true,postDict)
        }) { (error) in
            print(error.localizedDescription)
            completionBlock(false, postDict)
        }
    }
    
    
    func searchPosts(for text:String, completionBlock:@escaping (_ success: Bool, _ snapshot: [String:Any])->Void){
        var mytext = text
        var finish = String(text.last!)
        finish = nextLetter(finish)!
        mytext.removeLast()
        mytext = mytext + finish
        
        var postDict : [String : Any] = [:]
        ref.child("posts").queryOrdered(byChild: "postContent").queryStarting(atValue: text).queryEnding(atValue: mytext).observeSingleEvent(of:.value, with: { (snapshot) in
            postDict = snapshot.value as? [String : Any] ?? [:]
            completionBlock(true,postDict)
        }) { (error) in
            print(error.localizedDescription)
            completionBlock(false, postDict)
        }
    }
}
