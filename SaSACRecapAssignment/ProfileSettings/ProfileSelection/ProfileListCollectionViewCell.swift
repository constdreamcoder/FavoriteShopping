//
//  ProfileListCollectionViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class ProfileListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var referenceProfileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        DispatchQueue.main.async {
            self.referenceProfileImageView.layer.cornerRadius = self.referenceProfileImageView.frame.width / 2
        }
    }
    
    func selected() {
        referenceProfileImageView.layer.borderColor = Colors.pointColor.cgColor
        referenceProfileImageView.layer.borderWidth = 5
    }
    
    func deselected() {
        referenceProfileImageView.layer.borderColor = UIColor.clear.cgColor
        referenceProfileImageView.layer.borderWidth = 0
    }

}
