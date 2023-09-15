//
//  NewslineViewController.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

class NewslineViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    let downloadManager = NetworkFetchService()
    
    var newsFeed: NewsFeedModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
    
        newsFeedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedTableViewCell")
        
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self

        downloadManager.requestAllNews { (data, error) in
            if let data = data {
                self.newsFeed = data
                self.newsFeedTableView.reloadData()
            }
        }
    }
}

// MARK: TableView DataSource and Delegate

extension NewslineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed?.posts.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell") as! NewsFeedTableViewCell
        guard let array = newsFeed?.posts else { return cell }
            cell.updateCell(title: array[indexPath.row].title, information: array[indexPath.row].preview_text, likes: array[indexPath.row].likes_count, days: array[indexPath.row].timeshamp)
        return cell
    }
}
