//
//  ShareTextFieldCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ShareTextFieldCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.5
            } else {
                self.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let iconsArray: [UIImage] = [#imageLiteral(resourceName: "ezdrive_sharetitle"), #imageLiteral(resourceName: "ezdrive_shareprice"), #imageLiteral(resourceName: "ezdrive_sharecarmodel"), #imageLiteral(resourceName: "ezdrive_sharelocation"), #imageLiteral(resourceName: "ezdrive_sharelicense")]
    let cellLabelArray: [String] = ["Title", "Price/day", "Car Model", "Location", "License Plate No."]
    let placeholdersArray: [String] = ["Name your post", "Proposed price/day", "Select Car Model", "Select Location", "SXX-XXXX-X"]
    
    var iconImage: UIImage? {
        didSet {
            self.iconImageView.image = iconImage
        }
    }
    
    var cellLabelText: String? {
        didSet {
            self.cellLabel.text = cellLabelText
        }
    }
    
    var placeholderText: String? {
        didSet {
            self.cellTextField.placeholder = placeholderText
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .green
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .darkGray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
//        label.backgroundColor = .cyan
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellTextField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = .yellow
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.textAlignment = .right
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(iconImageView)
        addSubview(cellLabel)
        addSubview(cellTextField)
        
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1).isActive = true
        
        cellLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        cellLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        cellTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellTextField.leftAnchor.constraint(equalTo: cellLabel.rightAnchor, constant: 16).isActive = true
        cellTextField.rightAnchor.constraint(equalTo: self
            .rightAnchor, constant: -16).isActive = true
    }
}
