//
//  OnboardingViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    // MARK: - Properties
    let appLogoImageViewContainer = UIView()
    let appLogoImageView = UIImageView()

    let onboardingImageView = UIImageView()
    
    let startButton = UIButton()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureUserEvents()
    }
}

// MARK: - User Evernt Methods
extension OnboardingViewController {
    
    @objc private func startButtonTapped() {
        let profileSettginsVC = storyboard?.instantiateViewController(withIdentifier: ProfileSettingsViewController.identifier) as! ProfileSettingsViewController
        
        profileSettginsVC.editMode = false
        
        navigationController?.pushViewController(profileSettginsVC, animated: true)
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension OnboardingViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
    
    }
    
    func configureConstraints() {
        appLogoImageViewContainer.addSubview(appLogoImageView)
        
        [
            appLogoImageViewContainer,
            onboardingImageView,
            startButton
        ].forEach { view.addSubview($0) }
        
        appLogoImageViewContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(onboardingImageView.snp.top)
        }
        
        appLogoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.53)
            $0.height.equalTo(appLogoImageView.snp.width).multipliedBy(0.45)
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.9)
            $0.height.equalTo(onboardingImageView.snp.width)
        }
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            $0.height.equalTo(50.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        appLogoImageView.image = UIImage(named: Images.sesacShopping)
        appLogoImageView.contentMode = .scaleAspectFit
        
        onboardingImageView.image = UIImage(named: Images.onboarding)
        onboardingImageView.contentMode = .scaleAspectFit
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(Colors.textColor, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        startButton.layer.cornerRadius = 8
        startButton.backgroundColor = Colors.pointColor
    }
    
    func configureOthers() {
        
    }

    func configureUserEvents() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
}
