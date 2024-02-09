//
//  GenreMovie.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class GenreMovie: ASDisplayNode {
    
    private var labels: [ASButtonNode] = []
    private let headerData: MainSectionModel
    private let descriptionLabel = ASTextNode()
    
    init(_ headerData: MainSectionModel) {
        self.headerData = headerData
        
        super.init()
        
        setLabels()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .stretch, children: labels)
      
        stack.style.width = .init(unit: .fraction, value: 1)
        
        let description = ASInsetLayoutSpec(insets: .zero, child: descriptionLabel)
        
        let result = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .start, children: [stack, description])
        
        let genreInset = ASInsetLayoutSpec(insets: .init(top: 0, left: 16, bottom: 0, right: 16), child: result)
       
        return genreInset
    }
    
    private func setLabels() {
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.gray]
        if let genre = headerData.genteType {
            genre.forEach { label in
                let labelGenre = ASButtonNode()
                labelGenre.setTitle(label, with: .systemFont(ofSize: 15), with: .gray, for: .normal)
                labelGenre.style.height = .init(unit: .points, value: 32)
                labelGenre.borderColor = UIColor.gray.cgColor
                labelGenre.borderWidth = 1
                labelGenre.cornerRadius = 7
                labelGenre.style.flexGrow = 1
                labelGenre.style.flexShrink = 1
                labels.append(labelGenre)
            }
        }
        
        if let description = headerData.descriptionHeader {
            descriptionLabel.attributedText = .init(string: description, attributes: mainAttributes)
        }
    }
}
