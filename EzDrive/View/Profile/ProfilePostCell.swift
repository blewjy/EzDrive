//
//  ProfilePostCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 2/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfilePostCell: UICollectionViewCell {
    
    let cellId = "cellId"
    
    var posts = [Post]()
    
    var profileViewController: ProfileViewController?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ShareViewController.updateFeedNotificationName, object: nil)
        
        postCollectionView.register(BrowseCell.self, forCellWithReuseIdentifier: cellId)
        postCollectionView.refreshControl = refresher

        
        setupViews()
        
     //   fetchPosts()
    }
    
    @objc func handleUpdateFeed() {
        print("Updating feed")
        
        posts.removeAll()
        fetchPosts()
    }
    
    var user: User? {
        didSet {
            fetchPosts()
        }
    }
    
    fileprivate func fetchPosts() {
        
        print("Fetching posts for user")
        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let uid = self.user?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach({ (key, value) in
                
                guard let value = value as? [String: Any] else { return }
                
                let post = Post(postId: key, uid: uid, dictionary: value)
                
                self.posts.append(post)
                
                self.posts = self.posts.sorted(by: { (post1, post2) -> Bool in
                    return post1.timestamp > post2.timestamp
                })
                
                DispatchQueue.main.async {
                    self.postCollectionView.reloadData()
                }
                
            })
            
        }) { (error) in
            print("Failed to fetch post for current user: ", error)
        }
    }
    
    
    lazy var postCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    func setupViews() {
        
        addSubview(postCollectionView)
        
        postCollectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    // A lazy var will only evaluate/execute when absoutely required
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.black
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresher
    }()
    
    @objc func refreshData() {
        print("refresh")
        
        // Add a (1 sec) delay before the refresher ends
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
}

extension ProfilePostCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = postVC(collectionViewLayout: UICollectionViewFlowLayout())
        let post = self.posts[indexPath.item]
        
        vc.post = post
        
        Database.fetchUserWithUID(uid: post.uid) { (user) in
            vc.user = user
            self.profileViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension ProfilePostCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BrowseCell
        cell.post = self.posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
}


extension ProfilePostCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2 - 18
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension ProfilePostCell: BrowseCellDelegate {
    func didTapMoreButton() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            print("Reported")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.profileViewController?.present(alertController, animated: true, completion: nil)
        
    }
}











