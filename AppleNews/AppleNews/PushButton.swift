//
//  PushButton.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 2/1/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit
///
/// These are not relevant to the app: But I practiced with this for studying how I can connect a button with the Core Graphics properties
///

@IBDesignable class PushButton: UIButton {

    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = true
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        if isAddButton {
            //move the initial point of the path
            //to the start of the horizontal stroke
            plusPath.move(to: CGPoint(
                x: halfWidth - halfPlusWidth + Constants.halfPointShift,
                y: halfHeight + Constants.halfPointShift))
            
            //add a point to the path at the end of the stroke
            plusPath.addLine(to: CGPoint(
                x: halfWidth + halfPlusWidth + Constants.halfPointShift,
                y: halfHeight + Constants.halfPointShift))
        }
        
        //set the stroke color
        UIColor.white.setStroke()
        plusPath.stroke()
    }

}




