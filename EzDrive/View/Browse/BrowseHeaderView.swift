//
//  BrowseView.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

protocol BrowseHeaderViewDelegate {
    func didTapSortFilterButton()
    func didTapLocationButton()
}

class BrowseHeaderView: UIView {
    
    var delegate: BrowseHeaderViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        setupViews()
    }

    let headerViewHeight: CGFloat = 50.0
    
    let locationButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📍 LOCATION  ▼"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Singapore (All)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let sortFilterButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sortFilterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "⇅ SORT/FILTER  ▼"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    var sortFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "None"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let centerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        addSubview(locationButtonView)
        addSubview(sortFilterButtonView)
        addSubview(locationTitleLabel)
        addSubview(locationLabel)
        addSubview(sortFilterTitleLabel)
        addSubview(sortFilterLabel)
        addSubview(centerSeparatorView)
        addSubview(bottomSeparatorView)

        locationButtonView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        locationButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        locationButtonView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        locationButtonView.rightAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        sortFilterButtonView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sortFilterButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sortFilterButtonView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sortFilterButtonView.leftAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        locationTitleLabel.topAnchor.constraint(equalTo: locationButtonView.topAnchor, constant: 5).isActive = true
        locationTitleLabel.leftAnchor.constraint(equalTo: locationButtonView.leftAnchor, constant: 12).isActive = true
        locationTitleLabel.widthAnchor.constraint(equalTo: locationButtonView.widthAnchor, constant: -12).isActive = true
        locationTitleLabel.heightAnchor.constraint(equalToConstant: headerViewHeight/2 - 6).isActive = true

        sortFilterTitleLabel.topAnchor.constraint(equalTo: sortFilterButtonView.topAnchor, constant: 5).isActive = true
        sortFilterTitleLabel.leftAnchor.constraint(equalTo: sortFilterButtonView.leftAnchor, constant: 12).isActive = true
        sortFilterTitleLabel.widthAnchor.constraint(equalTo: sortFilterButtonView.widthAnchor, constant: -12).isActive = true
        sortFilterTitleLabel.heightAnchor.constraint(equalToConstant: headerViewHeight/2 - 6).isActive = true

        locationLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: locationButtonView.leftAnchor, constant: 12).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: locationButtonView.widthAnchor, constant: -12).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: headerViewHeight/2 - 6).isActive = true

        sortFilterLabel.topAnchor.constraint(equalTo: sortFilterTitleLabel.bottomAnchor).isActive = true
        sortFilterLabel.leftAnchor.constraint(equalTo: sortFilterButtonView.leftAnchor, constant: 12).isActive = true
        sortFilterLabel.widthAnchor.constraint(equalTo: sortFilterButtonView.widthAnchor, constant: -12).isActive = true
        sortFilterLabel.heightAnchor.constraint(equalToConstant: headerViewHeight/2 - 6).isActive = true

        centerSeparatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        centerSeparatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        centerSeparatorView.heightAnchor.constraint(equalToConstant: headerViewHeight - 16).isActive = true
        centerSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        // Add tap gestures
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectLocation))
        locationButtonView.addGestureRecognizer(locationTapGesture)
        locationButtonView.isUserInteractionEnabled = true
        
        let sortFilterTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectSortFilter))
        sortFilterButtonView.addGestureRecognizer(sortFilterTapGesture)
        sortFilterButtonView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectLocation() {
        delegate?.didTapLocationButton()
    }
    
    @objc func handleSelectSortFilter() {
        delegate?.didTapSortFilterButton()
    }
    
}











