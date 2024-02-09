//
//  LatestTrailersCell.swift
//  Movies
//
//  Created by Olga Sabadina on 11.01.2024.
//

import UIKit

class LatestTrailersCell: BaseHomeCell {
    
    static var identCell = "latestTrailersCell"
    let playButtonImage = UIImageView()
    
    override func setPersentLabel() {
        persentLabel.font = UIFont(name: FontConstants.openSansSemiBold, size: 14)
        addSubview(persentLabel)
    }
    
    override func setMoviesNameLabel() {
        moviesNameLabel.textColor = ColorConstans.latestTrailers
        moviesNameLabel.font = UIFont(name: FontConstants.openSansRegular, size: 14)
        addSubview(moviesNameLabel)
    }
    
    override func updateCell() {
        guard let model else { return }
        let urlPoster = URL(string: model.imageFullHDUrl ?? "")
        imageView.sd_setImage(with: urlPoster)
        persentLabel.text = model.title
        moviesNameLabel.text = model.releaseData
    }
    
    override func setPlayButton() {
        addSubview(playButtonImage)
        let cellSize = self.bounds.size
        playButtonImage.frame = .init(x: 15, y: cellSize.height - 105, width: 45, height: 45)
        playButtonImage.image = .play
    }
}
