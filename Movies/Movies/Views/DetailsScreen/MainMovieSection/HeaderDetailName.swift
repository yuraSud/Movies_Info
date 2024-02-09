//
//  HeaderDetailName.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class HeaderDetailName: ASDisplayNode {
    
    private let headerData: MainSectionModel
    private let titleName = ASTextNode()
    private let durationTitle = ASTextNode()
    private let channelTitle = ASTextNode()
    private let percentTitle = ASTextNode()
    private let circle = ASDisplayNode()
    
    init(headerData: MainSectionModel) {
        self.headerData = headerData
        super.init()
        self.automaticallyManagesSubnodes = true
        setTitles()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let progressStack = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .start, alignItems: .start, children: [circle, percentTitle])
        
        let channelNameWithProgressStack = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .start, alignItems: .center, children: [channelTitle, progressStack])
        
        let bottomStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [channelNameWithProgressStack, durationTitle])
        
        let resultStack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .spaceBetween, alignItems: .stretch, children: [titleName, bottomStack])
        
        let headerInset = ASInsetLayoutSpec(insets: .init(top: 10, left: 16, bottom: 8, right: 16), child: resultStack)
        
        return headerInset
    }
    
    private func setTitles() {
        let attributesBold: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black]
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.gray]
        let titleText = NSMutableAttributedString(string: headerData.titleName ?? "Unknow", attributes: attributesBold)
        let yearMovie: NSAttributedString = .init(string: " (\(headerData.yearMovie ?? "(nil)"))", attributes: mainAttributes)
        
        titleText.append(yearMovie)
        
        titleName.attributedText = titleText
        
        channelTitle.attributedText = .init(string: headerData.channelTitle ?? "Movies", attributes: mainAttributes)
        percentTitle.attributedText = .init(string: headerData.percentTitle ?? "%0" , attributes: mainAttributes)
        durationTitle.attributedText = .init(string: headerData.durationTitle, attributes: mainAttributes)
        
        circle.frame.size = .init(width: 15, height: 15)
        circle.circleStrokeNode(headerData.percent ?? 0)
    }
}
