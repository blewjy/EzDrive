//
//  FilterCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 16/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "By Car Model:"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let modelLabel: UILabel = {
       let label = UILabel()
        label.text = "Select"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(modelLabel)
        
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 150, height: 0)
        
        modelLabel.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 200, height: 0)
        
        
    }
    
}
