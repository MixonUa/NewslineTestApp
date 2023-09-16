//
//  NewslineViewController.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

class NewslineViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    private let downloadManager = NetworkFetchService()
    private let networkManager = NetworkManager()
    
    private var newsFeed: NewsFeedModel? = nil
    private var topMenu = UIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAll()
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

extension Double {
    func daysAgo() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let postDate = NSDate(timeIntervalSince1970: self)

        let date1 = calendar.startOfDay(for: today)
        let date2 = calendar.startOfDay(for: postDate as Date)

        let components = calendar.dateComponents([.day], from: date2, to: date1)
        return components.day!
    }
}

// MARK: Settings

extension NewslineViewController {
    
    private func setupTopMenu() {
        let byDate = UIAction(title: "sort by date") { _ in
            self.newsFeed?.posts.sort(by: {$0.timeshamp > $1.timeshamp})
            self.newsFeedTableView.reloadData()
        }
        let byLikes = UIAction(title: "sort by likes") { _ in
            self.newsFeed?.posts.sort(by: {$0.likes_count > $1.likes_count})
            self.newsFeedTableView.reloadData()
        }
        
        topMenu = UIMenu(children: [byDate, byLikes])
    }
    
    private func setupNavigationBar() {
        let barButtonRight = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.on.square"), menu: topMenu)
        barButtonRight.tintColor = .black
        navigationItem.rightBarButtonItem = barButtonRight
    }
    
    private func setupAll() {
        setupTopMenu()
        setupNavigationBar()
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
        cell.updateCell(title: array[indexPath.row].title,
                        information: array[indexPath.row].preview_text,
                        likes: array[indexPath.row].likes_count,
                        days: array[indexPath.row].timeshamp.daysAgo())
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
