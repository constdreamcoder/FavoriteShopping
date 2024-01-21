//
//  RecentKeywordListTableViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit

class RecentKeywordListTableViewCell: UITableViewCell {

    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var removeKeywordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
}
