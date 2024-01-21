//
//  ResultListCollectionViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit

class ResultListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var mallNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var productId: String = ""
    var isHeartPressed: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 16

        DispatchQueue.main.async {
            self.heartButton.layer.cornerRadius = self.heartButton.frame.width / 2
        }
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        initializeHeartButtonImage()
    }
    
    private func initializeHeartButtonImage() {
        guard let heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        isHeartPressed = heartPressedList[productId] as? Bool ?? false
        
        if isHeartPressed {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func updateHeartButtonImage() {
        guard let heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        let currentStateOfheartPressed = heartPressedList[productId] as? Bool ?? false
        if currentStateOfheartPressed {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        guard var heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else {
            return }
        isHeartPressed = heartPressedList[productId] as? Bool ?? false
        heartPressedList[productId] = !isHeartPressed
        isHeartPressed = !isHeartPressed
        
        if isHeartPressed {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        UserDefaults.standard.set(heartPressedList, forKey: UserDefaultsKeys.heartPressedList.rawValue)
    }
}
