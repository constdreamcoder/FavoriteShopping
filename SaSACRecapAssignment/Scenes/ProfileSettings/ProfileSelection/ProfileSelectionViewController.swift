//
//  ProfileSelectionViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit
import SnapKit

final class ProfileSelectionViewController: UIViewController {
    
    // MARK: - Properties
    let selectedProfileImageViewContainerView = UIView()
    let selectedProfileImageView = UIImageView()
    
    lazy var profileListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    let selectedProfileImageViewWidth: CGFloat = 160.0
    
    var selectedProfileName: String = ""
    var referenceProfileNameList: [String] = []
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureCollectionView()
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension ProfileSelectionViewController: UIViewControllerConfigurationProtocol {
    func configureNavigationBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureConstraints() {
        selectedProfileImageViewContainerView.addSubview(selectedProfileImageView)
        
        [
            selectedProfileImageViewContainerView,
            profileListCollectionView
        ].forEach { view.addSubview($0) }
        
        selectedProfileImageViewContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(240.0)
        }
        
        selectedProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(selectedProfileImageViewWidth)
            $0.center.equalToSuperview()
        }
        
        profileListCollectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(selectedProfileImageViewContainerView.snp.bottom)
        }
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor

        selectedProfileImageView.clipsToBounds = true
        selectedProfileImageView.layer.cornerRadius = selectedProfileImageViewWidth / 2
        selectedProfileImageView.layer.borderColor = Colors.pointColor.cgColor
        selectedProfileImageView.layer.borderWidth = 5
        selectedProfileImageView.image = UIImage(named: selectedProfileName)
        selectedProfileImageView.contentMode = .scaleAspectFit
        
        profileListCollectionView.backgroundColor = .clear
    }
    
    func configureOthers() {
        
    }
    
    func configureUserEvents() {
        
    }
}

// MARK: - UICollectionView UI And Settings Configuration Methods
extension ProfileSelectionViewController: UICollectionViewConfigurationProtocol {
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 5)
        layout.itemSize = CGSize(width: itemSize / 4, height: (itemSize / 4))
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    func configureCollectionView() {
        profileListCollectionView.delegate = self
        profileListCollectionView.dataSource = self
        
        profileListCollectionView.register(ProfileListCollectionViewCell.self, forCellWithReuseIdentifier: ProfileListCollectionViewCell.identifier)
    }
}

// MARK: - UIColletionView DataSource Methods
extension ProfileSelectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return referenceProfileNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileListCollectionViewCell.identifier, for: indexPath) as! ProfileListCollectionViewCell
        
        let profileName = referenceProfileNameList[indexPath.item]
        
        cell.referenceProfileImageView.image = UIImage(named: profileName)
        
        if profileName == selectedProfileName {
            cell.selected()
        } else {
            cell.deselected()
        }
        
        return cell
    }
}

// MARK: - UIColletionView Delegate Methods
extension ProfileSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProfileImageView.image = UIImage(named: referenceProfileNameList[indexPath.item])
        selectedProfileName = referenceProfileNameList[indexPath.item]
        UserDefaults.standard.set(selectedProfileName, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
        collectionView.reloadData()
    }
}
