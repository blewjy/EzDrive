//
//  SearchViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 14/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UICollectionViewController {
    
    var cellId = "cellId"
    
    var posts = [Post]()
    
    var filteredPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ShareViewController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.register(BrowseCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.refreshControl = refresher
        collectionView?.delaysContentTouches = false
        
        setupSearchBar()
        fetchPosts()
    }
    
    @objc func handleUpdateFeed() {
        print("Updating feed")
        
        posts.removeAll()
        filteredPosts.removeAll()
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        
        print("Fetching posts")
        
        let ref = Database.database().reference().child("posts")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach({ (key, value) in
                guard let value = value as? [String: Any] else { return }
                
                value.forEach({ (postId, postDict) in
                    guard let postDict = postDict as? [String: Any] else { return }
                    
                    let post = Post(postId: postId, uid: key, dictionary: postDict)
                    
                    self.posts.append(post)
                    
                    self.filteredPosts = self.posts
                    
                    
                    self.filteredPosts = self.posts.sorted(by: { (post1, post2) -> Bool in
                        return post1.timestamp > post2.timestamp
                    })
                    
                    
                    self.collectionView?.reloadData()
                    
                })
                
            })
            
        }) { (error) in
            print("Failed to observe users node: ", error)
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.isHidden = false
        self.searchButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.isHidden = true
        self.searchButton.isHidden = true
    }
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        
        let textFieldInsideUISearchBar = bar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(14)
        textFieldInsideUISearchBar?.textColor = .white
        textFieldInsideUISearchBar?.backgroundColor = UIColor.rgb(r: 215, g: 95, b: 0)
        
        bar.delegate = self
        
        return bar
    }()
    
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ezdrive_search").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSearch() {
        searchBar.endEditing(true)
    }
    
    func setupSearchBar() {
        
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationBar.addSubview(searchButton)
        
        let navBar = navigationController?.navigationBar
        
        searchButton.anchor(top: navBar?.topAnchor, left: nil, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1.0).isActive = true
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: searchButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

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
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BrowseCell
        cell.post = filteredPosts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = postVC(collectionViewLayout: UICollectionViewFlowLayout())
        let post = self.filteredPosts[indexPath.item]
        
        vc.post = post
        
        Database.fetchUserWithUID(uid: post.uid) { (user) in
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            self.filteredPosts = self.posts
        } else {
            self.filteredPosts = self.posts.filter { (post) -> Bool in
                return post.title.lowercased().contains(searchText.lowercased()) || post.description.lowercased().contains(searchText.lowercased())
            }
            
            self.filteredPosts = self.filteredPosts.sorted(by: { (post1, post2) -> Bool in
                return post1.timestamp > post2.timestamp
            })
        }

        self.collectionView?.reloadData()
        
        
    }
}



extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController: BrowseCellDelegate {
    
    // This reporting does not take into account who's post it is, so if it is the current user's post, it also just plainly says report. Should try to change it to something like "REPORT YOURSELF" if got time lol
    func didTapMoreButton() {
        print("Tapped more in browseVC")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            print("Reported")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
}







