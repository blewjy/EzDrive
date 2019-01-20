//
//  SinglePostUserCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 2/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SinglePostUserCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.7
            } else {
                self.alpha = 1
            }
        }
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }

            self.userImageView.loadImage(urlString: user.profileImageUrl)
            
            setupUserLabel(user: user)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    func setupUserLabel(user: User) {
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: user.handle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
    
        userLabel.attributedText = attributedText
    }
    
    
    let userImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let forwardImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ezdrive_forward").withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }()
    
    func setupViews() {
        
        addSubview(userImageView)
        addSubview(forwardImageView)
        addSubview(userLabel)
        
        userImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 100, height: 0)

        userImageView.layer.cornerRadius = 50
        
        forwardImageView.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 0)
        
        userLabel.anchor(top: self.topAnchor, left: userImageView.rightAnchor, bottom: self.bottomAnchor, right: forwardImageView.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        
        
    }
    
    
    
    
}


