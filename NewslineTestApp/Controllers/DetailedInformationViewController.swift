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
    
    var detailedNews: DetailedNewsModel? = nil
    var image: Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillInformation()
        setImage()
    }

    private func fillInformation() {
        guard let item = detailedNews else { return }
        titleLabel.text = item.post.title
        textLabel.text = item.post.text
        likesLabel.text = "\u{2764} \(item.post.likes_count)"
        dateLabel.text = String(item.post.timeshamp)
    }
    
    private func setImage() {
        imageView.image = UIImage(data: image)
    }
}
