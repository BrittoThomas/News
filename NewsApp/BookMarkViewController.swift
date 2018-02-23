//
//  BookMarkViewController.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteNewListCell:UITableViewCell {
    
    var indexPath:IndexPath!
    var delegate:NewListCellDelegate!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var labelDate: UILabel!

}


class BookMarkViewController: UITableViewController {
    var newsList:Results<FavoriteNews>!
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        newsList = realm.objects(FavoriteNews.self)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell:FavoriteNewListCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNewListCell", for: indexPath) as! FavoriteNewListCell
        cell.labelTitle.text = newsList[indexPath.row].title
        cell.labelDetail.text = newsList[indexPath.row].details
        let date = newsList[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd yyyy"
        cell.labelDate.text = dateFormatter.string(from: date)
        if let url = URL.init(string: newsList[indexPath.row].imageURLString) {
            WebService.shared.downloadImage(url: url) { (image) in
                if let _image = image {
                    DispatchQueue.main.async {
                        cell.thumbImageView?.image = _image
                    }
                }
            }
        }
        
        
        return cell
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let destination = (segue.destination as! NewsDetailViewController)
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let favoriteNews = newsList[indexPath.row]
                var news = News.init(favorite: favoriteNews)
                destination.news = news
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}
