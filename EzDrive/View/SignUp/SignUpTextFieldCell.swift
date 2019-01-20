//
//  SignUpTextFieldCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SignUpTextFieldCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var placeholderText: String? {
        didSet {
            self.cellTextField.placeholder = placeholderText
        }
    }
    
    let cellTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(cellTextField)
        
        cellTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        cellTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
    
        
    }
}
