//
//  SearchDetailViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit
import WebKit
import SnapKit

class SearchDetailViewController: UIViewController {
    
    // MARK: - Properties
    let webView = WKWebView()
    
    var productTitle: String = ""
    var productId: String = ""

    // MARK: - Life Cycl Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        configureOthers()
    }
}

// MARK: - User Events Methods
extension SearchDetailViewController {
    @objc func rightBarButtonItemTapped() {
        guard var heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        let isHeartPressed = heartPressedList[productId] as? Bool ?? false
        
        heartPressedList[productId] = !isHeartPressed
        UserDefaults.standard.set(heartPressedList, forKey: UserDefaultsKeys.heartPressedList.rawValue)
        
        var systemImageName: String = ""
        if !isHeartPressed {
            systemImageName = "heart.fill"
        } else {
            systemImageName = "heart"
        }
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension SearchDetailViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = productTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        
        guard let heartPressedList = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.heartPressedList.rawValue) else { return }
        let isHeartPressed = heartPressedList[productId] as? Bool ?? false
        
        var systemImageName: String = ""
        if isHeartPressed {
            systemImageName = "heart.fill"
        } else {
            systemImageName = "heart"
        }
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func configureConstraints() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
    }
    
    func configureOthers() {
        let urlString = "https://msearch.shopping.naver.com/product/\(productId)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func configureUserEvents() {
        
    }
}
