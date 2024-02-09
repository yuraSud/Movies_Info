//
//  YoutubeCell.swift
//  Movies
//
//  Created by Olga Sabadina on 04.02.2024.
//

import YouTubePlayer
import AsyncDisplayKit

class YoutubeCell: ASDisplayNode {
    private let videoUrl: String
    private let youTubePlayer: ASDisplayNode
    private let isMain: Bool
    
    init(_ videoUrl: String?, isMain: Bool = true) {
        self.videoUrl = videoUrl ?? ""
        self.isMain = isMain
        
        if self.videoUrl.isEmpty {
            youTubePlayer = ASDisplayNode()
        } else {
            youTubePlayer = ASDisplayNode(viewBlock: { YouTubePlayerView() })
        }
        
        super.init()
        automaticallyManagesSubnodes = true
        setupVideoPlayer()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec(insets: .init(top: 5, left: 0, bottom: 10, right: 0), child: youTubePlayer)
        return insetSpec
    }
    
    private func setupVideoPlayer() {
        guard !videoUrl.isEmpty else { return }

        if let playerView = youTubePlayer.view as? YouTubePlayerView {
            playerView.loadVideoID(videoUrl)
        }
        youTubePlayer.style.width = .init(unit: .fraction, value: 1)
        youTubePlayer.style.height = .init(unit: .points, value: isMain ? 230 : 140)
        youTubePlayer.style.flexShrink = 1
    }
}
