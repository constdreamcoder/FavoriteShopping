//
//  RecentKeywordListTableViewCell.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit
import SnapKit

final class RecentKeywordListTableViewCell: UITableViewCell {

    // MARK: - Properties
    let magnifyingGlassImageView = UIImageView()
    let keywordLabel = UILabel()
    let removeKeywordButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            magnifyingGlassImageView,
            keywordLabel,
            removeKeywordButton
        ].forEach { contentView.addSubview($0) }
        
        magnifyingGlassImageView.snp.makeConstraints {
            $0.width.height.equalTo(26.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(28.0)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(magnifyingGlassImageView.snp.trailing).offset(28.0)
        }
        
        removeKeywordButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(keywordLabel.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(8.0)
            $0.width.height.equalTo(30.0)
        }
    }
    
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        magnifyingGlassImageView.tintColor = .white
        magnifyingGlassImageView.image = UIImage(systemName: "magnifyingglass")
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        
        keywordLabel.textColor = Colors.textColor
        keywordLabel.textAlignment = .left
        keywordLabel.font = .systemFont(ofSize: 16.0)
        
        removeKeywordButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeKeywordButton.tintColor = .darkGray
    }
}
