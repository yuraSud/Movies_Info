//
//  SocialTable.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import AsyncDisplayKit

class SocialTable: ASTableNode {
    
    private var socials: [SocialCellModel] = []
    var isFullShow: Bool = false {
        didSet {
            self.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(isFullShow ? 400 : 120))
            
            self.setNeedsLayout()
        }
    }
    
    init(socials: [SocialCellModel] = []) {
        self.socials = socials
        super.init(style: .plain)
        self.dataSource = self
        self.delegate = self
        self.style.preferredLayoutSize = .init(width: ASDimensionAuto, height: ASDimensionMake(120))
        self.view.separatorStyle = .none
        self.style.flexShrink = 1
    }
}

extension SocialTable: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderForSections(headerData: .init(title: "Social", type: .middle)) { type in
            self.isFullShow.toggle()
        } actionSegment: { segmentIndex in
            print(segmentIndex, "segmentIndex") // left to see the working out of the segment action
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        socials.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let social = socials[indexPath.row]
        return { SocialCellNode(model: social) }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        guard let cell = tableNode.nodeForRow(at: indexPath) as? SocialCellNode else { return }
        print(cell.title.attributedText?.string ?? "nil") // left to see action
    }
}
