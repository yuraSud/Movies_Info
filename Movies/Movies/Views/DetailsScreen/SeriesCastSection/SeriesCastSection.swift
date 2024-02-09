//
//  SecondSection.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class SeriesCastSection: ASDisplayNode {
    
    private var buttonSeeAll: ASButtonNode
    private var actionBtn: ((HeaderType) -> Void)?
    private var collectionHeightConstraint: ASLayoutElementSize?
    private let headerTitle = ASTextNode()
    private let typeBtn: HeaderType
    private let sectionData: [MovieCellModel]
    let collectionActor: ActorsCollection
    var isFullShow: Bool = false {
        didSet {
            collectionActor.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(isFullShow ? 400 : 170))
            collectionActor.isFull = isFullShow
            self.setNeedsLayout()
        }
    }
    
    init(typeBtn: HeaderType = .simple, sectionData: [MovieCellModel] = [], actionBtn: ( (HeaderType) -> Void)? = nil, delegate: ActorInfoProtocol? = nil) {
        self.buttonSeeAll = ASButtonNode()
        self.collectionActor = ActorsCollection(actors: sectionData)
        self.actionBtn = actionBtn
        self.typeBtn = typeBtn
        self.sectionData = sectionData
        
        super.init()
        collectionActor.openActorInfoDelegate = delegate
        self.automaticallyManagesSubnodes = true
        setHeader()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
     
        let horizStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .start, children: [headerTitle, buttonSeeAll])
        horizStack.style.width = .init(unit: .fraction, value: 1)
        
        let collectionStack = ASInsetLayoutSpec(insets: .init(), child: self.collectionActor)
        
        let sectionStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .start, alignItems: .start, children: [horizStack, collectionStack])
        
        let stackInset = ASInsetLayoutSpec(insets: .init(top: 5, left: 16, bottom: 5, right: 16), child: sectionStack)
        
        return stackInset
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        isFullShow.toggle()
    }
    
    private func setHeader() {
        let attributesBold: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black]
        
        headerTitle.attributedText = .init(string: "Series Cast", attributes: attributesBold)
        
        buttonSeeAll.setTitle("See All", with: .systemFont(ofSize: 14), with: nil, for: .normal)

        buttonSeeAll.addTarget(self, action: #selector(handleTap), forControlEvents: .touchUpInside)
       
        collectionActor.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(170))
    }
}

