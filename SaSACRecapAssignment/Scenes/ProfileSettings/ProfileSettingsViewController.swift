//
//  ProfileSettingsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit
import SnapKit

final class ProfileSettingsViewController: UIViewController {

    // MARK: - Properties
    let profileContainerView = UIView()
    let profileButton = UIButton()
    let cameraImageView = UIImageView()
    
    let nicknameTextField = UITextField()
    let nicknameTextFieldBufferView = UIView()
    lazy var nicknameTextFieldContainerStackView = UIStackView(arrangedSubviews: [nicknameTextFieldBufferView, nicknameTextField, nicknameTextFieldBufferView])
    
    let separatorView = UIView()
    
    let errorMessageLabel = UILabel()
    let errorMessageLabelBufferView = UIView()
    lazy var errorMessageLabelContainerStackView = UIStackView(arrangedSubviews: [errorMessageLabelBufferView, errorMessageLabel, errorMessageLabelBufferView])
    
    lazy var inputContainerStackView = UIStackView(arrangedSubviews: [nicknameTextFieldContainerStackView, separatorView, errorMessageLabelContainerStackView])
    
    let completitonButton = UIButton()

    private let profileButtonWidth: CGFloat = 90.0
    
    private let referenceProfileImageNameList: [String] = ProfileImages.allCases.map { $0.rawValue }
    private lazy var randomProfileImageName = referenceProfileImageNameList.randomElement()!
    
    var editMode: Bool = false
    var currentUserProfileImageName: String = ""
    var currentUserNickname: String = ""
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureConstraints()
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
            UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.selectedProfileImageName.rawValue)
            nicknameTextField.text = nil
        }
    }
    
    // MARK: - Custom Methods
    private func checkNicknameValidationAndShowErrorMessage(text: String) {
        do {
            try validateNickname(text: text)
            errorMessageLabel.text = "사용할 수 있는 닉네임이에요"
            errorMessageLabel.textColor = Colors.pointColor
        } catch {
            switch error {
            case NicknameValidationError.notInBetweenTwoAndTenLetters:
                print("2글자 이상 10글자 미만으로 설정해주세요")
                showErrorMessage(error: NicknameValidationError.notInBetweenTwoAndTenLetters)
            case NicknameValidationError.containUnallowedSpecialCharacters:
                print("닉네임에 @, #, $, %는 포함할 수 없어요")
                showErrorMessage(error: NicknameValidationError.containUnallowedSpecialCharacters)
            case NicknameValidationError.containNumbers:
                print("닉네임에 숫자는 포함할 수 없어요")
                showErrorMessage(error: NicknameValidationError.containNumbers)
            default:
                print("알 수 없는 오류입니다.")
            }
        }
    }
    
    private func showErrorMessage(error: NicknameValidationError) {
        errorMessageLabel.text = error.errorMessage
        errorMessageLabel.textColor = error.errorMessageTextColor
    }
    
    private func validateNickname(text: String) throws {
        guard text.count >= 2 && text.count < 10
        else {
            throw NicknameValidationError.notInBetweenTwoAndTenLetters
        }
        
        guard !text.contains("@") && !text.contains("#")
                    && !text.contains("$") && !text.contains("%")
        else {
            throw NicknameValidationError.containUnallowedSpecialCharacters
        }
        
        guard text.filter({ $0.isNumber }).count < 1
        else {
            throw NicknameValidationError.containNumbers
        }
    }
}

// MARK: - User Evernt Methods
extension ProfileSettingsViewController {
    
    @objc private func profileButtonTapped() {
        let profileSelectionVC = storyboard?.instantiateViewController(withIdentifier: ProfileSelectionViewController.identifier) as! ProfileSelectionViewController
        
        profileSelectionVC.selectedProfileName = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedProfileImageName.rawValue) ?? randomProfileImageName
        profileSelectionVC.referenceProfileNameList = referenceProfileImageNameList
        
        currentUserProfileImageName = ""
        
