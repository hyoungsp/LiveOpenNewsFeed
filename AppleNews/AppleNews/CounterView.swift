//
//  CounterView.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 2/1/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import UIKit

//
// - Attributions: https://www.raywenderlich.com/162315/core-graphics-tutorial-part-1-getting-started
//

@IBDesignable class CounterView: UIView {

    private struct Constants {
        // set up the number of articles: arbitrary number (enough to hold all articles)
        static let numberOfArticles = 10000
        // the thickness of the arc
        static let arcWidth: CGFloat = 25
    }
    
    @IBInspectable var counter: Int = 5 {
        didSet {
            // display the number of articles
            if counter <=  Constants.numberOfArticles {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    // options (not needed)
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        
        // define a center position and radius for the custom core graphic circle
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // Since the Core Graphics should draw a circle, the start angle should be 0 and ends at 2 * pi position
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi
        
        // define a path using the star/ending engle to promp a drawing
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // Then actual stroke the path invoked
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        outlineColor.setStroke()

    }

}
