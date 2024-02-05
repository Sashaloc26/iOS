//
//  HomeViewController.swift
//  Kitchen Helper
//
//  Created by Саша Тихонов on 29/01/2024.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {
    
    let gradientLayer = CAGradientLayer()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let layout = UICollectionViewFlowLayout()
    var categoryCollectionView: UICollectionView!
    
    var categoryContents: [CategoryContent] = []
    
    let mainNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Chef's Assistant"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
//    let searchButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//        button.tintColor = .white
//        return button
//    }()
    
      let searchButton = SearchButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        makeConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: "CategoriesCollectionCell")
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 250/255, green: 173/255, blue: 91/255, alpha: 1.0).cgColor,
                                UIColor(red: 247/255, green: 65/255, blue: 114/255, alpha: 1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0.6)
        
        whiteView.layer.cornerRadius = 100
        whiteView.layer.maskedCorners = [.layerMinXMinYCorner]
        
        categoryContents = CategoryContent.allCategoryContents()
        
        view.layer.addSublayer(gradientLayer)
        view.addSubview(whiteView)
        view.addSubview(categoryCollectionView)
        view.addSubview(mainNameLabel)
        view.addSubview(searchButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        whiteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(-100)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(view.bounds.height * 0.6)
        }
        
        mainNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as? CategoriesCollectionCell else {
            fatalError("Unable to dequeue CategoriesCollectionCell")
        }
        let content = categoryContents[indexPath.item]
        
        cell.configure(title: content.categoryText, image: content.categoryImage)
        
        let shadowPathRect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)

        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.shadowPath = UIBezierPath(rect: shadowPathRect).cgPath
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 2.0
        cell.layer.masksToBounds = false
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 40
        let cellCount: CGFloat = 6
        let cellSpacing: CGFloat = categoryCollectionView.bounds.width * 0.04
        let collectionViewWidth = categoryCollectionView.bounds.width

        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)

        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 10, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 40
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        categoryCollectionView.superview?.setNeedsLayout()
        categoryCollectionView.superview?.layoutIfNeeded()
        
        return CGSize(width: categoryCollectionView.bounds.width * 0.38, height: categoryCollectionView.bounds.height * 0.25)
    }
}

