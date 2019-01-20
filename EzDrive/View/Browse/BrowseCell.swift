//
//  BrowseCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 24/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

protocol BrowseCellDelegate {
    func didTapMoreButton()
}

class BrowseCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.5
            } else {
                self.alpha = 1
            }
        }
    }
    
    var delegate: BrowseCellDelegate?
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            self.postImageView.loadImage(urlString: post.imageUrl)
            self.postTitleLabel.text = post.title
            self.postPriceLabel.text = "$\(post.price)"
            
            let timeAgo = Date(timeIntervalSince1970: post.timestamp).timeAgoDisplay()
            
            self.postTimeLocationLabel.text = "\(timeAgo) • \(post.location)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellAttributes()
        setupCellViews()
    }
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .red
        label.text = "Title goes here."
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postPriceLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .green
        label.textColor = .red
        label.text = "$9,999.99"
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTimeLocationLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .blue
        label.text = "9 hours ago • Orchard Road"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var postMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ezdrive_postmore").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
//        button.backgroundColor = .yellow
        button.tintColor = button.isTouchInside ? .gray : .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleMoreButton() {
        self.delegate?.didTapMoreButton()
    }
    
    func setupCellViews() {
        addSubview(postImageView)
        addSubview(postTitleLabel)
        addSubview(postPriceLabel)
        addSubview(postTimeLocationLabel)
        addSubview(postMoreButton)
        
        postImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        postTitleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 4).isActive = true
        postTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        postTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        postTitleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        postPriceLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 1).isActive = true
        postPriceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        postPriceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        postPriceLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        postTimeLocationLabel.topAnchor.constraint(equalTo: postPriceLabel.bottomAnchor).isActive = true
        postTimeLocationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        postTimeLocationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postTimeLocationLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        postMoreButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 2).isActive = true
        postMoreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        postMoreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        postMoreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22).isActive = true
        

    }

    func setupCellAttributes() {
        backgroundColor = .white
        layer.cornerRadius = 5.0
        
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    

}
