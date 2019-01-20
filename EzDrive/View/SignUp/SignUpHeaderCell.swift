//
//  SignUpHeaderCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 26/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SignUpHeaderCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var headerLabelText: String? {
        didSet {
            self.headerLabel.text = headerLabelText
        }
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {
        backgroundColor = .clear
        
        addSubview(headerLabel)
        
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

    }
    
    
}
