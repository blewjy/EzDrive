//
//  ProfileReviewReviewCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 19/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ProfileReviewReviewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    var review: Review? {
        didSet {
            
            guard let review = review else { return }
            
            userImageView.loadImage(urlString: review.user.profileImageUrl)

        
            let timeAgo = Date(timeIntervalSince1970: review.timestamp).timeAgoDisplay()
            
            
            userTimeLabel.text = "\(review.user.name) • \(timeAgo)"
            reviewTextView.text = review.message
            
            emojiImageView.image = review.rating == 0 ? #imageLiteral(resourceName: "ezdrive_happyface") : #imageLiteral(resourceName: "ezdrive_sadface")
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Username • 9 hours ago"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = "MESSAGE HERE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_happyface")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    func setupViews() {
        
        addSubview(userImageView)
        addSubview(userTimeLabel)
        addSubview(reviewTextView)
        addSubview(emojiImageView)
        
        self.userImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        self.userTimeLabel.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 18)
        
        self.reviewTextView.anchor(top: userTimeLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
        
        self.emojiImageView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        
    }
    
    
    
    
    
    
}
