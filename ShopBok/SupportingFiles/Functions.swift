//
//  Functions.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


func showAlert(viewController: UIViewController, _ message: String){
    let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    myAlert.addAction(myAction)
    viewController.present(myAlert, animated: true, completion: nil)
    
}


//KeyBoard moving functionality part 3/3....

func keyboardShow(vc: UIViewController, notification: NSNotification) {
    guard let userInfo = notification.userInfo else {return}
    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = keyboardSize.cgRectValue
    if vc.view.frame.origin.y == 0{
        vc.view.frame.origin.y -= keyboardFrame.height
    }
}
 func keyboardHide(vc: UIViewController,notification: NSNotification) {
    guard let userInfo = notification.userInfo else {return}
    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let keyboardFrame = keyboardSize.cgRectValue
    if vc.view.frame.origin.y != 0{
        vc.view.frame.origin.y += keyboardFrame.height
    }
}
    //end of KeyBoard moving functionality part 3....
func nextLetter(_ letter: String) -> String? {
    
    // Check if string is build from exactly one Unicode scalar:
    guard let uniCode = UnicodeScalar(letter) else {
        return nil
    }
    return String(UnicodeScalar(uniCode.value + 1)!)
}


extension UIImageView {
//    func setImageFromUrl(myUrl:String){
//        let myStorage = StorageManager()
//        myStorage.downloadImage(imageName: myUrl) { (success, data) in
//            DispatchQueue.main.async {
//                self.image = success ? UIImage(data: data!, scale: 0.5) : UIImage(named: defaultImage)
//            }
//        }
//    }
//    func setImageFromUrl(myUrl:String){
//        let myURL = URL(fileURLWithPath: myUrl)
//        if let myData = try? Data(contentsOf: myURL){
//        self.image = UIImage(data: myData)
//        }else{
//            self.image = UIImage(named: defaultImage)
//        }
//    }
    //?alt=media&token=7ea566f7-01f8-4e35-b0f9-4a3eac83d7a7
  //  /*Uncommented section
     
    func setImageFromUrl(myUrl: String) {
        print("Download Started\(myUrl)")
        let url = URL(string: myUrl)
        self.kf.setImage(with: url)
    }
 //end of uncommented section*/
    
    
    
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                self.kf.setImage(with: url, placeholder: nil, options:
//                    nil, progressBlock: nil, completionHandler: { (imgSrc, err, nil,
//                        url) in
//                        DispatchQueue.main.async {
//                            self.kf.setImage(with: url)
//                        }
//                })
//            }
//        }
    }

