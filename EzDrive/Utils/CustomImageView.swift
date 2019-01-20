//
//  CustomImageView.swift
//  EzDrive
//
//  Created by Bryan Lew on 29/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        self.lastUrlUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
