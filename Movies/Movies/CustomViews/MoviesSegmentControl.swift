//
//  MoviesSegmentControl.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//

import UIKit

class MoviesSegmentControl: UIView {
    private let stackView = UIStackView()
    private let selectedView = UIView()
    private let selectedTopView = UIView()
    private var selectedViewWidth: CGFloat = 0
    private var arrayButtons = [UIButton]()
    private var widthConstraint = NSLayoutConstraint()
    private var action: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ buttonsTitles: [String], selectedIndex: Int, action: ((Int) -> Void)? ) {
        self.init()
        
        self.action = action
        
        buttonsTitles.enumerated().forEach {
            let button: UIButton = .createSegmentButton($0.element)
            button.tag = $0.offset
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            arrayButtons.append(button)
        }
        
        DispatchQueue.main.async {
            let itemSize = (self.bounds.size.width - 10) / CGFloat(buttonsTitles.count)
            self.selectedViewWidth = itemSize > 0 ? itemSize : 0
            self.widthConstraint.constant = self.selectedViewWidth
            self.stackView.layoutIfNeeded()
            
            self.selectedTopView.gradientBackgroundHorizontal(leftColor: ColorConstans.leftColorSegment, rightColor: ColorConstans.rightColorSegment)
            self.selectedTopView.layer.cornerRadius = self.selectedView.frame.height/2
            self.selectedView.setShadowWithCornerRadius(cornerRadius: self.selectedView.frame.height/2, shadowColor: .darkGray, shadowOffset: .zero, shadowOpacity: 1, shadowRadius: 3)
            self.stackView.setBorderLayer(backgroundColor: .white, borderColor: ColorConstans.borderColorSegment, borderWidth: 1, cornerRadius: self.stackView.frame.height/2, tintColor: nil)
            
            self.selectedSegmentIndex(selectedIndex)
        }
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        action?(sender.tag)
        for (index, btn) in arrayButtons.enumerated() {
            
            btn.buttonIsActive(btn == sender)
            if btn == sender {
                let selectorStartPosition = selectedViewWidth * CGFloat(index)
                
                UIView.animate(withDuration: 0.3) {
                    self.selectedView.frame.origin.x = selectorStartPosition
                }
            }
        }
    }
    
    private func selectedSegmentIndex(_ index: Int) {
        let selectorStartPosition = selectedViewWidth * CGFloat(index)
        self.selectedView.frame.origin.x = selectorStartPosition
    }
}

private extension MoviesSegmentControl {
    
    func configure() {
        configureStackView()
        configureSelectedView()
        setConstraints()
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    func configureSelectedView() {
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(selectedView)
        selectedView.addSubview(selectedTopView)
        selectedTopView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        widthConstraint = selectedView.widthAnchor.constraint(equalToConstant: selectedViewWidth)
        widthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            selectedView.topAnchor.constraint(equalTo: stackView.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            selectedTopView.topAnchor.constraint(equalTo: selectedView.topAnchor),
            selectedTopView.bottomAnchor.constraint(equalTo: selectedView.bottomAnchor),
            selectedTopView.leadingAnchor.constraint(equalTo: selectedView.leadingAnchor),
            selectedTopView.trailingAnchor.constraint(equalTo: selectedView.trailingAnchor),
        ])
    }
}
