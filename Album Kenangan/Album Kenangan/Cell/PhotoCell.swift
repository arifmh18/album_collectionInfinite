//
//  PhotoCell.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var item_label: UILabel!
    
    func setData(data:GetPhoto.Results){
        let thumb = URL(string: data.thumbnail ?? "")
        self.item_img.kf.indicatorType = .activity
        self.item_img.kf.setImage(with: thumb, placeholder: UIImage(named: "placeholderImage"),
        options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
        
        self.item_label.text = data.title ?? ""
    }
}
