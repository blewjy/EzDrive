//
//  ProfileViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 23/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

// TABS: Posts, Feedback, About


import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UICollectionViewController {
    
    let profilePostCellId = "profilePostCellId"
    let profileReviewCellId = "profileReviewCellId"
    let profileAboutCellId = "profileAboutCellId"
    let cellId = "cellId"
    
    var currentUserUid: String?
    
    var currentUser: User? {
        didSet {
            print("user info set")
            if let currentUser = currentUser {
                
                collectionView?.reloadItems(at: [IndexPath(item: 0, section: 0)])
                
                self.profileImageView.loadImage(urlString: currentUser.profileImageUrl)
                
                let attributedText = NSMutableAttributedString(string: currentUser.name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: "\n"))
                attributedText.append(NSAttributedString(string: currentUser.handle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.9, alpha: 1)]))
                attributedText.append(NSAttributedString(string: "\n"))
                attributedText.append(NSAttributedString(string: currentUser.location, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.9, alpha: 1)]))
                self.particularsLabel.attributedText = attributedText
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if currentUser.uid == uid {
                    setupNavBarItems()
                }
                
            }
            
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        
        
        collectionView?.register(ProfilePostCell.self, forCellWithReuseIdentifier: profilePostCellId)
        collectionView?.register(ProfileReviewCell.self, forCellWithReuseIdentifier: profileReviewCellId)
        collectionView?.register(ProfileAboutCell.self, forCellWithReuseIdentifier: profileAboutCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.delaysContentTouches = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        setupViews()
        
        guard let uid = currentUserUid else { return }

        Database.fetchUserWithUID(uid: uid) { (user) in
            print("here?")
            self.currentUser = user
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove NavBar bottom line shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    
    let headerViewHeight: CGFloat = 210.0
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 255, g: 111, b: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let particularsLabel: UILabel = {
        let label = UILabel()
  //      label.backgroundColor = .green
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postsButtonView: UIView = {
        let view = UIView()
//        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let reviewsButtonView: UIView = {
        let view = UIView()
//        view.backgroundColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let aboutButtonView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postsButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Posts"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewsButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Reviews"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "About"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        collectionView?.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(profileImageView)
        view.addSubview(particularsLabel)
        view.addSubview(postsButtonView)
        view.addSubview(reviewsButtonView)
        view.addSubview(aboutButtonView)
        view.addSubview(postsButtonLabel)
        view.addSubview(reviewsButtonLabel)
        view.addSubview(aboutButtonLabel)
        view.addSubview(scrollIndicatorView)
        
        let postsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapPosts))
        postsButtonView.addGestureRecognizer(postsTapGesture)
        postsButtonView.isUserInteractionEnabled = true
        
        let reviewsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapReviews))
        reviewsButtonView.addGestureRecognizer(reviewsTapGesture)
        reviewsButtonView.isUserInteractionEnabled = true
        
        let aboutTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAbout))
        aboutButtonView.addGestureRecognizer(aboutTapGesture)
        aboutButtonView.isUserInteractionEnabled = true
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: headerViewHeight).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        particularsLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        particularsLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        particularsLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        particularsLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        
        postsButtonView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        postsButtonView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        postsButtonView.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        postsButtonView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        
        reviewsButtonView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        reviewsButtonView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        reviewsButtonView.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        reviewsButtonView.leftAnchor.constraint(equalTo: postsButtonView.rightAnchor).isActive = true
        
        aboutButtonView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        aboutButtonView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        aboutButtonView.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        aboutButtonView.leftAnchor.constraint(equalTo: reviewsButtonView.rightAnchor).isActive = true
        
        postsButtonLabel.topAnchor.constraint(equalTo: postsButtonView.topAnchor).isActive = true
        postsButtonLabel.leftAnchor.constraint(equalTo: postsButtonView.leftAnchor).isActive = true
        postsButtonLabel.rightAnchor.constraint(equalTo: postsButtonView.rightAnchor).isActive = true
        postsButtonLabel.bottomAnchor.constraint(equalTo: postsButtonView.bottomAnchor, constant: -4).isActive = true
        
        reviewsButtonLabel.topAnchor.constraint(equalTo: reviewsButtonView.topAnchor).isActive = true
        reviewsButtonLabel.leftAnchor.constraint(equalTo: reviewsButtonView.leftAnchor).isActive = true
        reviewsButtonLabel.rightAnchor.constraint(equalTo: reviewsButtonView.rightAnchor).isActive = true
        reviewsButtonLabel.bottomAnchor.constraint(equalTo: reviewsButtonView.bottomAnchor, constant: -4).isActive = true
        
        aboutButtonLabel.topAnchor.constraint(equalTo: aboutButtonView.topAnchor).isActive = true
        aboutButtonLabel.leftAnchor.constraint(equalTo: aboutButtonView.leftAnchor).isActive = true
        aboutButtonLabel.rightAnchor.constraint(equalTo: aboutButtonView.rightAnchor).isActive = true
        aboutButtonLabel.bottomAnchor.constraint(equalTo: aboutButtonView.bottomAnchor, constant: -4).isActive = true

        scrollIndicatorView.frame = CGRect(x: 0, y: headerViewHeight-4, width: self.view.frame.width/3, height: 4)
    }
    
    @objc func handleTapPosts() {
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: [], animated: true)
    }
    
    @objc func handleTapReviews() {
        collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: [], animated: true)
    }
    
    @objc func handleTapAbout() {
        collectionView?.scrollToItem(at: IndexPath(item: 2, section: 0), at: [], animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollIndicatorView.frame = CGRect(x: scrollView.contentOffset.x/3, y: self.headerViewHeight-4, width: self.view.frame.width/3, height: 4)
        
        let scrollIndicatorWidth = view.frame.width/6
        let scrollIndicatorCenterX = scrollView.contentOffset.x/3 + scrollIndicatorWidth
        if scrollIndicatorCenterX < view.frame.width/3 {
            postsButtonLabel.textColor = .white
            reviewsButtonLabel.textColor = .lightGray
            aboutButtonLabel.textColor = .lightGray
        } else if scrollIndicatorCenterX >= view.frame.width/3 && scrollIndicatorCenterX <= view.frame.width/3*2 {
            reviewsButtonLabel.textColor = .white
            postsButtonLabel.textColor = .lightGray
            aboutButtonLabel.textColor = .lightGray
        } else if scrollIndicatorCenterX > view.frame.width/3*2 {
            aboutButtonLabel.textColor = .white
            postsButtonLabel.textColor = .lightGray
            reviewsButtonLabel.textColor = .lightGray
        }
        
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x = 0
        }

        if scrollView.contentOffset.x >= view.frame.width*2 {
            scrollView.contentOffset.x = view.frame.width*2
        }

    }
    

    
    lazy var optionsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ezdrive_gear"), style: .plain, target: self, action: #selector(handleOptions))
        return button
    }()
    
    @objc func handleOptions() {
        print("Options button clicked")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
                print("Sign out successful")
            } catch let signOutError {
                print("Failed to sign out: ", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        
    }
    

    func setupNavBarItems() {
        self.navigationItem.rightBarButtonItem = optionsButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profilePostCellId, for: indexPath) as! ProfilePostCell
                cell.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
                cell.profileViewController = self
                cell.posts.removeAll()
                cell.user = self.currentUser
                return cell
            
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileReviewCellId, for: indexPath) as! ProfileReviewCell
                cell.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
                cell.delegate = self
                
                guard let currentUser = self.currentUser else { return cell }
                
                cell.reviewedUserUid = currentUser.uid
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileAboutCellId, for: indexPath) as! ProfileAboutCell
                cell.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
                guard let currentUser = self.currentUser else { return cell }
                cell.user = currentUser
                return cell
            
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = .black
                print("Something is wrong here, this cell should not be here")
                return cell
            
        }
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        // There is some discrepancy here with iphoneX. +15 works on iphone8 and 8plus, but it's too much for iphoneX. IphoneX's needs to be +5
//        return CGSize(width: view.frame.width, height: view.frame.height - headerViewHeight - topBarHeight + 5)
        return CGSize(width: view.frame.width, height: view.frame.height - headerViewHeight - topBarHeight + 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ProfileViewController: ProfileReviewCellDelegate {
    func didTapReviewButton() {
        print("REview from VC")
        
        let reviewViewController = ReviewViewController()
        guard let user = currentUser else { return }
        reviewViewController.userReviewedUid = user.uid
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
}
