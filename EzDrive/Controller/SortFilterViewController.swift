//
//  SortFilterViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 15/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SortFilterViewController: UICollectionViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    let filterCellId = "filterCellId"
    
    var browseViewController: BrowseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(FilterCell.self, forCellWithReuseIdentifier: filterCellId)
        setupViews()
        setupNavBarItems()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .white
            
            var label = ""
            
            switch indexPath.section {
                case 0:
                    switch indexPath.item {
                    case 0:
                        label = "   Recent"
                    case 1:
                        label = "   Price: Low to High"
                    case 2:
                        label = "   Price: High to Low"
                    default:
                        label = ""
                    }
                default:
                    label = ""
            }
            
            let cellLabel = UILabel()
            cellLabel.text = label
            cellLabel.font = UIFont.systemFont(ofSize: 14)
            
            cell.addSubview(cellLabel)
            cellLabel.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellId, for: indexPath) as! FilterCell
            
             let selectedModel =  SelectCarModelViewController.carLabels[selectedCarModel]
            
            cell.modelLabel.text = selectedModel
            
            return cell
        }
    }
 
    
    var selectedCarModel = 8 {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 0, section: 1)])
        }
    }
    
    var selectedSort = 3
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedSort != 3 {
            let selectedIndexPath = IndexPath(item: selectedSort, section: 0)
            selectCell(indexPath: selectedIndexPath)
        }
    }
    
    func selectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .lightGray
    }
    
    func deselectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .white
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let prevSelection = selectedSort
            
            if prevSelection == 3 {
                selectCell(indexPath: indexPath)
                selectedSort = indexPath.item
            } else {
                let previousIndexPath = IndexPath(item: prevSelection, section: 0)
                deselectCell(indexPath: previousIndexPath)
                selectedSort = 3
                if previousIndexPath != indexPath {
                    selectCell(indexPath: indexPath)
                    selectedSort = indexPath.item
                }
            }

        } else {
            let carModelViewController = CarModelViewController(collectionViewLayout: UICollectionViewFlowLayout())
            carModelViewController.sortFilterViewController = self
            carModelViewController.selectedModel = self.selectedCarModel
            self.navigationController?.pushViewController(carModelViewController, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath)
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        if indexPath.section == 0 {
            headerLabel.text = "   Sort"
        } else {
            headerLabel.text = "   Filter"
        }
        
        header.addSubview(headerLabel)
        headerLabel.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return header
        
        
    }
    
    lazy var cancelButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ezdrive_clearpost"), style: .plain, target: self, action: #selector(handleCancel))
        return barButton
    }()
    
    @objc func handleCancel() {
        print("Dismiss")
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var resetButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        return barButton
    }()
    
    @objc func handleReset() {
        print("Reset")
        
        // Deselect all rows
        
        deselectCell(indexPath: IndexPath(item: self.selectedSort, section: 0))
        self.selectedSort = 3
        
        self.selectedCarModel = 8
        
    }
    
    func setupNavBarItems() {
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = resetButton
    }
    
    let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(r: 29, g: 161, b: 242)
        button.layer.cornerRadius = 25.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        return button
    }()
    
    @objc func handleApply() {
        print("Apply")
        self.browseViewController?.activeSort = self.selectedSort
        self.browseViewController?.activeCarFilter = self.selectedCarModel
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(applyButton)
        
        applyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 50)
    }
    
   
}

extension SortFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
}









