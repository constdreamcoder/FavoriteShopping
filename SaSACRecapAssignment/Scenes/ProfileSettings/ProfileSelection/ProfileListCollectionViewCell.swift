//
//  ProfileListCollectionViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit
import SnapKit

final class ProfileListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let referenceProfileImageView = UIImageView()
    
    // MARK: - Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Medthods
    func configureConstraints() {
        contentView.addSubview(referenceProfileImageView)
        
        referenceProfileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        backgroundColor = .clear
        
        referenceProfileImageView.contentMode = .scaleAspectFit
        
        DispatchQueue.main.async {
            self.referenceProfileImageView.clipsToBounds = true
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
