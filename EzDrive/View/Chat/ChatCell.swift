//
//  ChatCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 3/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            guard let message = message else { return }
            
            self.chatMessageTextView.text = message.message
            
            setupToAndFromViews()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
       


    }

    
    func setupToAndFromViews() {
        guard let message = message else { return }
                
        addSubview(userImageView)
        addSubview(userTimeLabel)
        addSubview(chatMessageTextView)

        self.userImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        self.userTimeLabel.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 18)
        
        self.chatMessageTextView.anchor(top: userTimeLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        Database.fetchUserWithUID(uid: message.fromId) { (user) in
            self.userImageView.loadImage(urlString: user.profileImageUrl)
            
            let timeAgo = Date(timeIntervalSince1970: message.timestamp).timeAgoDisplay()
            
            self.userTimeLabel.text = "\(user.name) • \(timeAgo)"
        }
        
        
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
    
    let chatMessageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = "MESSAGE HERE"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    

}












