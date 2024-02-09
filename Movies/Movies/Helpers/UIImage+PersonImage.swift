//
//  UIImage+PersonImage.swift
//  Movies
//
//  Created by Olga Sabadina on 10.01.2024.
//

import UIKit

extension UIImage {
    
    static func getPersonImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: TitleConstants.userImage) {
            let image = UIImage(data: imageData)
            return image
        } else {
            return ImageConstants.person
        }
    }
    
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = min(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: size.width*scale, height: size.height*scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/1.0
            }
            draw(in: CGRect(origin: .zero, size: resizeSize))
        }
    }
    
    func cropImageToCircle() -> UIImage {
        
        let sideLength = min(self.size.width, self.size.height)
        let sourceSize = self.size
        
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0
        
        let cropRect = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength).integral
        
        let imageRendererFormat = self.imageRendererFormat
        imageRendererFormat.opaque = false
        
        let circleCroppedImage = UIGraphicsImageRenderer(size: cropRect.size, format: imageRendererFormat).image { context in
            
            let drawRect = CGRect(origin: .zero, size: cropRect.size)
            UIBezierPath(ovalIn: drawRect).addClip()
            let drawImageRect = CGRect(origin: CGPoint(x: -xOffset,y: -yOffset), size: self.size)
            self.draw(in: drawImageRect)
        }
        return circleCroppedImage
    }
    
    func prepareImageToTabBar() -> UIImage {
        self.cropImageToCircle()
            .resized(to: .init(width: 24, height: 24))
            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}
