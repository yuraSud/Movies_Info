//
//  UIButton+SegmentButton.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//

import UIKit

extension UIButton {
    
    static func createSegmentButton(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: FontConstants.openSansRegular, size: 13)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    func buttonIsActive(_ isSelected: Bool) {
        var font = UIFont()
        if isSelected {
            font = UIFont(name: FontConstants.openSansSemiBold, size: 13) ?? .boldSystemFont(ofSize: 13)
        } else {
            font = UIFont(name: FontConstants.openSansRegular, size: 13) ?? .systemFont(ofSize: 13)
        }
        self.titleLabel?.font = font
    }
}
