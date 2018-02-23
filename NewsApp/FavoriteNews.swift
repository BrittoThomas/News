//
//  FavoriteNews.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteNews: Object {
    @objc dynamic var title = String()
    @objc dynamic var imageURLString = String()
    @objc dynamic var details = String()
    @objc dynamic var date = Date()
}
