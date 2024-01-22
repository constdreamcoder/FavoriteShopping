//
//  SearchViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var removeAllButton: UIButton!
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noKeywordsMessageLabel: UILabel!
    @IBOutlet weak var recentKeywordListTableView: UITableView!
    
    private let nickname = UserDefaults.standard.string(forKey: UserDefaultsKeys.nickname.rawValue) ?? ""
    
    private var recentKeywordList: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.recentKeywordList.rawValue) as? [String] ?? []
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureUserEvents()
        configureOthers()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        
        recentKeywordListTableView.reloadData()
        
        showOrHideTableHeaderViewAndRecentKeywordListTableView()
    }
    
    // MARK: - Custom Methods
    private func showOrHideTableHeaderViewAndRecentKeywordListTableView() {
        if recentKeywordList.isEmpty {
            tableViewHeaderView.isHidden = true
            recentKeywordListTableView.isHidden = true
        } else {
            tableViewHeaderView.isHidden = false
            recentKeywordListTableView.isHidden = false
        }
    }
}

// MARK: - User Evernt Methods
extension SearchViewController {
    
    @objc func removeAllButtonTapped() {
        recentKeywordList.removeAll()
        UserDefaults.standard.set([], forKey: UserDefaultsKeys.recentKeywordList.rawValue)
        recentKeywordListTableView.reloadData()
        tableViewHeaderView.isHidden = true
        recentKeywordListTableView.isHidden = true
    }
    
    @objc func removeKeywordButtonTapped(_ sender: UIButton) {
        recentKeywordList.remove(at: sender.tag)
        UserDefaults.standard.set(recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
        showOrHideTableHeaderViewAndRecentKeywordListTableView()
        recentKeywordListTableView.reloadData()
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension SearchViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = "\(nickname)님의 새싹쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        recentSearchLabel.textColor = Colors.textColor
        
        removeAllButton.setTitle("모두 지우기", for: .normal)
        removeAllButton.setTitleColor(Colors.pointColor, for: .normal)
        removeAllButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        
        emptyImageView.image = UIImage(named: Images.empty)
        emptyImageView.contentMode = .scaleAspectFit
        
        noKeywordsMessageLabel.text = "최근 검색어가 없어요"
        noKeywordsMessageLabel.textAlignment = .center
        noKeywordsMessageLabel.textColor = Colors.textColor
        noKeywordsMessageLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        recentKeywordListTableView.backgroundColor = Colors.backgroundColor
    }
    
    func configureOthers() {
        searchBar.delegate = self
    }
    
    func configureUserEvents() {
        removeAllButton.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
    }
}

// MARK: - UICollectionView UI And Settings Configuration Methods
extension SearchViewController: TableViewConfigrationProtocol {
    
    func configureTableView() {
        recentKeywordListTableView.delegate = self
        recentKeywordListTableView.dataSource = self
        
        let recentKeywordListTableViewCellXib = UINib(nibName: RecentKeywordListTableViewCell.identifier, bundle: nil)
        recentKeywordListTableView.register(recentKeywordListTableViewCellXib, forCellReuseIdentifier: RecentKeywordListTableViewCell.identifier)
        
        recentKeywordListTableView.rowHeight = 60
        recentKeywordListTableView.separatorStyle = .none
    }
}


// MARK: - UISearchBar Delegate Methods
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            ShoppingManager.shared.fetchShoppingResults(keyword: searchBar.text!) { searchResults in
                let searchResultsVC = self.storyboard?.instantiateViewController(withIdentifier: SearchResultsViewController.identifier) as! SearchResultsViewController
                
                searchResultsVC.keyword = searchBar.text!
                searchResultsVC.searchResultList = searchResults.items
                searchResultsVC.totalNumberSearched = searchResults.total
                
                self.recentKeywordList.insert(searchBar.text!, at: 0)
                UserDefaults.standard.set(self.recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
                
                self.navigationController?.pushViewController(searchResultsVC, animated: true)
            }
        }
    }
}

// MARK: - UITableView Delegate Methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentKeyword = recentKeywordList[indexPath.row]
        searchBar.text = recentKeyword
        ShoppingManager.shared.fetchShoppingResults(keyword: recentKeyword) { searchResults in
            
            let searchResultsVC = self.storyboard?.instantiateViewController(withIdentifier: SearchResultsViewController.identifier) as! SearchResultsViewController
            
            searchResultsVC.keyword = recentKeyword
            searchResultsVC.searchResultList = searchResults.items
            searchResultsVC.totalNumberSearched = searchResults.total
            
            self.recentKeywordList.insert(recentKeyword, at: 0)
            UserDefaults.standard.set(self.recentKeywordList, forKey: UserDefaultsKeys.recentKeywordList.rawValue)
            
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
        }
    }
}

// MARK: - UITableView DataSource Methods
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordListTableViewCell.identifier, for: indexPath) as! RecentKeywordListTableViewCell
        
        let recentKeyword = recentKeywordList[indexPath.row]
        cell.keywordLabel.text = recentKeyword
        
        cell.removeKeywordButton.tag = indexPath.row
        
        cell.removeKeywordButton.addTarget(self, action: #selector(removeKeywordButtonTapped), for: .touchUpInside)
        
        return cell
    }
}
