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

class SORAlbumPage: Object, Mappable {
    
    @objc dynamic var pageId   = ""
    @objc dynamic var pageNext = ""
    
    var pageItems = List<SORAlbum>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        pageId    <- map["id"]
        pageNext  <- map["next"]
        pageItems <- (map["items"], ArrayTransform<SORAlbum>())
    }
    
    override static func primaryKey() -> String? {
        return "pageId"
    }
}

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

class ArrayTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(JSONObject: entry)!
                result.append(model)
            }
        }
        return result
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        if ((value?.count)! > 0)
        {
            var result = Array<T>()
            for entry in value! {
                result.append(entry)
            }
            return result
        }
        return nil
    }
}
