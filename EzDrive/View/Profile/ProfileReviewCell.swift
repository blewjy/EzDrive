//
//  ProfileReviewCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 19/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol ProfileReviewCellDelegate {
    func didTapReviewButton()
}


class ProfileReviewCell: UICollectionViewCell {
    
    let cellId = "cellId"
    
    var delegate: ProfileReviewCellDelegate?
    
    var reviewedUserUid: String? {
        didSet {
            checkReviewButtonValidity()
            fetchReviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.register(ProfileReviewReviewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
    }
    
    var reviews = [Review]()

    var numberOfPositives: Double = 0.0
    
    var numberOfReviews: Double = 0.0
    
    var percentagePositive: Double = 0.0 {
        didSet {
            print(percentagePositive)
            
            let percentage = Int(percentagePositive)
            
            self.percentageLabel.text = "\(percentage)% Positive"
        }
    }
    
    func fetchReviews() {
        
        guard let reviewedUserUid = self.reviewedUserUid else { print("HereHere"); return }
        
        let ref = Database.database().reference().child("reviews").child(reviewedUserUid)
    
        ref.observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            
            
            let message = dictionary["message"] as? String ?? ""
            let rating = dictionary["rating"] as? Int ?? 0
            let uid = dictionary["uid"] as? String ?? ""
            let timestamp = dictionary["timestamp"] as? Double ?? 0
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let review = Review(message: message, rating: rating, user: user, timestamp: timestamp)
                if rating == 0 {
                    self.numberOfPositives += 1.0
                }
                self.numberOfReviews += 1.0
                self.percentagePositive = self.numberOfPositives/self.numberOfReviews * 100.0
                self.reviews.append(review)
                self.reviews.sort(by: { (review1, review2) -> Bool in
                    return review1.timestamp > review2.timestamp
                })
                self.reviewCollectionView.reloadData()
            })
            
            
        }
        
    }
    
    func checkReviewButtonValidity() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        guard let reviewedUserUid = self.reviewedUserUid else { return }
        
        if currentUserUid == reviewedUserUid {
            self.reviewButton.backgroundColor = .lightGray
            self.reviewButton.isEnabled = false
        } else {
            self.reviewButton.backgroundColor = UIColor.rgb(r: 29, g: 161, b: 242)
            self.reviewButton.isEnabled = true
        }
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "0% Positive"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    lazy var reviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(r: 29, g: 161, b: 242)
        button.setTitle("Leave a review!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleReview), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    @objc func handleReview() {
        delegate?.didTapReviewButton()
    }
    
    func setupViews() {
        addSubview(percentageLabel)
        addSubview(reviewButton)
        addSubview(reviewCollectionView)
        
        percentageLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        reviewButton.anchor(top: percentageLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 30)
        reviewCollectionView.anchor(top: reviewButton.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
}

extension ProfileReviewCell: UICollectionViewDelegate {
}

extension ProfileReviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileReviewReviewCell
        cell.review = self.reviews[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviews.count
    }
}

extension ProfileReviewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        let dummyCell = ProfileReviewReviewCell(frame: frame)
        dummyCell.review = self.reviews[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: self.frame.width, height: 100)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = estimatedSize.height
        
        return CGSize(width: self.frame.width - 12, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
