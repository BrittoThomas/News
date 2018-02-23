//
//  News.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import Foundation
import SwiftyJSON
class News {
    
    var title = String()
    var imageURLString = String()
    var details = String()
    var date = Date()
    
    class func modelsFromJSON(json:JSON) -> [News] {
        var array = [News]()
        for newsJSON in json["articles"].arrayValue {
            array.append(News.init(json: newsJSON))
        }
        return array
    }
    
    init(favorite:FavoriteNews) {
        self.title = favorite.title
        self.details = favorite.details
        self.imageURLString = favorite.imageURLString
        self.date = favorite.date
    }
    
    init(json:JSON) {
        self.title = json["title"].stringValue
        self.details = json["description"].stringValue
        self.imageURLString = json["urlToImage"].stringValue
        
        if let dateString = json["publishedAt"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-02-23T08:55:21Z
            self.date = dateFormatter.date(from: dateString)!
        }

    }
}

