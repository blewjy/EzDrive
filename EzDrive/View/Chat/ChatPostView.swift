//
//  ChatPostView.swift
//  EzDrive
//
//  Created by Bryan Lew on 17/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ChatPostView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "TITLE\n$10"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let forwardImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ezdrive_forward").withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupViews() {
        addSubview(postImageView)
        addSubview(postLabel)
        addSubview(separatorLineView)
        addSubview(forwardImageView)
        
        postImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
        postImageView.widthAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 1).isActive = true
        
        postLabel.anchor(top: postImageView.topAnchor, left: postImageView.rightAnchor, bottom: postImageView.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        separatorLineView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        forwardImageView.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 0)
        
    }
    
}
