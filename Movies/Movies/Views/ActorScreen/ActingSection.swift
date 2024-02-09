//
//  ActingSection.swift
//  Movies
//
//  Created by Olga Sabadina on 31.01.2024.
//

import AsyncDisplayKit
import UIKit

class ActingSection: ASDisplayNode {
    
    private var movies: [MovieCellModel] = []
    let actingTable: SearchTable
    var isFullShow: Bool = false {
        didSet {
            self.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(isFullShow ? 600 : 300))
            
            self.setNeedsLayout()
        }
    }
    
    init(movies: [MovieCellModel] = []) {
        self.movies = movies
        self.actingTable = SearchTable(source: [movies],typeCell: .medium)
        super.init()
        self.automaticallyManagesSubnodes = true
        setSection()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASInsetLayoutSpec(insets: .zero, child: actingTable)
    }
    
    private func setSection() {
        actingTable.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(300))
        actingTable.style.flexShrink = 1
        actingTable.headerDelegate = self
    }
}

extension ActingSection: HeaderShowFullTableProtocol {
    func didShowFullTable() {
        isFullShow.toggle()
    }
}

