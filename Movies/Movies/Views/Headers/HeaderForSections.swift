//
//  HeaderForSections.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import UIKit

class HeaderForSections: UIView {
    
    private var actionBtn: ((HeaderType) -> Void)?
    private var actionSegment: ((Int) -> Void)?
    private let headerData: HeaderData
    var selectedButton = 0 {
        didSet {
            changeSelectSegment()
            actionSegment?(selectedButton)
        }
    }
    
    lazy var headerTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 18)
        return $0
    }(UILabel())
    
    lazy var buttonSeeAll: UIButton = {
        $0.setTitle("See All", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    lazy var buttonsStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillProportionally
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    init(headerData: HeaderData, actionBtn: ( (HeaderType) -> Void)? = nil, actionSegment: ((Int) -> Void)? = nil) {
        self.headerData = headerData
        self.actionSegment = actionSegment
        self.actionBtn = actionBtn
        super.init(frame: .zero)
        backgroundColor = .white
        setHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setHeader() {
        headerTitle.text = headerData.title
        addSubview(headerTitle)
        configureStack()
        configureHeader()
    }
    
    private func configureHeader() {
        switch headerData.type {
        case .simple:
            configSimpleHeader()
        case .middle:
            configureMiddleHeader()
        case .full:
            configureFullHeader()
        }
    }
    
    func configSimpleHeader() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.actionBtn?(self.headerData.type)
        }
        
        buttonSeeAll.addAction(action, for: .touchUpInside)
        addSubview(buttonSeeAll)
        
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            headerTitle.trailingAnchor.constraint(equalTo: buttonSeeAll.leadingAnchor, constant: -10),
            buttonSeeAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSeeAll.widthAnchor.constraint(equalToConstant: 60),
            buttonSeeAll.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            buttonSeeAll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    func configureMiddleHeader() {
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.actionBtn?(self.headerData.type)
        }
        buttonSeeAll.addAction(action, for: .touchUpInside)
        addSubview(buttonSeeAll)
        addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            headerTitle.trailingAnchor.constraint(equalTo: buttonsStack.leadingAnchor, constant: -20),
            buttonsStack.topAnchor.constraint(equalTo: headerTitle.topAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 0),
            buttonsStack.trailingAnchor.constraint(lessThanOrEqualTo: buttonSeeAll.leadingAnchor),
            
            buttonSeeAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSeeAll.widthAnchor.constraint(equalToConstant: 60),
            buttonSeeAll.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            buttonSeeAll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    private func configureFullHeader() {
        addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            headerTitle.trailingAnchor.constraint(equalTo: buttonsStack.leadingAnchor, constant: -10),
            buttonsStack.topAnchor.constraint(equalTo: headerTitle.topAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 0),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    private func configureStack() {
        if headerData.type == .middle {
            let buttons = [
            ButtonSegmentModel(title: "Review", count: 0),
            ButtonSegmentModel(title: "Discussions", count: 1),
            ]
            buttons.enumerated().forEach { index, buttonData in
                let btn = ButtonForSegment(tag: index, title: buttonData.buttonTitle) { tag in
                    self.selectedButton = tag
                }
                if index == 0 {
                    btn.isSelected = true
                }
                buttonsStack.addArrangedSubview(btn)
            }
        } else if headerData.type == .full {
            let buttons = [
            ButtonSegmentModel(title: "Most Popular", count: -1),
            ButtonSegmentModel(title: "Videos", count: 15),
            ButtonSegmentModel(title: "Backdrops", count: 14)
            ]
            buttons.enumerated().forEach { index, buttonData in
                let btn = ButtonForSegment(tag: index, title: buttonData.buttonTitle) { tag in
                    self.selectedButton = tag
                }
                if index == 0 {
                    btn.isSelected = true
                }
                buttonsStack.addArrangedSubview(btn)
            }
        }
    }
    
    private func changeSelectSegment() {
        let buttons = buttonsStack.arrangedSubviews
        buttons.forEach { btn in
            guard let btn = btn as? ButtonForSegment else { return }
            btn.isSelected = btn.tagButton == selectedButton
        }
    }
}