        navigationController?.pushViewController(profileSelectionVC, animated: true)
    }
    
    @objc private func completeProfileSetting() {
       
        checkNicknameValidationAndShowErrorMessage(text: nicknameTextField.text!)

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
                mainTabBarVC.tabBar.unselectedItemTintColor = .darkGray

                sceneDelegate?.window?.rootViewController = mainTabBarVC
                sceneDelegate?.window?.makeKeyAndVisible()
                
                // 초기화
                UserDefaults.standard.set([String: Any](), forKey: UserDefaultsKeys.heartPressedList.rawValue)
                UserDefaults.standard.set([String](), forKey: UserDefaultsKeys.recentKeywordList.rawValue)
            }
        }
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension ProfileSettingsViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureConstraints() {
        [
            profileButton,
            cameraImageView,
        ].forEach { profileContainerView.addSubview($0) }
        
        [
            profileContainerView,
            inputContainerStackView,
            completitonButton
        ].forEach { view.addSubview($0) }
        
        profileContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(140.0)
        }
        
        profileButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(profileButtonWidth)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.center.equalTo(profileButton.snp.center).offset(30.0)
            $0.size.equalTo(25.0)
        }
        
        inputContainerStackView.snp.makeConstraints {
            $0.top.equalTo(profileContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        nicknameTextFieldContainerStackView.snp.makeConstraints {
            $0.width.equalTo(inputContainerStackView.snp.width)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(18.0)
        }
        
        nicknameTextFieldBufferView.snp.makeConstraints {
            $0.height.equalTo(nicknameTextField.snp.height)
            $0.width.equalTo(8.0)
        }
        
        separatorView.snp.makeConstraints {
            $0.width.equalTo(inputContainerStackView.snp.width)
            $0.height.equalTo(1.0)
        }
        
        errorMessageLabelContainerStackView.snp.makeConstraints {
            $0.width.equalTo(inputContainerStackView.snp.width)
        }
        
        errorMessageLabelBufferView.snp.makeConstraints {
            $0.height.equalTo(errorMessageLabel.snp.height)
            $0.width.equalTo(8.0)
        }
        
        completitonButton.snp.makeConstraints {
            $0.top.equalTo(inputContainerStackView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(50.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        profileButton.layer.cornerRadius = profileButtonWidth / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderColor = Colors.pointColor.cgColor
        profileButton.layer.borderWidth = 5
        
        cameraImageView.image = UIImage(named: Images.camera)
        cameraImageView.contentMode = .scaleAspectFit
        
        inputContainerStackView.axis = .vertical
        inputContainerStackView.spacing = 12
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: nicknameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        nicknameTextField.font = .systemFont(ofSize: 16.0)
        nicknameTextField.textColor = Colors.textColor
        nicknameTextField.textAlignment = .left
        nicknameTextField.borderStyle = .none
        let nickname = editMode ? currentUserNickname : UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""
        nicknameTextField.text = nickname
        
        nicknameTextFieldContainerStackView.axis = .horizontal
        
        separatorView.backgroundColor = .white
        
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.textColor = Colors.textColor
        errorMessageLabel.numberOfLines = 2
        errorMessageLabel.font = .systemFont(ofSize: 14.0)
        
        errorMessageLabelContainerStackView.axis = .horizontal
        
        completitonButton.setTitle("완료", for: .normal)
        completitonButton.setTitleColor(Colors.textColor, for: .normal)
        completitonButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        completitonButton.layer.cornerRadius = 8
        completitonButton.backgroundColor = Colors.pointColor
    }
    
    func configureOthers() {
        nicknameTextField.delegate = self
    }
    
    func configureUserEvents() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        completitonButton.addTarget(self, action: #selector(completeProfileSetting), for: .touchUpInside)
    }
}

// MARK: - UITextField Delegate Methods
extension ProfileSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkNicknameValidationAndShowErrorMessage(text: textField.text!)
    }
}
