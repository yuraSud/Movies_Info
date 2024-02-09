//
//  ButtonsStack.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class ConvenieceButton: ASDisplayNode {
    
    private let title = ASTextNode()
    private let image = ASImageNode()
    private let typeBtn: ButtonsConvenienе
    private let actionCompletion: ((ButtonsConvenienе) -> Void)?
    
    init(type: ButtonsConvenienе, actionCompletion: ((ButtonsConvenienе) -> Void)?) {
        self.typeBtn = type
        self.actionCompletion = actionCompletion
        super.init()
        setNode()
        self.automaticallyManagesSubnodes = true
        self.isUserInteractionEnabled = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .center, alignItems: .center, children: [self.image, self.title])

        stack.style.height = .init(unit: .points, value: 65)
        
        let ratioStack = ASRatioLayoutSpec(ratio: 0.85, child: stack)
     
        return ratioStack
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        actionCompletion?(typeBtn)
        title.isHidden = false
        image.isHidden = false
        self.borderWidth = 1
    }
    
    private func setNode() {
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black]
        
        title.attributedText = .init(string: typeBtn.title, attributes: mainAttributes)
        image.image = typeBtn.imageBtn
        
        self.borderColor = UIColor.lightGray.cgColor
        self.borderWidth = 1
        self.cornerRadius = 9
        self.style.flexGrow = 1
        self.style.flexShrink = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !touches.isEmpty {
            title.isHidden = true
            image.isHidden = true
            self.borderWidth = 0
        }
    }
}
