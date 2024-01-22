//
//  ProfileListCollectionViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

final class ProfileListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var referenceProfileImageView: UIImageView!
    
    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        referenceProfileImageView.contentMode = .scaleAspectFit
        
        DispatchQueue.main.async {
            self.referenceProfileImageView.layer.cornerRadius = self.referenceProfileImageView.frame.width / 2
        }
    }
    
    // MARK: - Custom Medthods
    func selected() {
        referenceProfileImageView.layer.borderColor = Colors.pointColor.cgColor
        referenceProfileImageView.layer.borderWidth = 5
    }
    
    func deselected() {
        referenceProfileImageView.layer.borderColor = UIColor.clear.cgColor
        referenceProfileImageView.layer.borderWidth = 0
    }
}
