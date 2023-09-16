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
    
    private var currentState = ButtonState.expand
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setExpandButtonState()
        collapseText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Cell
    func updateCell(title: String, information: String, likes: Int, days: Int) {
        titleLabel.text = title
        informationLabel.text = information
        likesLabel.text = "\u{2764}" + String(likes)
        daysAgoLabel.text = String(days) + " day" + " ago"
    }
    
    // MARK: BUTTON
    private func setExpandButtonState() {
        textModifyButton.setTitle("Expand", for: .normal)
    }
    
    private func setCollapseButtonState() {
        textModifyButton.setTitle("Collapse", for: .normal)
    }
    
    private func expandText() {
        informationLabel.numberOfLines = 0
    }
    private func collapseText() {
        informationLabel.numberOfLines = 2
    }
    
    private func checkState() {
        switch currentState {
        case .expand:
            expandText()
            setCollapseButtonState()
            currentState = ButtonState.collapse
            break
        case .collapse:
            collapseText()
            setExpandButtonState()
            currentState = ButtonState.expand
            break
        }
    }
    
    @IBAction func textModifyButtonPressed(_ sender: Any) {
        checkState()
    }
}
