//
//  NewslineViewController.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

struct PostCellViewModel {
    let post: Posts
    var collapsed: Bool
    let buttonHandler: (Posts) -> Void
}

class NewslineViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    private let downloadManager = NetworkFetchService()
    private let networkManager = NetworkManager()
    
    private var cellModel = [PostCellViewModel]()
    
    private var topMenu = UIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAll()
        self.title = "News"
    
        newsFeedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedTableViewCell")
        
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        
        requestData()

    }
    
    private func requestData() {
        downloadManager.requestAllNews() { result in
            switch result {
            case .success( let answer): self.cellModel = self.setupViewModels(answer.posts); self.newsFeedTableView.reloadData()
            case .failure(let networkError): self.showAlert(title: "Something goes wrong!", message: "FAILURE due to \(networkError.localizedDescription)")
//            case .failure(let decodingError as DecodingError): print("ERROR Decoder \(decodingError)")
            }
        }
    }
    
    private func setupViewModels(_ posts: [Posts]) -> [PostCellViewModel] {
        posts.map { post in
            PostCellViewModel(post: post, collapsed: true, buttonHandler: { post in
                if let index = self.cellModel.firstIndex(where: { $0.post.postId == post.postId }) {
                    var model = self.cellModel[index]
                    let current = model.collapsed
                    model.collapsed = !current
                    self.cellModel[index] = model
                    let indexPath = IndexPath(row: index, section: 0)
                    self.newsFeedTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
}

// MARK: Settings

extension NewslineViewController {
    
    private func setupTopMenu() {
        let byDate = UIAction(title: "sort by date") { _ in
            self.cellModel.sort(by: {$0.post.timeshamp > $1.post.timeshamp})
            self.newsFeedTableView.reloadData()
        }
        let byLikes = UIAction(title: "sort by likes") { _ in
            self.cellModel.sort(by: {$0.post.likes_count > $1.post.likes_count})
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
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell") as! NewsFeedTableViewCell
        let model = self.cellModel[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = storyboard?.instantiateViewController(identifier: "DetailedInformationViewController") as? DetailedInformationViewController else { return }
        let newsId = cellModel[indexPath.row].post.postId
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
