//
//  HomeCell.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//
import SDWebImage
import UIKit

class HomeCell: BaseHomeCell {
    
    static var identCell = "homeCell"
    
    override func setPersentLabel() {
        persentLabel.textColor = ColorConstans.moviesName
        persentLabel.font = UIFont(name: FontConstants.openSansRegular, size: 14)
        addSubview(persentLabel)
        addSubview(circleView)
    }
    
    override func setMoviesNameLabel() {
        moviesNameLabel.textColor = ColorConstans.moviesName
        moviesNameLabel.font = UIFont(name: FontConstants.openSansSemiBold, size: 14)
        addSubview(moviesNameLabel)
    }
    
    override func setConstraints() {
        let sizeCell = self.bounds.size
        bacgroundView.frame = .init(x: 0, y: 0, width: sizeCell.width, height: sizeCell.height - 50)
        imageView.frame = bacgroundView.bounds
        circleView.frame = .init(x: 0, y: bacgroundView.frame.height + 7, width: 17, height: 17)
        persentLabel.frame = .init(x: 20, y: bacgroundView.frame.height + 7, width: sizeCell.width, height: 17)
        moviesNameLabel.frame = .init(x: 0, y: bacgroundView.frame.height + 28, width: sizeCell.width, height: 17)
    }

    override func updateCell() {
        guard let model else { return }
        let urlPoster = URL(string: model.imageUrl ?? "")
        imageView.sd_setImage(with: urlPoster)
        DispatchQueue.main.async {
            self.circleView.circleStrokeView(total: 100, current: model.percent ?? 0)
        }
        persentLabel.text = "\(model.percent ?? 0) %"
        moviesNameLabel.text = model.title
    }
}
 
