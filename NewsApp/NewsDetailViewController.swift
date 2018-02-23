//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Shithin_Focaloid on 23/02/18.
//  Copyright © 2018 Focaloid. All rights reserved.
//

import UIKit

class NewImageCell:UITableViewCell {
    @IBOutlet var imageViewNews: UIImageView!
    
}

class NewDetailCell:UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDetail: UILabel!
}

class NewsDetailViewController: UITableViewController {

    var news:News!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 100
        
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: NewImageCell = tableView.dequeueReusableCell(withIdentifier: "NewImageCell", for: indexPath) as! NewImageCell
            if let url = URL.init(string: news.imageURLString) {
                WebService.shared.downloadImage(url: url) { (image) in
                    if let _image = image {
                        cell.imageViewNews?.image = _image
                        print(_image)
                    }
                }
            }
            return cell
        }else if indexPath.row == 1 {
            let cell: NewDetailCell = tableView.dequeueReusableCell(withIdentifier: "NewDetailCell", for: indexPath) as! NewDetailCell
            cell.labelTitle.text = self.news.title
            cell.labelDetail.text = self.news.details
            
            return cell
        }
        
        return UITableViewCell()

    }


}
