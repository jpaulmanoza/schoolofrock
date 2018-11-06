//
//  SOREntity.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class SORAlbum: Object, Mappable {
    
    @objc dynamic var albumName    = ""
    @objc dynamic var albumId      = ""
    @objc dynamic var albumRelease = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        albumId      <- map["id"]
        albumName    <- map["name"]
        albumRelease <- map["release_date"]
    }
    
    override static func primaryKey() -> String? {
        return "albumId"
    }
}
