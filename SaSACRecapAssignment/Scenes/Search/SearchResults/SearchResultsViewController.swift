//
//  SearchResultsViewController.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    
    let resultCountLabel = UILabel()
    
    let buttonContainerView = UIView()
    lazy var buttonContainerStackView = UIStackView(arrangedSubviews: [byAccuracyButton, byDateButton, byHighestPriceButton, byLowestPriceButton])
    
    let byAccuracyButton = UIButton()
    let byDateButton = UIButton()
    let byHighestPriceButton = UIButton()
    let byLowestPriceButton = UIButton()
    
    lazy var resultListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    var keyword: String = ""
    var totalNumberSearched: Int = 0
    var searchResultList: [Item] = []

    private var sortingStandard: SortingStandard = .byAccuracy
    private let display = 30
    private var start: Int = 1
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraints()
        configureUI()
        configureUserEvents()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
        resultListCollectionView.reloadData()
    }
    
    // MARK: - Custom Methods
    private func designBasicSortingButton(_ sortingButton: UIButton, title: String) {
        sortingButton.setTitle(title, for: .normal)
        sortingButton.titleLabel?.font = .systemFont(ofSize: 15.0)
        sortingButton.contentEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    private func configureSelectedSortingButton(_ sortingButton: UIButton) {
        sortingButton.layer.cornerRadius = 8
        sortingButton.layer.borderColor = UIColor.white.cgColor
        sortingButton.layer.borderWidth = 1
        sortingButton.setTitleColor(.black, for: .normal)
        sortingButton.backgroundColor = .white
    }
    
    private func configureDeselectedSortingButton(_ sortingButton: UIButton) {
        sortingButton.layer.cornerRadius = 8
        sortingButton.layer.borderColor = UIColor.white.cgColor
        sortingButton.layer.borderWidth = 1
        sortingButton.setTitleColor(Colors.textColor, for: .normal)
        sortingButton.backgroundColor = Colors.backgroundColor
    }
    
    private func getShoppingResultsBySortingStandard(sortingStandard: SortingStandard) {
        self.sortingStandard = sortingStandard
        
        ShoppingManager.shared.fetchShoppingResults(
            keyword: keyword,
            sortingStandard: sortingStandard
        ) { searchResults in
            self.start = 1
            self.searchResultList = searchResults.items
            self.resultListCollectionView.reloadData()
            
            self.resultListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - User Evernt Methods
extension SearchResultsViewController {
    
    @objc func sortProducts(_ sender: UIButton) {
        print("\(sender.title(for: .normal)!)")
    
        [
            byAccuracyButton,
            byDateButton,
            byHighestPriceButton,
            byLowestPriceButton
        ].forEach { sortingButton in
            if sortingButton == sender {
                configureSelectedSortingButton(sortingButton)
            } else {
                configureDeselectedSortingButton(sortingButton)
            }
        }
        
        if sender == byAccuracyButton {
            getShoppingResultsBySortingStandard(sortingStandard: .byAccuracy)
        } else if sender == byDateButton {
            getShoppingResultsBySortingStandard(sortingStandard: .byDate)
        } else if sender == byHighestPriceButton {
            getShoppingResultsBySortingStandard(sortingStandard: .byHighestPrice)
        } else if sender == byLowestPriceButton {
            getShoppingResultsBySortingStandard(sortingStandard: .byLowestPrice)
        }
    }
}

// MARK: - UIViewController UI And Settings Configuration Methods
extension SearchResultsViewController: UIViewControllerConfigurationProtocol {
    
    func configureNavigationBar() {
        navigationItem.title = keyword
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.textColor]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureConstraints() {
        buttonContainerView.addSubview(buttonContainerStackView)
        
        [
            resultCountLabel,
            buttonContainerView,
            resultListCollectionView
        ].forEach { view.addSubview($0) }
        
        resultCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12.0)
        }
        
        buttonContainerView.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom)
            $0.horizontalEdges.equalTo(resultCountLabel)
            $0.height.equalTo(46.0)
        }
        
        buttonContainerStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview()
        }
        
        resultListCollectionView.snp.makeConstraints {
            $0.top.equalTo(buttonContainerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = Colors.backgroundColor
        
        resultCountLabel.text = "\(totalNumberSearched.putCommaEveryThreeDigits) 개의 검색 결과"
        resultCountLabel.textColor = Colors.pointColor
        resultCountLabel.textAlignment = .left
        resultCountLabel.font = .systemFont(ofSize: 16.0, weight: .bold)

        buttonContainerView.backgroundColor = .clear
        
        buttonContainerStackView.backgroundColor = .clear
        buttonContainerStackView.axis = .horizontal
        buttonContainerStackView.spacing = 8.0
        buttonContainerStackView.distribution = .equalSpacing
        
        designBasicSortingButton(byAccuracyButton, title: "정확도")
        configureSelectedSortingButton(byAccuracyButton)
        
        designBasicSortingButton(byDateButton, title: "날짜순")
        configureDeselectedSortingButton(byDateButton)
      
        designBasicSortingButton(byHighestPriceButton, title: "가격높은순")
        configureDeselectedSortingButton(byHighestPriceButton)
        
        designBasicSortingButton(byLowestPriceButton, title: "가격낮은순")
        configureDeselectedSortingButton(byLowestPriceButton)
        
        resultListCollectionView.backgroundColor = .clear
    }
    
    func configureOthers() {
        
    }
    
    func configureUserEvents() {
        byAccuracyButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byDateButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byHighestPriceButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
        byLowestPriceButton.addTarget(self, action: #selector(sortProducts), for: .touchUpInside)
    }
}

// MARK: - UICollectionView UI And Settings Configuration Methods
extension SearchResultsViewController: UICollectionViewConfigurationProtocol {
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: itemSize / 2, height: (itemSize / 2) * 1.6)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    func configureCollectionView() {
        resultListCollectionView.delegate = self
        resultListCollectionView.dataSource = self
        
        resultListCollectionView.prefetchDataSource = self

        resultListCollectionView.register(ResultListCollectionViewCell.self, forCellWithReuseIdentifier: ResultListCollectionViewCell.identifier)
        
        resultListCollectionView.collectionViewLayout = configureCollectionViewLayout()
    }
}

