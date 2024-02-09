//
//  SocialCellNode.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import AsyncDisplayKit

class SocialCellNode: ASCellNode {
    
    private let model: SocialCellModel
    
    let title: ASTextNode
    
    init(model: SocialCellModel) {
        self.model = model
        title = ASTextNode()
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        setCell()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insetBottom = ASInsetLayoutSpec(insets: .init(top: 15, left: 16, bottom: 5, right: 16), child: self.title)
        
        return insetBottom
    }
    
    private func setCell() {
        let text = NSMutableAttributedString(string: model.text, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        title.attributedText = text
    }
}

