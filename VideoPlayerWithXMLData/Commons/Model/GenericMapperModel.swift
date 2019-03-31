//
//  GenericMapperModel.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import XMLMapper

class RSSFeed: XMLMappable {
    var nodeName: String!
    
    var channel: Channel?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        channel <- map["channel"]
    }
}

class Channel: XMLMappable {
    var nodeName: String!
    
    var link: URL?
    var title: String?
    var pubDate: Date?
    var lastBuildDate: Date?
    var language: String?
    var copyright: String?
    var description: String?
    var category: String?
    var generator: String?
    var docs: URL?
    var image: [Image]?
    var items: [Item]?
    
    private static var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        title <- map["title"]
        link <- (map["link"], XMLURLTransform())
        description <- map["description"]
        language <- map["language"]
        copyright <- map["copyright"]
        pubDate <- (map["pubDate"], XMLDateFormatterTransform(dateFormatter: Channel.dateFormatter))
        lastBuildDate <- (map["lastBuildDate"], XMLDateFormatterTransform(dateFormatter: Channel.dateFormatter))
        category <- map["category"]
        generator <- map["generator"]
        docs <- (map["docs"], XMLURLTransform())
        items <- map["item"]
        image <- map["image"]
    }
}

class Image: XMLMappable {
    var nodeName: String!
    
    var _href: String!
    var __prefix: String!
    var url: String!
    var title: String!
    var link: String!
    
    private static var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        _href <- map["_href"]
        __prefix <- map["__prefix"]
        url <- map["url"]
        title <- map["title"]
        link <- map["link"]
    }
}

class Item: XMLMappable {
    var nodeName: String!
    
    var title: String?
    var link: URL?
    var description: String?
    var pubDate: Date?
    var enclosure: Enclosure?
    var image: ItemImage?
    
    private static var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        title <- map["title"]
        link <- (map["link"], XMLURLTransform())
        description <- map["description"]
        pubDate <- (map["pubDate"], XMLDateFormatterTransform(dateFormatter: Item.dateFormatter))
        image <- map["image"]
        enclosure <- map["enclosure"]
        
    }
}

class ItemImage: XMLMappable {
    var nodeName: String!
    
    var _href: String?
    var __prefix: String?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        //        _href <- map["_href"]
        _href <- map["_href"]
        __prefix <- map["__prefix"]
    }
}

class Enclosure: XMLMappable {
    var nodeName: String!
    
    var _type: String!
    var _url: String!
    var _length: String!
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        //        _href <- map["_href"]
        _type <- map["_type"]
        _url <- map["_url"]
        _length <- map["_length"]
    }
}
