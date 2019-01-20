//
//  ShareDescriptionTextViewCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ShareDescriptionCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descriptionTextView.delegate = self
        setupViews()
    }
    
    
    
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = "Add description here"
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .gray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func setupViews() {
        backgroundColor = .white
        addSubview(descriptionTextView)
        
        descriptionTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
}


extension ShareDescriptionCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add description here" {
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add description here"
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.textColor = .gray
        }
    }
    
}

