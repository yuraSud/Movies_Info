//
//  BaseHomeCell.swift
//  Movies
//
//  Created by Olga Sabadina on 11.01.2024.
//

import UIKit

class BaseHomeCell: UICollectionViewCell {
    
    let bacgroundView = UIView()
    var imageView = UIImageView()
    var circleView = UIView()
    var persentLabel = UILabel()
    var moviesNameLabel = UILabel()
    
    var model: MovieCellModel? = nil {
        didSet {
            updateCell()
        }
    }
  
    override init(frame: CGRect) {
        super .init(frame: frame)
        setPersentLabel()
        setMoviesNameLabel()
        setBackgroundView()
        setImageView()
        setPlayButton()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        persentLabel.text = ""
        moviesNameLabel.text = ""
        imageView.image = nil
    }
    
    func setPersentLabel() {}
    func setMoviesNameLabel() {}
    func updateCell() {}
    func setPlayButton() {}
    
    func setConstraints() {
        let sizeCell = self.bounds.size
        bacgroundView.frame = .init(x: 0, y: 0, width: sizeCell.width, height: sizeCell.height - 50)
        imageView.frame = bacgroundView.bounds
        persentLabel.frame = .init(x: 0, y: bacgroundView.frame.height + 7, width: sizeCell.width, height: 17)
        moviesNameLabel.frame = .init(x: 0, y: bacgroundView.frame.height + 28, width: sizeCell.width, height: 17)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bacgroundView.setShadowWithCornerRadius(cornerRadius: 20, shadowColor: .black, shadowOffset: .zero, shadowOpacity: 0.5, shadowRadius: 2)
    }
    
    private func setImageView() {
        imageView.image = ImageConstants.home
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        bacgroundView.addSubview(imageView)
        imageView.layer.cornerRadius = 20
    }
    
    private func setBackgroundView() {
        addSubview(bacgroundView)
        bacgroundView.backgroundColor = .white
    }
}
