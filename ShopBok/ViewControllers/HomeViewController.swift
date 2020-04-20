//
//  HomeViewController.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var posts: [Post] = []{didSet{
        postsTableView.reloadData()
        }
    }
    var currentProfile: Profile?
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userButton: UIButton!
    
    // temporarily disconnecting and removing from storyboard
    @IBOutlet weak var userImageView: UIImageView!
    @IBAction func menuBtnClicked(_ sender: Any) {
        
    }
    
    //    MARK: IBActions
    //disconnecting signout button from the navigation bar
    @IBAction func signOutBtnClicked(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(nil, forKey: "currentProfile")
        let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        
        if self.searchTextField.hasText{
            self.searchPosts(for: self.searchTextField.text!)
        }else{
            // if search result is not found
            loadData()
        }
    }
    
    //    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUI()
        
        //Getting the currentProfile from UserDefaults...
        if let savedPerson = UserDefaults.standard.object(forKey: "currentProfile") as? Data
        {
            let decoder = JSONDecoder()
            currentProfile = try? decoder.decode(Profile.self, from: savedPerson)
            if currentProfile != nil{
                print(currentProfile!.name)
                setUserDetailsInView()
            }else{
                //if the currentProfile is not set in UserDefaults
                let thedate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM YYYY"
                let mydate = dateFormatter.string(from: thedate)
                currentProfile = Profile(uid: "1",name: "New User", email: "", birthday: mydate, pic: "")
            }
        }else {
            print("Something went terribly wrong: There is no currentProfile....")
        }
        //End of Getting the currentProfile from UserDefaults...
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
    }
    
    // this is to hide the navigation bar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //    MARK: Set UI
    func setUI(){
        userButton.layer.cornerRadius = 15
        userImageView.layer.cornerRadius = 15
        searchView.layer.cornerRadius = 10
    }
    
    func setUserDetailsInView(){
        //        let iconImage:UIImage? = UIImage(named: currentProfile!.pic)
        //        userButton.setImage(iconImage, for: UIControl.State.normal)
        userImageView.setImageFromUrl(myUrl: currentProfile!.pic)
        userButton.setTitle(currentProfile!.name, for: .normal)
    }
    
    
    func loadData(){
        let myManager = FirebaseManager()
        myManager.getPosts { (success, postDict) in
            if success{
                self.posts = []
                for i in postDict.keys{
                    if let values = postDict[i] as? Dictionary<String, Any>{
                        let myContent = values["postContent"] as! String
                        let myAuthor = values["userID"] as! String
                        let myPostImage = values["postImageUrl"] as! String
                        let myDate = values["timeStamp"] as! String
                        let myUsername = values["userName"] as! String
                        let myUserImage = values["userImageUrl"] as! String
                        let myLike = values["isLiked"] as! Bool
                        let myDelete = values["isDeleted"] as! Bool
                        
                        var cell :Post
                        cell = Post(postContent: myContent, userID: myAuthor, userName: myUsername, userImageUrl: myUserImage, postImageUrl: myPostImage, timeStamp: myDate, isLiked: myLike, isDeleted: myDelete)
                        //cell = Post(content: myContent, author: myAuthor, pic: myUrl, date: myDate, key: i)
                        self.posts.append(cell)
                        //})
                    }
                }
                // sorting the result by time.
                self.posts.sort(by: {$1.timeStamp < $0.timeStamp})
                DispatchQueue.main.async {
                    // self.getImagesFromDB()
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func searchPosts(for searchText: String){
        if searchText != ""{
            var tempPosts: [Post] = []
            for post in posts{
                if post.postContent.contains(searchText){
                    tempPosts.append(post)
                }else if post.userName.contains(searchText){
                    tempPosts.append(post)
                }
            }
            posts = tempPosts
            postsTableView.reloadData()
        }
    }
    
    //    MARK: Tableview delegate and data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "cell") as! ChatTableViewCell
        let myPost = posts[indexPath.row]
        
        print("Post count\(posts.count)")
        print(myPost)
        
        cell.setValues(post: myPost)
        return cell
    }
    
    // Left Side menu
    struct MenuContent: View {
        var body: some View {
            List {
                Text("My Profile").onTapGesture {
                    print("My Profile")
                }
                Text("Posts").onTapGesture {
                    print("Posts")
                }
                Text("Logout").onTapGesture {
                    print("Logout")
                }
            }
        }
    }
    
    struct SideMenu: View {
        let width: CGFloat
        let isOpen: Bool
        let menuClose: () -> Void
        
        var body: some View {
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.3))
                .opacity(self.isOpen ? 1.0 : 0.0)
                .animation(Animation.easeIn.delay(0.25))
                .onTapGesture {
                    self.menuClose()
                }
                
                HStack {
                    MenuContent()
                        .frame(width: self.width)
                        .background(Color.white)
                        .offset(x: self.isOpen ? 0 : -self.width)
                        .animation(.default)
                    
                    Spacer()
                }
            }
        }
    }
    
    struct ContentView: View {
        @State var menuOpen: Bool = false
        
        var body: some View {
            ZStack {
                if !self.menuOpen {
                    Button(action: {
                        self.openMenu()
                    }, label: {
                        Text("Open")
                    })
                }
                
                SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
            }
        }
        
        func openMenu() {
            self.menuOpen.toggle()
        }
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
