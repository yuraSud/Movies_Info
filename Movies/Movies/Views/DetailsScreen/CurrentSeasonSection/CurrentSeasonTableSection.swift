//
//  CurrentSeasonSection.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import AsyncDisplayKit

class CurrentSeasonTableSection: ASTableNode {
    
    private var movies: [MovieCellModel] = []
    private var completionAction: ((MovieCellModel) -> Void)?
    private var sectionTitle: String
    var isFullShow: Bool = false {
        didSet {
            self.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(isFullShow ? 400 : 140))
            
            self.setNeedsLayout()
        }
    }
    
    init(movies: [MovieCellModel] = [], sectionTitle: String) {
        self.movies = movies
        self.sectionTitle = sectionTitle
        super.init(style: .plain)
        self.delegate = self
        self.dataSource = self
        self.view.separatorStyle = .none
        self.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(140))
        self.style.flexShrink = 1
    }
}

extension CurrentSeasonTableSection: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = HeaderForSections(headerData: .init(title: sectionTitle, type: .simple)) { type in
            if self.movies.count > 1 {
                self.isFullShow.toggle()
            }
        } actionSegment: { _ in }

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let movie = movies[indexPath.row]
        return { CurrentSeasonTableCell(model: movie) }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        guard let cell = tableNode.nodeForRow(at: indexPath) as? CurrentSeasonTableCell else { return }
        completionAction?(cell.model)
    }
}
