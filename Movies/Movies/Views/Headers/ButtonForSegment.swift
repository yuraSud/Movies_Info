//
//  ButtonForSegment.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import UIKit

class ButtonForSegment: UIView {
    
    private let titleLabel = UILabel()
    private let bottomLine = UIView()
    var isSelected = false {
        didSet {
            changeStateButton()
        }
    }
    var tapAction: ((Int) -> Void)?
    let tagButton: Int
    
    init(tag: Int, title: String, action: ((Int) -> Void)? = nil ) {
        self.tagButton = tag
        self.tapAction = action
        super.init(frame: .zero)
        configureButton()
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        tapAction?(tagButton)
        isSelected = true
    }
    
    private func changeStateButton() {
        bottomLine.isHidden = !isSelected
    }
    
    private func configureButton() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = UIColor(named: "BottomLine")
        bottomLine.layer.shadowColor = UIColor.gray.cgColor
        bottomLine.layer.shadowOffset = .zero
        bottomLine.layer.shadowRadius = 3
        bottomLine.isHidden = true
        addSubview(titleLabel)
        addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: 5),
            bottomLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 3),
            bottomLine.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -3),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            bottomLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
}


struct ButtonSegmentModel {
    let title: String
    let count: Int
    let isSelect: Bool = false
    
    var buttonTitle: String {
        if count < 0 {
            return title
        } else {
            return "\(title)(\(count))"
        }
    }
}

