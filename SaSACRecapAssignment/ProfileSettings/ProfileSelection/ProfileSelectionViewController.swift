//
//  ProfileSelectionViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class ProfileSelectionViewController: UIViewController {
    
    @IBOutlet weak var selectedProfileImageView: UIImageView!
    @IBOutlet weak var profileListCollectionView: UICollectionView!
    
    var selectedProfileName: String = ""
    var referenceProfileNameList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureUI()
        configureCollectionView()
    }
    
}

extension ProfileSelectionViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureUI() {
        selectedProfileImageView.layer.cornerRadius = selectedProfileImageView.frame.width / 2
        selectedProfileImageView.layer.borderColor = Colors.pointColor.cgColor
        selectedProfileImageView.layer.borderWidth = 5
        selectedProfileImageView.image = UIImage(named: selectedProfileName)
        
        profileListCollectionView.backgroundColor = .clear
    }
    
    func configureOthers() {
        
    }
    
    func configureUserEvents() {
        
    }
}

extension ProfileSelectionViewController: CollectionViewConfigurationProtocol {
    func configureCollectionView() {
        profileListCollectionView.delegate = self
        profileListCollectionView.dataSource = self
        
        let profileListCollectionViewCellXib = UINib(nibName: ProfileListCollectionViewCell.identifier, bundle: nil)
        profileListCollectionView.register(profileListCollectionViewCellXib, forCellWithReuseIdentifier: ProfileListCollectionViewCell.identifier)
        
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 5)
        layout.itemSize = CGSize(width: itemSize / 4, height: (itemSize / 4))
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        profileListCollectionView.collectionViewLayout = layout
    }
}

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

extension ProfileSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProfileImageView.image = UIImage(named: referenceProfileNameList[indexPath.item])
        selectedProfileName = referenceProfileNameList[indexPath.item]
        UserDefaults.standard.set(selectedProfileName, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
        collectionView.reloadData()
    }
}
