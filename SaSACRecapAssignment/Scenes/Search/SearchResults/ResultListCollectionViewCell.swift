//
//  ResultListCollectionViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit
import SnapKit

final class ResultListCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    let thumbnailImageView = UIImageView()
    let heartButton = UIButton()
    
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        [
            mallNameLabel,
            titleLabel,
            priceLabel
        ].forEach { view.addSubview($0) }
        return view
    }()
    
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    var productId: String = ""
    var isHeartPressed: Bool = false
    
    // MARK: - Life cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
        configureUserEvents()
        initializeHeartButtonImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
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
}

// MARK: - User Events Methods
extension ResultListCollectionViewCell {
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

// MARK: UICollectionViewCell UI And Settings Configuration Methods
extension ResultListCollectionViewCell {
    private func configureConstraints() {
        [
            thumbnailImageView,
            heartButton,
            bottomContainerView
        ].forEach { contentView.addSubview($0) }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.width.equalTo(contentView)
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.9)
        }
        
        heartButton.snp.makeConstraints {
            $0.trailing.equalTo(thumbnailImageView).inset(8.0)
            $0.bottom.equalTo(thumbnailImageView).inset(8.0)
            $0.width.height.equalTo(30.0)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.horizontalEdges.equalTo(thumbnailImageView).inset(8.0)
            $0.bottom.equalTo(contentView)
        }
        
        mallNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.horizontalEdges.equalToSuperview()
        }
                
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallNameLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview()
        }
                
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(8.0)
        }
    }
    
    private func configureUI() {
        thumbnailImageView.contentMode = .scaleToFill
        thumbnailImageView.layer.cornerRadius = 16
        thumbnailImageView.clipsToBounds = true
        
        mallNameLabel.textAlignment = .left
        mallNameLabel.textColor = .lightGray
        mallNameLabel.font = .systemFont(ofSize: 14.0)
        
        titleLabel.textColor = Colors.textColor
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16.0)
        titleLabel.numberOfLines = 2
        
        priceLabel.textAlignment = .left
        priceLabel.textColor = Colors.textColor
        priceLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.backgroundColor = .white
        heartButton.tintColor = .black
        DispatchQueue.main.async {
            self.heartButton.layer.cornerRadius = self.heartButton.frame.width / 2
        }
    }
    
    private func configureUserEvents() {
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
}
