//
//  HeaderInTable.swift
//  Movies
//
//  Created by Olga Sabadina on 23.01.2024.
//

import UIKit

class HeaderInTable: UIView {
    
    private var typeCell: TypeSearchCell
    private let headerTitle = UILabel()
    
    init(title: String, type: TypeSearchCell = .short) {
        self.typeCell = type
        super.init(frame: .zero)
        backgroundColor = .white
        setHeaderTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setHeaderTitle(_ title: String) {
        headerTitle.text = title
        headerTitle.frame = .init(x: 5, y: 2, width: 200, height: 45)
        headerTitle.font = typeCell.font
        addSubview(headerTitle)
    }
}
