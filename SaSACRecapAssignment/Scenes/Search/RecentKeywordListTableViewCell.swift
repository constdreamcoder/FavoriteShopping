//
//  RecentKeywordListTableViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit

final class RecentKeywordListTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var magnifyingGlassImageView: UIImageView!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var removeKeywordButton: UIButton!
    
    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        magnifyingGlassImageView.image = UIImage(systemName: "magnifyingglass")
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        
        keywordLabel.textColor = Colors.textColor
        keywordLabel.textAlignment = .left
        keywordLabel.font = .systemFont(ofSize: 16.0)
        
        removeKeywordButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
}
