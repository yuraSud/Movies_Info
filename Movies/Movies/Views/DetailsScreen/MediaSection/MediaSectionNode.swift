//
//  MediaSectionNode.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import AsyncDisplayKit

class MediaSectionNode: ASTableNode {
    
    private var media: [MovieCellModel] = []
    var completionAction: ((Int) -> Void)?
    
    init(media: [MovieCellModel] = [], completion: ((Int) -> Void)? = nil) {
        self.media = media
        self.completionAction = completion
        super.init(style: .plain)
        self.dataSource = self
        self.delegate = self
        self.style.height = ASDimension(unit: .points, value: media.count > 1 ? 460 : 300)
        self.style.width = ASDimensionAuto
        self.view.separatorStyle = .none
        self.style.flexShrink = 1
    }
}

extension MediaSectionNode: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderForSections(headerData: .init(title: "Media", type: .full), actionSegment: { segmentIndex in
            print(segmentIndex, "segmentIndex Media") // left to see action
        })
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        media.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let media = media[indexPath.row]
        
        return { MediaCell(model: media)}
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let cellWidth = tableNode.bounds.width
        let cellHeight: CGFloat = 260
        let size = CGSize(width: cellWidth, height: cellHeight)
        
        return ASSizeRangeMake(size, size)
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        guard let videoId = media[indexPath.row].idMovie else { return }
        completionAction?(videoId)
        }
}
    

