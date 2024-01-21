//
//  SettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var userProfileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    
    @IBOutlet weak var settingsTableView: UITableView!
            
    private let settingsList = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "처음부터 시작하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureUI()
        configureOthers()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentProfileImageName.rawValue) ?? "no_image"
        profileImageView.image = UIImage(named: profileImageName)
        
        nicknameLabel.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""

        guard let heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        
        heartCountLabel.text = "\(heartPressedList.count)개의 상품을 좋아하고 있어요!"
        
        let attributedString = NSMutableAttributedString(string: heartCountLabel.text ?? "")
        attributedString.addAttribute(.foregroundColor, value: Colors.pointColor, range: ((heartCountLabel.text ?? "") as NSString).range(of: "\(heartPressedList.count)개의 상품"))
        heartCountLabel.attributedText = attributedString
    }
    
    @IBAction func userProfileContainerViewTapped(_ sender: UITapGestureRecognizer) {
        let profileSettingsVC = storyboard?.instantiateViewController(withIdentifier: ProfileSettingsViewController.identifier) as! ProfileSettingsViewController
        
        profileSettingsVC.editMode = true
        profileSettingsVC.currentUserProfileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentProfileImageName.rawValue)!
        profileSettingsVC.currentUserNickname = nicknameLabel.text ?? ""
        
        navigationController?.pushViewController(profileSettingsVC, animated: true)
    }
}

extension SettingsViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
    }
    
    func configureUI() {
        userProfileContainerView.backgroundColor = Colors.settingsElementBackgroundColor
        userProfileContainerView.layer.cornerRadius = 8
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = Colors.pointColor.cgColor
        
        nicknameLabel.font = .systemFont(ofSize: 18.0, weight: .semibold)
        nicknameLabel.textColor = Colors.textColor
        nicknameLabel.textAlignment = .left
        
        heartCountLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        heartCountLabel.textAlignment = .left
        heartCountLabel.textColor = Colors.textColor
        
        settingsTableView.backgroundColor = .clear
    }
    
    func configureOthers() {
        settingsTableView.isScrollEnabled = false
    }
    
    func configureUserEvents() {
        
    }
    
    
}

extension SettingsViewController {
    
}

extension SettingsViewController: TableViewConfigrationProtocol {
    func configureTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")!
        
        cell.selectionStyle = .none
        cell.backgroundColor = Colors.settingsElementBackgroundColor
        cell.textLabel?.textColor = Colors.textColor

        if indexPath.row == 0  {
            cell.layer.cornerRadius = 8
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
        } else if indexPath.row == settingsList.count - 1 {
            cell.layer.cornerRadius = 8
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        }
        
        cell.textLabel?.text = settingsList[indexPath.row]
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == settingsList.count - 1 {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화 하시겠습니까?", preferredStyle: .alert)
            
            let confirmButton = UIAlertAction(title: "확인", style: .default) { _ in
                
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.userLoginState.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.currentProfileImageName.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.nickname.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.heartPressedList.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let onboardingVC = self.storyboard?.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
                let nav = UINavigationController(rootViewController: onboardingVC)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(confirmButton)
            alert.addAction(cancelButton)
            
            present(alert, animated: true)
        }
    }
}
