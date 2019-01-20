//
//  SinglePostPostCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 2/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SinglePostPostCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            
            self.postImageView.loadImage(urlString: post.imageUrl)
            
            setupPostTextView(post: post)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    func setupPostTextView(post: Post) {
        
        let attributedText = NSMutableAttributedString(string: post.title, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]))
        
        
        attributedText.append(NSAttributedString(string: "🕒   \(Date(timeIntervalSince1970: post.timestamp).timeAgoDisplay())", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]))
        attributedText.append(NSAttributedString(string: "🏷   S$\(post.price)/day", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]))
        attributedText.append(NSAttributedString(string: "🚘   \(post.carModel)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]))
        attributedText.append(NSAttributedString(string: "🗺   \(post.location)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]))
        attributedText.append(NSAttributedString(string: post.description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]))
        
        postTextView.attributedText = attributedText
    }
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    func setupViews() {
        addSubview(postImageView)
        addSubview(postTextView)
        
        postImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 1).isActive = true

        postTextView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: self.frame.width + 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)

    }
    
    
    
    
}