// MARK: - UICollectionView Delegate Methods
extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchDetailVC = storyboard?.instantiateViewController(withIdentifier: SearchDetailViewController.identifier) as! SearchDetailViewController
        
        searchDetailVC.productTitle = searchResultList[indexPath.item].title
        searchDetailVC.productId = searchResultList[indexPath.item].productId
        
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}

// MARK: - UICollectionView DataSource Methods
extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultListCollectionViewCell.identifier, for: indexPath) as! ResultListCollectionViewCell
        
        let result = searchResultList[indexPath.item]
        
        let url = URL(string: result.image)
        let placeholderImage = UIImage(named: Images.noImage)
        cell.thumbnailImageView.kf.setImage(with: url, placeholder: placeholderImage)
        cell.mallNameLabel.text = result.mallName
        cell.titleLabel.text = result.title
        cell.priceLabel.text = Int(result.lprice)?.putCommaEveryThreeDigits
        
        cell.productId = result.productId
        
        cell.updateHeartButtonImage()
        
        return cell
    }
}

// MARK: - UICollectionView DataSource Prefetching Methods
extension SearchResultsViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Preftech \(indexPaths)")
        for item in indexPaths {
            if start <= 1000 && totalNumberSearched > display + start && searchResultList.count - 4 == item.item {
                start += display
                ShoppingManager.shared.fetchShoppingResults(
                    keyword: self.keyword,
                    sortingStandard: self.sortingStandard,
                    start: self.start,
                    display: totalNumberSearched < display + start ? totalNumberSearched % display : display
                ) { searchResults in
                    self.searchResultList.append(contentsOf: searchResults.items)
                    self.resultListCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("Cancel Prefetch \(indexPaths)")
    }
}
