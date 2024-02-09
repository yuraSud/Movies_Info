//
//  VideoCell.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import SDWebImage
import AsyncDisplayKit

protocol PlayVideoProtocol {
    func didTapPlayButton()
}

class VideoCell: ASDisplayNode {
    private let videoUrl: String
    private let imageNode = ASImageNode()
    private let playButton = ASButtonNode()
    private var delegatePlayVideo: PlayVideoProtocol?
    
    init(_ videoUrl: String?, inMediaSection: Bool = false) {
        self.videoUrl = videoUrl ?? ""
        super.init()
        self.automaticallyManagesSubnodes = true
        setVideo(inMediaSection)
        setButton()
    }
    
    override func didLoad() {
        super.didLoad()
        guard !videoUrl.isEmpty else { return }
        SDWebImageDownloader.shared.downloadImage(urlString: videoUrl) { self.imageNode.image = $0 }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonIns = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: playButton)
        
        let image = ASOverlayLayoutSpec(child: imageNode, overlay: buttonIns)
        
        return ASInsetLayoutSpec(insets: .init(top: 5, left: 0, bottom: 10, right: 0), child: image)
    }
    
    @objc private func playVideo() {
        delegatePlayVideo?.didTapPlayButton()
    }
    
    private func setVideo(_ inMediaSection: Bool) {
        imageNode.contentMode = .scaleAspectFill
        imageNode.clipsToBounds = true
        imageNode.style.width = .init(unit: .fraction, value: 1)
        imageNode.style.height = .init(unit: .points, value: 230)
        imageNode.style.flexShrink = 1
    }
    
    private func setButton() {
        playButton.cornerRadius = 30
        playButton.style.preferredSize = .init(width: 60, height: 60)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playVideo), forControlEvents: .touchUpInside)
    }
}
