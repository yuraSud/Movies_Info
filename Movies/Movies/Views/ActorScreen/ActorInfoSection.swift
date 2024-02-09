//
//  ActorInfoSection.swift
//  Movies
//
//  Created by Olga Sabadina on 31.01.2024.
//

import AsyncDisplayKit
import SDWebImage

class ActorInfoSection: ASDisplayNode {
    
    private let actorModel: MovieCellModel
    private let name = ASTextNode()
    private let gender = ASTextNode()
    private let actorDescription = ASTextNode()
    private let photo = ASImageNode()
    let buttonSeeMore = ASButtonNode()
    var isSeeMore = false
    
    init(model: MovieCellModel) {
        self.actorModel = model
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      
        let rightTextStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [name, gender, actorDescription, buttonSeeMore])
        rightTextStack.style.flexShrink = 1
        
        let imageElement = ASRatioLayoutSpec(ratio: 1.38, child: photo)
        
        imageElement.style.height = .init(unit: .points, value: 180)
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 15, justifyContent: .start, alignItems: .start, children: [imageElement, rightTextStack])
        
        return ASInsetLayoutSpec(insets: .init(top: 25, left: 16, bottom: 16, right: 16), child: mainStack)
    }
    
    override func didLoad() {
        super.didLoad()
        setSection()
        SDWebImageDownloader.shared.downloadImage(urlString: actorModel.imageUrl ?? "" ) { self.photo.image = $0 }
    }
    
    @objc func seeMore() {
        isSeeMore.toggle()
        buttonSeeMore.setTitle(isSeeMore ? "See Less" : "See More", with: .systemFont(ofSize: 13), with: isSeeMore ? .red : .blue, for: .normal)
        actorDescription.maximumNumberOfLines = isSeeMore ? 0 : 7
        self.setNeedsLayout()
    }
    
    private func setSection() {
        let attributesBold: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black]
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray]
        
        let actorName = NSMutableAttributedString(string: actorModel.title ?? "None", attributes: attributesBold)
        let genderTitle: NSAttributedString = .init(string: actorModel.gender ?? "None", attributes: mainAttributes)
        let description: NSAttributedString = .init(string: actorModel.biography ?? "description", attributes: mainAttributes)
        buttonSeeMore.setTitle("See More", with: .systemFont(ofSize: 14), with: .blue, for: .normal)
        name.attributedText = actorName
        gender.attributedText = genderTitle
        actorDescription.attributedText = description
        buttonSeeMore.addTarget(self, action: #selector(seeMore), forControlEvents: .touchUpInside)
        actorDescription.maximumNumberOfLines = 6
    }
}

