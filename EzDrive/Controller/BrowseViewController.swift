//
//  BrowseViewControllerNew.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth



class BrowseViewController: UIViewController {
    
    let browseCellId = "browseCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ShareViewController.updateFeedNotificationName, object: nil)
        
        
        setupViews()
        browseCollectionView.delegate = self
        browseCollectionView.dataSource = self
        browseCollectionView.register(BrowseCell.self, forCellWithReuseIdentifier: browseCellId)
        browseCollectionView.refreshControl = refresher
        
        fetchPosts()
    }

    @objc func handleUpdateFeed() {
        print("Updating feed")
        
        posts.removeAll()
        sortedPosts.removeAll()
        fetchPosts()
    }
    
    var activeLocationFilter = 0 {
        didSet {
            
            
            browseHeaderView.locationLabel.text = LocationViewController.locations[activeLocationFilter]
            
            self.filter(locationFilter: activeLocationFilter, carFilter: activeCarFilter)

        }
    }
    
    var activeCarFilter = 8 {
        didSet {
            
            let carFilter = SelectCarModelViewController.carLabels[activeCarFilter]

            self.sortFilterLabels[1] = carFilter
            
            self.filter(locationFilter: activeLocationFilter, carFilter: activeCarFilter)
        }
    }
    
    func filter(locationFilter: Int, carFilter: Int) {
        self.filteredPosts = self.posts.filter({ (post) -> Bool in
            if locationFilter == 0 && carFilter == 8 {
                return true
            }
            if locationFilter == 0 {
                return post.carModel == SelectCarModelViewController.carLabels[carFilter]
            }
            if carFilter == 8 {
                return post.location == LocationViewController.locations[self.activeLocationFilter]
            }
            return post.carModel == SelectCarModelViewController.carLabels[carFilter] && post.location == LocationViewController.locations[self.activeLocationFilter]
        })
        browseCollectionView.reloadData()

    }
    
    var activeSort = 3 {
        didSet {
            
            browseCollectionView.reloadData()
            
            var sortLabel = ""
            
            switch activeSort {
                case 0:
                    sortLabel = "Recent"
                case 1:
                    sortLabel = "Price: Low to High"
                case 2:
                    sortLabel = "Price: High to Low"
                default:
                    sortLabel = "None"
            }
            
            self.sortFilterLabels[0] = sortLabel
        }
    }
    
    var sortFilterLabels = ["None", ""] {
        didSet {
            var label = ""
            if sortFilterLabels[0] == "None" && sortFilterLabels[1] == "" {
                label = "None"
            }
            if sortFilterLabels[0] == "None" && sortFilterLabels[1] != "" {
                label = sortFilterLabels[1]
            }
            if sortFilterLabels[0] != "None" && sortFilterLabels[1] == "" {
                label = sortFilterLabels[0]
            }
            
            if sortFilterLabels[0] != "None" && sortFilterLabels[1] != "" {
                let sortLabelText = sortFilterLabels[0]
                let carLabelText = ", \(sortFilterLabels[1])"
                
                label = "\(sortLabelText)\(carLabelText)"
            }
            

            browseHeaderView.sortFilterLabel.text = label
        }
    }
    
    var posts = [Post]()
    
    var sortedPosts = [Post]()
    
    var filteredPosts = [Post]()
    
    fileprivate func fetchPosts() {
        
        print("Fetching posts")
        
     //   guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            dictionary.forEach({ (key, value) in
                guard let value = value as? [String: Any] else { return }
                
                value.forEach({ (postId, postDict) in
                    guard let postDict = postDict as? [String: Any] else { return }
                    
                    let post = Post(postId: postId, uid: key, dictionary: postDict)
                    
                    self.posts.append(post)
                    
                    self.sortedPosts = self.posts.sorted(by: { (post1, post2) -> Bool in
                        return post1.timestamp > post2.timestamp
                    })
                    
                    self.filteredPosts = self.posts
                    
                    DispatchQueue.main.async {
                        self.browseCollectionView.reloadData()

                    }
                    
                })
          
            })
            
        }) { (error) in
            print("Failed to observe users node: ", error)
        }
        
    }
    

    
    let browseHeaderView = BrowseHeaderView(frame: .zero)
    let browseCollectionView = BrowseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    func setupViews() {
        view.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        
        view.addSubview(browseHeaderView)
        
        browseHeaderView.delegate = self
        
        browseHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        browseHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        browseHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        browseHeaderView.heightAnchor.constraint(equalToConstant: browseHeaderView.headerViewHeight).isActive = true

        
        view.addSubview(browseCollectionView)
        
        browseCollectionView.topAnchor.constraint(equalTo: browseHeaderView.bottomAnchor).isActive = true
        browseCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        browseCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        browseCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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

extension BrowseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = postVC(collectionViewLayout: UICollectionViewFlowLayout())
        let post = self.sortedPosts[indexPath.item]
        
        vc.post = post
        
        Database.fetchUserWithUID(uid: post.uid) { (user) in
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: browseCellId, for: indexPath) as! BrowseCell
        cell.backgroundColor = .white
        
        cell.delegate = self
        
        self.sortedPosts = self.filteredPosts.sorted(by: { (post1, post2) -> Bool in
            
            switch self.activeSort {
            case 1:
                return post1.price < post2.price
            case 2:
                return post1.price > post2.price
            case 3, 0:
                return post1.timestamp > post2.timestamp
            default:
                return post1.timestamp < post2.timestamp
            }
        })
        
        
        
        cell.post = self.sortedPosts[indexPath.item]
        return cell
    }
}

extension BrowseViewController: UICollectionViewDelegateFlowLayout {
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

extension BrowseViewController: BrowseHeaderViewDelegate {
    func didTapSortFilterButton() {
        print("tapped in browse")
        
        let sortFilterViewController = SortFilterViewController(collectionViewLayout: UICollectionViewFlowLayout())
        sortFilterViewController.title = "Sort/Filter"
        sortFilterViewController.browseViewController = self
        sortFilterViewController.selectedSort = self.activeSort
        sortFilterViewController.selectedCarModel = self.activeCarFilter
        let sortFilterNavController = UINavigationController(rootViewController: sortFilterViewController)
        present(sortFilterNavController, animated: true, completion: nil)
        
    }
    
    func didTapLocationButton() {
        print("tapped location in browse")
        
        let locationViewController = LocationViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        locationViewController.title = "Filter by Location"
        locationViewController.browseViewController = self
        locationViewController.selectedLocation = self.activeLocationFilter
        
        let locationNavController = UINavigationController(rootViewController: locationViewController)
        present(locationNavController, animated: true, completion: nil)
        
        
    }
}

extension BrowseViewController: BrowseCellDelegate {
    
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










