//
//  SinglePostSellerHeader.swift
//  EzDrive
//
//  Created by Bryan Lew on 2/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SinglePostSellerHeader: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
    
        setupViews()
    }
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Owner Info"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {        
        addSubview(headerLabel)
        
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
}
