//
//  ActorsCollection.swift
//  Movies
//
//  Created by Olga Sabadina on 25.01.2024.
//

import AsyncDisplayKit

protocol ActorInfoProtocol {
    func didOpenActorInfo(_ actor: MovieCellModel)
}

class ActorsCollection: ASCollectionNode {
    
    var openActorInfoDelegate: ActorInfoProtocol?
    var isFull: Bool = false
    private let actors: [MovieCellModel]
    
    private let collectionFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        return collectionViewFlowLayout
    }()
    
    init(actors: [MovieCellModel]) {
        self.actors = actors
        super.init(frame: .zero, collectionViewLayout: collectionFlowLayout, layoutFacilitator: nil)
        self.automaticallyManagesSubnodes = true
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
    }
}

extension ActorsCollection: ASCollectionDelegate, ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        actors.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let actor = actors[indexPath.item]
        return { ActorCell(actorModel: actor) }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        let cellWidth = collectionNode.bounds.width / 3.7
        let cellHeight = collectionNode.bounds.height / (isFull ? 2 : 1)
            let size = CGSize(width: cellWidth, height: cellHeight)
        
            return ASSizeRangeMake(size, size)
        }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let actor = actors[indexPath.item]
        openActorInfoDelegate?.didOpenActorInfo(actor)
    }
}
