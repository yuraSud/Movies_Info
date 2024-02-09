//
//  SDWebImage+Downloader.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import Foundation

import SDWebImage

extension SDWebImageDownloader {
    func downloadImage(urlString: String, completion: ((UIImage?) -> Void)?) {
        let url = URL(string: urlString)
         self.downloadImage(with: url) { image, _, error, _ in
             guard let error else {
                 completion?(image)
                 return
             }
             print(error.localizedDescription)
        }
    }
}
