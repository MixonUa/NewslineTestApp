//
//  NewsFeedTableViewCell.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import UIKit

enum ButtonState {
    case expand
    case collapse
}

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var textModifyButton: UIButton!
    
    private var model: PostCellViewModel?
    private var currentState = ButtonState.expand
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Cell
    func configure(with model: PostCellViewModel) {
        self.model = model
        titleLabel.text = model.post.title
        informationLabel.text = model.post.preview_text
        likesLabel.text = "\u{2764}" + String(model.post.likes_count)
        daysAgoLabel.text = String(model.post.timeshamp.daysAgo()) + " day" + " ago"
        if informationLabel.calculateMaxLines() <= 2 {
            textModifyButton.isHidden = true
        } else {
            textModifyButton.isHidden = false
        }
        if model.collapsed {
            informationLabel.numberOfLines = 2
            textModifyButton.setTitle("Expand", for: .normal)
        } else {
            informationLabel.numberOfLines = 0
            textModifyButton.setTitle("Collapse", for: .normal)
        }
    }
    
    @IBAction func textModifyButtonPressed(_ sender: Any) {
        guard let model = model else { return }
        model.buttonHandler(model.post)
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
