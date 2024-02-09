//
//  SearchCell.swift
//  Movies
//
//  Created by Olga Sabadina on 23.01.2024.
//

import SDWebImage
import AsyncDisplayKit
import UIKit

class SearchCell: ASCellNode {
    
    let model: MovieCellModel
    private var typeCell: TypeSearchCell
    
    private let bottomSeparator: ASDisplayNode
    private let searchImage: ASImageNode
    private let searchTitle: ASTextNode
    private let searchDescription: ASTextNode
    
    init(search: MovieCellModel, type: TypeSearchCell) {
        self.model = search
        searchImage = ASImageNode()
        searchTitle = ASTextNode()
        searchDescription = ASTextNode()
        bottomSeparator = ASDisplayNode()
        self.typeCell = type
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        setCell()
        var urlPoster: String? = ""
        switch typeCell {
        case .full:
            urlPoster = model.imageFullHDUrl
        case .medium:
            urlPoster = model.imageUrl
        case .short:
            urlPoster = model.imageUrl
        }
        guard let imageMovie = urlPoster else {
            self.searchImage.backgroundColor = .gray
            return}
        
        SDWebImageDownloader.shared.downloadImage(urlString: imageMovie) { self.searchImage.image = $0 }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let searchImg = ASRatioLayoutSpec(ratio: 0.5, child: searchImage)
        
        var rightStack = ASLayoutSpec()
        
        switch typeCell {
        case .full:
            rightStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.searchTitle, self.searchDescription])
            rightStack.style.flexShrink = 1
            
        case .medium:
            let insetBottom = ASInsetLayoutSpec(insets: .init(top: 0, left: 5, bottom: 0, right: 15), child: self.bottomSeparator)
            rightStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.searchTitle, self.searchDescription, insetBottom])
            rightStack.style.flexShrink = 1
            rightStack.style.flexGrow = 1
            
        case .short:
            let insetBottom = ASInsetLayoutSpec(insets: .init(top: 0, left: 5, bottom: 0, right: 15), child: self.bottomSeparator)
            rightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .center, alignItems: .start, children: [self.searchTitle, insetBottom])
            rightStack.style.flexGrow = 1
        }
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .end, children: [searchImg, rightStack])
        
        let mainInset = ASInsetLayoutSpec(insets: .init(top: 7, left: 7, bottom: 7, right: 7), child: mainStack)
        
        return mainInset
    }
    
    private func setCell() {
        searchImage.contentMode = .scaleAspectFill
        searchImage.style.width = .init(unit: .points, value: typeCell.widthImage)
        searchImage.style.height = .init(unit: .points, value: typeCell.heightImage)
        searchImage.cornerRadius = typeCell.cornerRadius
        
        let attributesBold: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black]
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray]
        
        let textTitle = NSMutableAttributedString(string: model.title ?? "", attributes: attributesBold)
        
        let yearMovie: NSAttributedString = .init(string: " | \(model.releaseData?.prefix(4) ?? "n/d")", attributes: mainAttributes)
        
        var text = NSMutableAttributedString()
        
        if typeCell == .medium {
            textTitle.append(yearMovie)
            text = NSMutableAttributedString(string: "as \(model.asHeroInFilm ?? "n/d")", attributes: mainAttributes)
            searchDescription.maximumNumberOfLines = 1
            
        } else if typeCell == .full {
            text = NSMutableAttributedString(string: model.description ?? "", attributes: mainAttributes)
            searchDescription.maximumNumberOfLines = 4
        }
        
        searchTitle.attributedText = textTitle
        searchDescription.attributedText = text
                
        bottomSeparator.backgroundColor = .lightGray
        bottomSeparator.style.height = .init(unit: .points, value: 1)
        bottomSeparator.style.width = .init(unit: .fraction, value: 1)
    }
}

enum TypeSearchCell {
    case full, medium, short
    
    var heightImage: CGFloat {
        switch self {
        case .full:
            return 78
        case .medium, .short:
            return 48
        }
    }
    
    var widthImage: CGFloat {
        switch self {
        case .full:
            return 126
        case .medium, .short:
            return 32
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .full:
            return 15
        case .medium, .short:
            return 5
        }
    }
    
    var font: UIFont {
        switch self {
        case .full:
            return UIFont(name: FontConstants.openSansSemiBold, size: 24) ?? .boldSystemFont(ofSize: 24)
        case .medium, .short:
            return UIFont(name: FontConstants.openSansSemiBold, size: 18) ?? .boldSystemFont(ofSize: 18)
        }
    }
}

