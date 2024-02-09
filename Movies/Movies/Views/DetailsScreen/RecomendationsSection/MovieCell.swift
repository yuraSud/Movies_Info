//
//  MovieCell.swift
//  Movies
//
//  Created by Olga Sabadina on 30.01.2024.
//

import SDWebImage
import AsyncDisplayKit

class MovieCell: ASCellNode {
    
    let model: MovieCellModel
    private let moviePhoto: ASImageNode
    private let movieName: ASTextNode
    private let percentTitle: ASTextNode
    private let circle: ASDisplayNode
    private let isRecomendation: Bool
    
    init(model: MovieCellModel, isRecomendation: Bool = true ) {
        self.model = model
        self.isRecomendation = isRecomendation
        moviePhoto = ASImageNode()
        movieName = ASTextNode()
        percentTitle = ASTextNode()
        circle = ASDisplayNode()
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        setCell()
        SDWebImageDownloader.shared.downloadImage(urlString: model.imageUrl ?? "") { self.moviePhoto.image = $0 }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
     
        let image = ASRatioLayoutSpec(ratio: 1.5, child: moviePhoto)
        
        let progressStack = ASStackLayoutSpec(direction: .horizontal, spacing: 20, justifyContent: .start, alignItems: .start, children: [circle, percentTitle])
        var textStack = ASLayoutSpec()
        if isRecomendation {
            textStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [progressStack, movieName])
        } else {
            textStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [movieName])
        }
        
        let textInset = ASInsetLayoutSpec(insets: .init(top: 0, left: 5, bottom: 0, right: 5), child: textStack)
        
        let cellStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .start, children: [image, textInset])
      
        return cellStack
    }
    
    private func setCell() {
        let attributesPercent: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray]
        let attributesMovie: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black]
        
       
        moviePhoto.backgroundColor = .yellow
        moviePhoto.contentMode = .scaleAspectFill
        moviePhoto.cornerRadius = 15
        
        movieName.attributedText = .init(string: model.title ?? "", attributes: attributesMovie)
        percentTitle.attributedText = .init(string: model.percentTitle, attributes: attributesPercent)
        
        circle.frame.size = .init(width: 15, height: 15)
        circle.circleStrokeNode(model.percent ?? 0)
    }
}

