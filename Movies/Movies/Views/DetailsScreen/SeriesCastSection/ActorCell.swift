//
//  ActorCell.swift
//  Movies
//
//  Created by Olga Sabadina on 25.01.2024.
//

import SDWebImage
import AsyncDisplayKit

class ActorCell: ASCellNode {
    
    private let actorModel: MovieCellModel
    private let actorPhoto = ASImageNode()
    private let actorName = ASTextNode()
    private let filmName = ASTextNode()
    
    init(actorModel: MovieCellModel) {
        self.actorModel = actorModel
        super.init()
        self.automaticallyManagesSubnodes = true
        setCell()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
     
        let image = ASInsetLayoutSpec(insets: .zero, child: actorPhoto)
        
        let textStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .center, children: [actorName, filmName])
        let textInset = ASInsetLayoutSpec(insets: .init(top: 7, left: 9, bottom: 7, right: 9), child: textStack)
        
        let cellStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [image, textInset])
    
        return cellStack
    }
    
    private func setCell() {
        let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
        let attributesName: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle]
        let attributesFilm: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle]
        
        actorPhoto.backgroundColor = .gray
        actorPhoto.style.height = .init(unit: .points, value: 113)
        actorPhoto.style.width = .init(unit: .points, value: 82)
        actorPhoto.contentMode = .scaleAspectFill
        actorPhoto.cornerRadius = 3
        actorName.attributedText = .init(string: actorModel.title ?? "Unknow", attributes: attributesName)
        filmName.attributedText = .init(string: actorModel.asHeroInFilm ?? "None", attributes: attributesFilm)
        
        SDWebImageDownloader.shared.downloadImage(urlString: actorModel.imageUrl ?? "") {
            self.actorPhoto.image = $0 }
    }
}

