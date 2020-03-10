//
//  GetAlbum.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import Foundation

struct GetAlbum : Decodable {
    let result : [Results]?
    
    struct Results : Decodable {
        let id : String?
        let user_id : String?
        let title : String?
    }
}
