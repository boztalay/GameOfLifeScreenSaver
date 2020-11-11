//
//  Utilities.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 11/10/20.
//

import Foundation

extension CGPoint {
    
    func distance(to other: CGPoint) -> CGFloat {
        return sqrt(
            ((self.x - other.x) * (self.x - other.x)) +
            ((self.y - other.y) * (self.y - other.y))
        )
    }
}

extension CGSize {
    
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(
            x: self.x + (self.width / 2.0),
            y: self.y + (self.height / 2.0)
        )
    }
}
