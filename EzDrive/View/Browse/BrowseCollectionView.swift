//
//  BrowseCollectionView.swift
//  EzDrive
//
//  Created by Bryan Lew on 28/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class BrowseCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .clear
        alwaysBounceVertical = true
        translatesAutoresizingMaskIntoConstraints = false
        delaysContentTouches = false
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
