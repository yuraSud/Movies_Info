//
//  HeaderDetail.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import AsyncDisplayKit

class MainMovieSection: ASDisplayNode {
 
    private let headerData: MainSectionModel
    private let headerDetail: HeaderDetailName
    private let videoCell: YoutubeCell
    private let genreLabels: GenreMovie
    private let buttonStack: ButtonsStack
    
    init(headerData: MainSectionModel = .init()) {
        self.headerData = headerData
        headerDetail = HeaderDetailName(headerData: headerData)
        videoCell = YoutubeCell(headerData.videoURLString)
        genreLabels = GenreMovie(headerData)
       
        buttonStack = ButtonsStack(actionBtn: { btn in
            print(btn.title) // left to see the working out of the button action
        })
        
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [self.headerDetail, self.videoCell, self.genreLabels, self.buttonStack ])
    }
}
