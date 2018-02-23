//
//  NewListTableViewController.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import UIKit
import RealmSwift

protocol NewListCellDelegate {
    func newListCell(_ cell:NewListCell, didSelectBookMarlAt index:IndexPath)
}

class NewListCell:UITableViewCell {
    
    var indexPath:IndexPath!
    var delegate:NewListCellDelegate!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var labelDate: UILabel!
    
    @IBAction func buttonActionBookMark(_ sender: Any) {
        self.delegate?.newListCell(self, didSelectBookMarlAt: indexPath)
        
    }
}


class NewListViewController: UITableViewController,NewListCellDelegate {
    let realm = try! Realm()
    let searchController = UISearchController(searchResultsController: nil)
    var newsList = [News]()
    var filteredNewsList = [News]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        //SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        
        WebService.shared.getNewsFeed { (newsList) in
            self.newsList = newsList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredNewsList.count
        }
        
        return newsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var news:[News]
        if isFiltering() {
            news = filteredNewsList
        }else{
            news = newsList
        }
        
        let cell:NewListCell = tableView.dequeueReusableCell(withIdentifier: "NewListCell", for: indexPath) as! NewListCell
        cell.labelTitle.text = news[indexPath.row].title
        cell.labelDetail.text = news[indexPath.row].details
        let date = news[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd yyyy"
        cell.labelDate.text = dateFormatter.string(from: date)
        cell.indexPath = indexPath
        cell.delegate = self
        if let url = URL.init(string: news[indexPath.row].imageURLString) {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }


    
    // MARK: - NewListCellDelegate
    func newListCell(_ cell: NewListCell, didSelectBookMarlAt index: IndexPath) {
        
        var newsArray:[News]
        if isFiltering() {
            newsArray = filteredNewsList
        }else{
            newsArray = newsList
        }
        
        let news = newsArray[index.row]
        
        let favorite = FavoriteNews()
        favorite.title = news.title
        favorite.details = news.details
        favorite.imageURLString = news.imageURLString
        favorite.date = news.date
        
        try! realm.write {
            realm.add(favorite)
        }

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowBookMarks" {
        
        
        }else if segue.identifier == "ShowDetail" {
            
            var news:[News]
            if isFiltering() {
                news = filteredNewsList
            }else{
                news = newsList
            }
            
            let destination = (segue.destination as! NewsDetailViewController)
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.news = news[indexPath.row]
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}



extension NewListViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNewsList = newsList.filter({( news : News) -> Bool in
            return news.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
