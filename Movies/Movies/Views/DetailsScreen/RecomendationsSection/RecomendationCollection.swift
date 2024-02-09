//
//  RecomendationCollection.swift
//  Movies
//
//  Created by Olga Sabadina on 30.01.2024.
//

import AsyncDisplayKit

protocol DetailMovieDelegateProtocol {
    func openDetailScreen(_ model: MovieCellModel)
}

class RecomendationCollection: ASCollectionNode {
    
    private let isRecomendation: Bool
    private let collectionFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 20
        return collectionViewFlowLayout
    }()
    
    var detailDelegate: DetailMovieDelegateProtocol?
    private let movies: [MovieCellModel]
    
    init(movies: [MovieCellModel], isRecomendation: Bool = true, delegate: DetailMovieDelegateProtocol?) {
        self.movies = movies
        self.isRecomendation = isRecomendation
        self.detailDelegate = delegate
        super.init(frame: .zero, collectionViewLayout: collectionFlowLayout, layoutFacilitator: nil)
        self.automaticallyManagesSubnodes = true
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
    }
}

extension RecomendationCollection: ASCollectionDelegate, ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let movie = movies[indexPath.item]
        return {
            MovieCell(model: movie, isRecomendation: self.isRecomendation)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        let cellWidth = collectionNode.bounds.width / 2.8
        let cellHeight = collectionNode.bounds.height
            let size = CGSize(width: cellWidth, height: cellHeight)
        
            return ASSizeRangeMake(size, size)
        }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        detailDelegate?.openDetailScreen(movie)
    }
}
