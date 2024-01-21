//
//  ProfileSettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

class ProfileSettingsViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    @IBOutlet weak var completitonButton: UIButton!
    
    private let referenceProfileImageNameList: [String] = ProfileImages.allCases.map { $0.rawValue }
    
    private lazy var randomProfileImageName = referenceProfileImageNameList.randomElement()!
    
    var editMode: Bool = false
    var currentUserProfileImageName: String = ""
    var currentUserNickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureOthers()
        configureUserEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    
        if editMode && currentUserProfileImageName != "" {
            UserDefaults.standard.set(currentUserProfileImageName, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
        }
        
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
        profileButton.setImage(UIImage(named: profileImageName), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            if !editMode {
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.currentProfileImageName.rawValue)
                UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.nickname.rawValue)
            }
        }
    }

}

// MARK: - User Evernt Methods
extension ProfileSettingsViewController {
    @objc func profileButtonTapped() {
        let profileSelectionVC = storyboard?.instantiateViewController(withIdentifier: ProfileSelectionViewController.identifier) as! ProfileSelectionViewController
        
        profileSelectionVC.selectedProfileName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
        profileSelectionVC.referenceProfileNameList = referenceProfileImageNameList
        
        currentUserProfileImageName = ""
        
        navigationController?.pushViewController(profileSelectionVC, animated: true)
    }
    
    @objc func completeProfileSetting() {
       
        checkNicknameLimitation(text: nicknameTextField.text!)

        if errorMessageLabel.textColor == Colors.pointColor {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.userLoginState.rawValue)

            UserDefaults.standard.set(nicknameTextField.text!, forKey: UserDefaultsKeys.nickname.rawValue)
            
            let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
            UserDefaults.standard.set(profileImageName, forKey: UserDefaultsKeys.currentProfileImageName.rawValue)
            
            if editMode {
                navigationController?.popViewController(animated: true)
            } else {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let mainTabBarVC = storyboard?.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
                mainTabBarVC.tabBar.tintColor = Colors.pointColor

                sceneDelegate?.window?.rootViewController = mainTabBarVC
                sceneDelegate?.window?.makeKeyAndVisible()
                
                // 초기화
                UserDefaults.standard.set([String: Any](), forKey: UserDefaultsKeys.heartPressedList.rawValue)
                UserDefaults.standard.set([String](), forKey: UserDefaultsKeys.recentKeywordList.rawValue)
            }
        }
    }
}

// MARK: - UI Methods
extension ProfileSettingsViewController: UIViewControllerConfigurationProtocol {
   
    func configureNavigationBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureUI() {
        profileButton.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderColor = Colors.pointColor.cgColor
        profileButton.layer.borderWidth = 5
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: nicknameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        let nickname = editMode ? currentUserNickname : UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""
        nicknameTextField.text = nickname
        
        completitonButton.layer.cornerRadius = 8
    }
    
    func configureOthers() {
        nicknameTextField.delegate = self
    }
    
    func configureUserEvents() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        completitonButton.addTarget(self, action: #selector(completeProfileSetting), for: .touchUpInside)
    }
}

extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkNicknameLimitation(text: textField.text!)
    }
    
    private func checkNicknameLimitation(text: String) {
        if text.count < 2 || text.count >= 10 {
            errorMessageLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            errorMessageLabel.textColor = .red
        } else if text.contains("@") || text.contains("#")
                    || text.contains("$") || text.contains("%") {
            errorMessageLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            errorMessageLabel.textColor = .red
        } else if text.filter({ $0.isNumber }).count >= 1 {
            errorMessageLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            errorMessageLabel.textColor = .red
        } else {
            errorMessageLabel.text = "사용할 수 있는 닉네임이에요"
            errorMessageLabel.textColor = Colors.pointColor
        }
    }
}
