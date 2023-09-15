//
//  NewslineViewController.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

class NewslineViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
    
        newsFeedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedTableViewCell")
        
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        // Do any additional setup after loading the view.
    }


}

// MARK: TableView DataSource and Delegate
extension NewslineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell") as! NewsFeedTableViewCell
        cell.updateCell(title: "Title", information: "Info", likes: 132, days: 23)
        return cell
    }
    
    
}
