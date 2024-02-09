//
//  CircleStrokeView.swift
//  Movies
//
//  Created by Olga Sabadina on 10.01.2024.
//

import UIKit

extension UIView {
    
    func circleStrokeView(total : Int, current : Int) {
        self.layer.sublayers?.forEach{$0.removeFromSuperlayer()}
        self.layer.cornerRadius = self.frame.size.width / 2
        self.backgroundColor = .clear
        let width :CGFloat = 2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint (x: self.frame.size.width / 2, y: self.frame.size.height / 2),
                                      radius: self.frame.size.width / 2,
                                      startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi),
                                      clockwise: true)
        let multiplier = CGFloat((100.000 / Double(total)) * 0.0100)
        let progress = Double(current)/Double(total)
       
        for i in 1...total {
            
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            if i <= current {
                circleShape.strokeColor = UIColor.primaryCircleColor(progress)
            }
            else{
                circleShape.strokeColor = UIColor.secondaryCircleColor(progress)
            }
            
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.lineWidth = width
            circleShape.strokeStart = CGFloat(CGFloat(i - 1) * multiplier)
            circleShape.strokeEnd = 1
            self.layer.addSublayer(circleShape)
        }
    }
}

// MARK: - circleStrokeView for ASDisplayNode

import AsyncDisplayKit

extension ASDisplayNode {
    
    func circleStrokeNode(total: Int = 100, _ current: Int) {
        self.subnodes?.forEach { $0.removeFromSupernode() }
        self.cornerRadius = self.bounds.size.width / 2
        self.backgroundColor = .clear
        let width: CGFloat = 2.0
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2),
            radius: self.bounds.size.width / 2,
            startAngle: CGFloat(-0.5 * Double.pi),
            endAngle: CGFloat(1.5 * Double.pi),
            clockwise: true
        )
        let multiplier = CGFloat((100.0 / Double(total)) * 0.01)
        let progress = Double(current)/Double(total)
        
        for i in 1...total {
            let circleNode = ASDisplayNode()
            circleNode.backgroundColor = .clear
            circleNode.cornerRadius = self.bounds.size.width / 2

            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            if i <= current {
                circleShape.strokeColor = UIColor.primaryCircleColor(progress)
            } else {
                circleShape.strokeColor = UIColor.secondaryCircleColor(progress)
            }

            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.lineWidth = width
            circleShape.strokeStart = CGFloat(CGFloat(i - 1) * multiplier)
            circleShape.strokeEnd = 1

            circleNode.layer.addSublayer(circleShape)
            self.addSubnode(circleNode)
        }
    }
}
