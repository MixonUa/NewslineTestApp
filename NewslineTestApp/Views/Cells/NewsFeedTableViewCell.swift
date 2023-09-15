//
//  NewsFeedTableViewCell.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var textModifyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(title: String, information: String, likes: Int, days: Int) {
        titleLabel.text = title
        informationLabel.text = information
        likesLabel.text = "\u{2764}" + String(likes)
        daysAgoLabel.text = String(days) + " day" + " ago"
    }
    @IBAction func textModifyButtonPressed(_ sender: Any) {
    }
}
