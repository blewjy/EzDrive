//
//  ShareHeaderCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ShareHeaderCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var headerLabelText: NSMutableAttributedString? {
        didSet {
            self.headerLabel.attributedText = headerLabelText
        }
    }
    
    
    
    
    let photosHeaderLabelText: NSMutableAttributedString = {
        let attributedText = NSMutableAttributedString(string: "Photo", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    //    attributedText.append(NSAttributedString(string: " (Pick up to 5)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        return attributedText
    }()
    
    let detailsHeaderLabelText: NSMutableAttributedString = {
        let attributedText = NSMutableAttributedString(string: "Details", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        return attributedText
    }()
    
    let descriptionHeaderLabelText: NSMutableAttributedString = {
        let attributedText = NSMutableAttributedString(string: "Description", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " (Optional)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        return attributedText
    }()
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
      //  label.text = "Title"
      //  label.font = UIFont.boldSystemFont(ofSize: 14)
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
