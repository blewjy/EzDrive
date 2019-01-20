//
//  InboxViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 3/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InboxViewController: UICollectionViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(InboxCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delaysContentTouches = false
        
        fetchChatrooms()
        
    }
    
    var displayUsers = [User]()
    var chatrooms = [[String]]()
    
    var posts = [Post]()
    
    func fetchPost(postId: String, uid1: String, uid2: String, completion: @escaping () -> ()) {
        let postRef1 = Database.database().reference().child("posts").child(uid1).child(postId)
        let postRef2 = Database.database().reference().child("posts").child(uid2).child(postId)
        var post: Post?
        
        let group = DispatchGroup()
        
        group.enter()
        postRef1.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { group.leave(); return }
            post = Post(postId: postId, uid: uid1, dictionary: value)
            group.leave()
        }) { (error) in
            print("Unable to fetch post with uid1: ", error)
        }
        
        group.enter()
        postRef2.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { group.leave(); return }
            post = Post(postId: postId, uid: uid2, dictionary: value)
            group.leave()
        }) { (error) in
            print("Unable to fetch post with uid2: ", error)
        }
        
        group.notify(queue: .main) {
            guard let post = post else { return }
            self.posts.append(post)
            completion()
        }
    }
    
    func fetchChatrooms() {
        
        guard let currUserUid = Auth.auth().currentUser?.uid else { return }
        
        let chatroomRef = Database.database().reference().child("chatrooms")
        
        chatroomRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let chatroom = snapshot.value as? [String: Any] else { return }
            
            let group = DispatchGroup()
            
            chatroom.forEach({ (key, value) in
                
                let idArray = key.components(separatedBy: "_")

                
                
                
                if idArray[1] == currUserUid {

                    group.enter()
                    Database.fetchUserWithUID(uid: idArray[2], completion: { (user) in
                        self.displayUsers.append(user)
                        self.fetchPost(postId: idArray[0], uid1: idArray[1], uid2: idArray[2], completion: {
                            group.leave()
                        })

                    })
                } else if idArray[2] == currUserUid {
                
                    group.enter()
                    Database.fetchUserWithUID(uid: idArray[1], completion: { (user) in
                        self.displayUsers.append(user)
                        self.fetchPost(postId: idArray[0], uid1: idArray[1], uid2: idArray[2], completion: {
                            group.leave()
                        })
                    })
                } else {
                    return
                }
                

                self.chatrooms.append(idArray)


            })
            
            group.notify(queue: .main, execute: {
                self.collectionView?.reloadData()
            })
            
        }) { (error) in
            print("Failed to fetch chatrooms: ", error)
        }
        
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InboxCell

        let username = displayUsers[indexPath.item].name
        let postTitle = self.posts[indexPath.item].title
        
        let attributedString = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\n\(postTitle)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        cell.cellLabel.attributedText = attributedString
        cell.userProfileImageView.loadImage(urlString: displayUsers[indexPath.item].profileImageUrl)
        cell.postPhoto.loadImage(urlString: self.posts[indexPath.item].imageUrl)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayUsers.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let currUserUid = Auth.auth().currentUser?.uid else { return }

        let uid1 = self.chatrooms[indexPath.item][1]
        let uid2 = self.chatrooms[indexPath.item][2]
        
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let group = DispatchGroup()
    
        group.enter()
        Database.fetchUserWithUID(uid: uid1) { (user) in
            chatViewController.user1 = user
            if currUserUid == uid2 {
                chatViewController.title = user.name
            }
            group.leave()
        }
        
        
        group.enter()
        Database.fetchUserWithUID(uid: uid2) { (user) in
            chatViewController.user2 = user
            if currUserUid == uid1 {
                chatViewController.title = user.name
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            chatViewController.post = self.posts[indexPath.item]
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }

    }
    
}


extension InboxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 86)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}








