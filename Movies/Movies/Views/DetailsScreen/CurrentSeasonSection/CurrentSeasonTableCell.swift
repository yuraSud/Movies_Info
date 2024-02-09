//
//  TableSectionCell.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import SDWebImage
import AsyncDisplayKit
import UIKit

class CurrentSeasonTableCell: ASCellNode {
    
    let model: MovieCellModel
    
    private let bottomSeparator: ASDisplayNode
    private let image: ASImageNode
    private let title: ASTextNode
    private let moviesDescription: ASTextNode
    
    init(model: MovieCellModel) {
        self.model = model
        image = ASImageNode()
        title = ASTextNode()
        moviesDescription = ASTextNode()
        bottomSeparator = ASDisplayNode()
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        setCell()
        SDWebImageDownloader.shared.downloadImage(urlString: model.imageUrl ?? "") { self.image.image = $0 }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let img = ASRatioLayoutSpec(ratio: 0.5, child: image)
        
        let rightStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.title, self.moviesDescription])
        rightStack.style.flexShrink = 1
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [img, rightStack])
        
        let insetBottom = ASInsetLayoutSpec(insets: .init(top: 5, left: 10, bottom: 0, right: 10), child: self.bottomSeparator)
        
        let resultStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [mainStack, insetBottom])
        
        let mainInset = ASInsetLayoutSpec(insets: .init(top: 7, left: 16, bottom: 7, right: 16), child: resultStack)
        
        return mainInset
    }
    
    private func setCell() {
        image.contentMode = .scaleAspectFill
        image.style.width = .init(unit: .points, value: 32)
        image.style.height = .init(unit: .points, value: 48)
        image.cornerRadius = 5
        
        let textTitle = NSMutableAttributedString(string: model.title ?? "", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.attributedText = textTitle
        
        let text = NSMutableAttributedString(string: model.description ?? "", attributes: [.font: UIFont.systemFont(ofSize: 14)])
        moviesDescription.attributedText = text
        moviesDescription.maximumNumberOfLines = 1
        
        bottomSeparator.backgroundColor = .lightGray
        bottomSeparator.style.height = .init(unit: .points, value: 1)
        bottomSeparator.style.width = .init(unit: .fraction, value: 1)
    }
}

