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
    let networkManager = NetworkManager()
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsId = newsFeed?.posts[indexPath.row].postId else { return }
        guard let nextVC = storyboard?.instantiateViewController(identifier: "DetailedInformationViewController") as? DetailedInformationViewController else { return }
        downloadManager.requestDetailedNew(id: newsId) { (data, error) in
            guard let downloadedData = data else { return }
            nextVC.detailedNews = data
            self.networkManager.requestData(urlString: downloadedData.post.postImage) { (imageData, error) in
                if let data = imageData {
                    nextVC.image = data
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
