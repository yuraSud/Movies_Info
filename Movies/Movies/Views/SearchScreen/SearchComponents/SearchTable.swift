//
//  SearchTable.swift
//  Movies
//
//  Created by Olga Sabadina on 23.01.2024.
//

import AsyncDisplayKit

protocol HeaderShowFullTableProtocol {
    func didShowFullTable()
}

class SearchTable: ASTableNode {
    
    var sourceDataForTable = [[MovieCellModel]]() {
        didSet {
            reloadData()
        }
    }
    var typeCell: TypeSearchCell = .short
    var completionAction: ((MovieCellModel) -> Void)?
    var headerDelegate: HeaderShowFullTableProtocol?
    var openDetailDelegate: DetailMovieDelegateProtocol?
    
    init(source: [[MovieCellModel]] = [], typeCell: TypeSearchCell = .full) {
        self.typeCell = typeCell
        super.init(style: .plain)
        self.delegate = self
        self.dataSource = self
        self.view.separatorStyle = .none
        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .fraction, value: 1)
        self.style.flexShrink = 1
        sourceDataForTable = source
    }
}

extension SearchTable: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return sourceDataForTable.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if sourceDataForTable.count > 1 {
            title = SearchCategories.allCases[section].rawValue.capitalized
        } else {
            title = "Trending"
        }
        var header = UIView()
        switch typeCell {
            
        case .full,.short:
             header = HeaderInTable(title: title, type: typeCell)
            
        case .medium:
             header = HeaderForSections(headerData: .init(title: "Acting", type: .simple)) { type in
                 self.headerDelegate?.didShowFullTable()
             } actionSegment: { _ in }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        sourceDataForTable[section].count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let search = sourceDataForTable[indexPath.section][indexPath.row]
        return { let cell = SearchCell(search: search, type: self.typeCell)
            cell.accessibilityIdentifier = "SearchCell_\(indexPath.row)"
            return cell
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        guard let cell = tableNode.nodeForRow(at: indexPath) as? SearchCell else { return }
        openDetailDelegate?.openDetailScreen(cell.model)
    }
    
}
