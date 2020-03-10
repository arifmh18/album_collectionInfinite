//
//  AlbumCell.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import UIKit
import Kingfisher

protocol AlbumDelegate : AnyObject {
    func getPhoto(id:String)
}
class AlbumCell: UICollectionViewCell {
    
    let image : [UIImage] = [(UIImage(named: "albums1")!),
                             (UIImage(named: "albums2")!),
                             (UIImage(named: "albums3")!),
                             (UIImage(named: "albums4")!),
                             (UIImage(named: "albums5")!),
                             (UIImage(named: "albums6")!),
                             (UIImage(named: "albums7")!)]
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var item_label: UILabel!
    @IBOutlet weak var item_content: UIView!
    var id = ""
    weak var delegate : AlbumDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    func setData(data: GetAlbum.Results){
        let number = Int.random(in: 0 ... 6)
        
        self.id = data.user_id ?? ""
        self.item_img.image = self.image[number]
        self.item_label.text = data.title ?? ""
        
        let konten = UITapGestureRecognizer(target: self, action:  #selector (self.kontenPhoto(_:)))
        self.item_content.addGestureRecognizer(konten)
    }
    @objc func kontenPhoto(_ sender:UITapGestureRecognizer){
        self.delegate?.getPhoto(id: self.id)
    }

}
