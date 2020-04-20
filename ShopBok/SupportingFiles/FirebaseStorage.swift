//
//  FirebaseStorage.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import Foundation
import Firebase

class StorageManager {
    let ref = Storage.storage().reference()
    
    func uploadProfileImage(userID: String, data:Data, completionBlock: @escaping (_ success:Bool,_ url:String?)->Void){
        let imageName = userID.hasSuffix(".jpg") ? userID : userID + ".jpg"
        let myRef = ref.child("images").child("profilePics/\(imageName)")
        //let uplaodTask =
        myRef.putData(data, metadata: nil) { (metaData, error) in
            if error == nil{
                guard let metaData = metaData else{
                    return
                }
                let size = metaData.size
//                let url = metaData.path
//                completionBlock(true, url)
                
                // to get the uploaded URL from firebase
                myRef.downloadURL(completion: { (url, err) in
                    if (url != nil){
                        print("User Downloded Url \(url?.absoluteString)")
                        let urlString = url?.absoluteString
                        completionBlock(true, urlString)
                     }
                    else{
                        completionBlock(false, nil)
                    }
                })
                // to get the uploaded URL from firebase
                
            }else {
                completionBlock(false, nil)
            }
        }
    }
    func uploadPostImage(postID: String,data:Data, completionBlock: @escaping (_ success:Bool,_ url:String?)->Void){
        let imageName = postID.hasSuffix(".jpg") ? postID : postID + ".jpg"
        let myRef = ref.child("images").child("posts/\(imageName)")
        //let uplaodTask =
        myRef.putData(data, metadata: nil) { (metaData, error) in
            if error == nil{
                guard let metaData = metaData else{
                    return
                }
                let size = metaData.size
//                let url = metaData.path
//                completionBlock(true, url)
                
                // to get the uploaded URL from firebase
                myRef.downloadURL(completion: { (url, err) in
                    if (url != nil){
                        print("Downloded Url \(url?.absoluteString)")
                        let urlString = url?.absoluteString
                        completionBlock(true, urlString)
//                        print("The size is: \(size) and the type is: \(url.debugDescription)")
                    }
                    else{
                        completionBlock(false, nil)
                    }
                })
                // to get the uploaded URL from firebase
            }else {
                completionBlock(false, nil)
            }
        }
    }
    
    func downloadImage(imageName: String, completionBlock: @escaping (Bool,Data?)->Void){
        let myRef = ref.child(imageName)
        myRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if error == nil{
                completionBlock(true, data!)
            } else {
                print(error!.localizedDescription + "      WHAAAAAATTTT    " + error.debugDescription)
                completionBlock(false, nil)
            }
        }
    }
}
