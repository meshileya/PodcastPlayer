//
//  ApiService.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import Alamofire
//import XMLParsing
import XMLMapper
//import AlamofireObjectMapper

class ApiService {
    
    typealias CompletionHandler = (_ result: Bool, _ data: RSSFeed, _ error: Error?) -> Void
    let baseUrl = "http://feeds.soundcloud.com/"
    
    func homeFeedUrl() -> String{
        return baseUrl + "users/soundcloud:users:209573711/sounds.rss"
    }
    
    func userFetchVideoDetail( handler : @escaping CompletionHandler){
        Alamofire.request(homeFeedUrl()).responseXMLObject { (response: DataResponse<RSSFeed>) in
            let rssFeed = response.result.value
            if(rssFeed != nil){
                handler(true, rssFeed!, nil)
            }else{
//                handler(false, RSSFeed?, nil)
            }
            
        }
    }
  
    }
