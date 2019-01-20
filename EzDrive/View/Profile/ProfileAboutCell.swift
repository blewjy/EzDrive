//
//  ProfileAboutCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 19/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProfileAboutCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            nameLabel.text = user.name
            emailLabel.text = user.email
            locationLabel.text = user.location
            
            Database.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                self.postsLabel.text = String(dictionaries.count)
                
            }) { (error) in
                print("Failed to retrieve posts from Database: ", error)
            }
            
            memberSinceLabel.text = user.memberSince
            
            
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let memberSinceLabel: UILabel = {
        let label = UILabel()
        label.text = "11 Sept 2001"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    
    lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let icon = UIImageView.init(image: #imageLiteral(resourceName: "ezdrive_profilename").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .gray
        view.addSubview(icon)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(self.nameLabel)
        nameLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, bottom: nil, right: label.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        return view
    }()
    
    lazy var emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        let icon = UIImageView.init(image: #imageLiteral(resourceName: "ezdrive_profileemail").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .gray
        view.addSubview(icon)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(self.emailLabel)
        emailLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, bottom: nil, right: label.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        return view
    }()
    
    lazy var locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        let icon = UIImageView.init(image: #imageLiteral(resourceName: "ezdrive_profilelocation").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .gray
        view.addSubview(icon)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(self.locationLabel)
        locationLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, bottom: nil, right: label.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        return view
    }()
    
    lazy var postsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        let icon = UIImageView.init(image: #imageLiteral(resourceName: "ezdrive_profilenumberofposts").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .gray
        view.addSubview(icon)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        let label = UILabel()
        label.text = "Number of posts"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(self.postsLabel)
        postsLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, bottom: nil, right: label.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        return view
    }()
    
    lazy var memberSinceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        let icon = UIImageView.init(image: #imageLiteral(resourceName: "ezdrive_profilemembersince").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .gray
        view.addSubview(icon)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        let label = UILabel()
        label.text = "Member since"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(self.memberSinceLabel)
        memberSinceLabel.anchor(top: label.bottomAnchor, left: label.leftAnchor, bottom: nil, right: label.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        return view
    }()
    
    func setupViews() {

        let stackView = UIStackView(arrangedSubviews: [nameView, emailView, locationView, postsView, memberSinceView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        
        
    }
    
    
    
}





















