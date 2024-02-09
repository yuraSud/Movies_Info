//
//  CategoriesCell.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    static var identCell = "categoriesCell"

    let categoriesButton = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setCategoriesButton()
        setConstraint()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoriesButton.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCategoriesButton() {
        categoriesButton.font = UIFont(name: FontConstants.openSansSemiBold, size: 14)
        categoriesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoriesButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            categoriesButton.topAnchor.constraint(equalTo: self.topAnchor),
            categoriesButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            categoriesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoriesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
