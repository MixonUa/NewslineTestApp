//
//  DetailedInformationViewController.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

class DetailedInformationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    struct DetailedNewsViewModel {
        var timeshamp: Double
        var title: String
        var text: String
        var likes: Int

    }

    var detailedNews = [DetailedNewsViewModel]()
    var image: Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
        
        fillInformation()
        setImage()
    }
    
    public func setupViewModels(_ post: Post)  {
        detailedNews.append(DetailedNewsViewModel(timeshamp: post.timeshamp,
                                                title: post.title,
                                                text: post.text,
                                                likes: post.likes_count))
    }

    private func fillInformation() {
        titleLabel.text = detailedNews[0].title
        textLabel.text = detailedNews[0].text
        likesLabel.text = "\u{2764} \(detailedNews[0].likes)"
        dateLabel.text = "\(detailedNews[0].timeshamp.daysAgo()) day ago"
    }
    
    private func setImage() {
        imageView.image = UIImage(data: image)
    }
}
