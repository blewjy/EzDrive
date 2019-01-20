//
//  SignUpProfileImageCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SignUpProfileImageCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var selectedProfileImage: UIImage? {
        didSet {
            if let image = selectedProfileImage {
                self.profileImageView.image = image
                print("A profile image was chosen")
            } else {
                self.profileImageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
                print("A profile image was removed")
            }
        }
    }
    
    var signUpViewController: SignUpViewController?
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileImageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "Choose your profile image", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray])
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: "(You can change this later)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.7, alpha: 1)]))
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(profileImageLabel)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        profileImageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        profileImageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        profileImageLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    
        
        // Add tapGestureRecognizer to profileImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    // This function fires when profileImageView is tapped
    @objc func handleSelectProfileImage() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        signUpViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension SignUpProfileImageCell: UINavigationControllerDelegate {
    
}


extension SignUpProfileImageCell: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            self.selectedProfileImage = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.selectedProfileImage = originalImage
        }
        
        
        
        signUpViewController?.dismiss(animated: true, completion: nil)
    }
}







