//
//  SinglePostViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 2/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class postVC: UICollectionViewController {
    
    var post: Post?
    var user: User? {
        didSet {
            guard let postUserUid = user?.uid else { return }
            guard let currUserUid = Auth.auth().currentUser?.uid else { return }
            
            if postUserUid == currUserUid {
                self.chatButton.isEnabled = false
                self.chatButton.backgroundColor = .lightGray
                self.chatButton.setTitleColor(.gray, for: .normal)
            } else {
                self.chatButton.isEnabled = true
                self.chatButton.backgroundColor = UIColor.rgb(r: 255, g: 111, b: 0)
                self.chatButton.setTitleColor(.white, for: .normal)
            }
            
        }
    }
    
    let headerId = "headerId"
    let postCellId = "postCellId"
    let userCellId = "userCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    //    guard let post = self.post else { return }
        
//        Database.fetchUserWithUID(uid: post.uid) { (user) in
//            self.user = user
//        }
//
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.register(SinglePostSellerHeader.self, forCellWithReuseIdentifier: headerId)
        collectionView?.register(SinglePostPostCell.self, forCellWithReuseIdentifier: postCellId)
        collectionView?.register(SinglePostUserCell.self, forCellWithReuseIdentifier: userCellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.delaysContentTouches = false
        
        setupViews()
    }

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ezdrive_back").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.alpha = 0.4
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chat", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.layer.cornerRadius = 25.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChat() {
        print("Chat")
        
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())

        let group = DispatchGroup()
        
        group.enter()
        if let post = self.post {
            chatViewController.post = post
            group.leave()
        }
        
        group.enter()
        if let currUserUid = Auth.auth().currentUser?.uid {
            Database.fetchUserWithUID(uid: currUserUid) { (user) in
                chatViewController.user1 = user
                group.leave()
            }
        }
        
        group.enter()
        if let postUser = self.user {
            chatViewController.title = postUser.name
            chatViewController.user2 = postUser
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
    func setupViews() {
        view.addSubview(backButton)
        view.addSubview(chatButton)
        
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        chatButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 50)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            print("selected")
            
            let profileCollectionViewLayout = UICollectionViewFlowLayout()
            profileCollectionViewLayout.scrollDirection = .horizontal
            
            let profileViewController = ProfileViewController(collectionViewLayout: profileCollectionViewLayout)
            profileViewController.currentUser = self.user
            self.navigationController?.pushViewController(profileViewController, animated: true)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as! SinglePostPostCell
            if let post = self.post {
                cell.post = post
            }
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerId, for: indexPath) as! SinglePostSellerHeader
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellId, for: indexPath) as! SinglePostUserCell
            cell.user = user
            return cell
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}


extension postVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
            case 0:
                
                let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
                let dummyCell = SinglePostPostCell(frame: frame)
                dummyCell.post = self.post
                dummyCell.layoutIfNeeded()
                
                let targetSize = CGSize(width: view.frame.width, height: 10000)
                let size = dummyCell.postTextView.sizeThatFits(targetSize)
                let height = size.height + view.frame.width + 30
                return CGSize(width: view.frame.width, height: height)
                    
            case 1:
                return CGSize(width: view.frame.width, height: 44)
            case 2:
                return CGSize(width: view.frame.width, height: 116)
            default:
                return CGSize(width: view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height * -1
        return UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 82, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

















