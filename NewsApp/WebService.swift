//
//  WebService.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WebService {

    static var shared: WebService = WebService()
//    let API_KEY = "07804ed2add744dab3bedc85d4f132cb"
    let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=07804ed2add744dab3bedc85d4f132cb"
    
    
    
    
    
    func getNewsFeed(completion:@escaping (([News]) -> Void)){
//        var array = [News]()
////        let parameters = ["country":"us",
////                          "category":"business",
////                          "apiKey":API_KEY
////                          ]
//        Alamofire.request(URL.init(string: urlString)!).response { (dataResponse) in
//
//            let json:JSON = JSON(dataResponse)
//
//
//            DispatchQueue.main.async {
//                completion(array)
//            }
//            print(array)
//        }
        
        
        URLSession.shared.dataTask(with: URL.init(string: urlString)!) { (data, response, error) in
            if error == nil{
                if (response as! HTTPURLResponse).statusCode == 200 {
                    do{
                        let json = try JSON.init(data: data!)
                        completion(News.modelsFromJSON(json: json))
                        
                    }catch {print(error)}
                }
            }
            
            
        }.resume()
        
    }
    
    func downloadImage(url:URL, completion:@escaping ((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil{
                if (response as! HTTPURLResponse).statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(UIImage.init(data: data!))
                    }
                }
            }
            
            
            }.resume()
    }
    
}
