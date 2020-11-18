//
//  StupidView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 11/17/20.
//

import Cocoa

class CellContentView: NSView {
    
    private let backgroundColor: CGColor
    private let cornerRadius: CGFloat

    init(frame frameRect: NSRect, backgroundColor: CGColor, cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        super.init(frame: frameRect)
    }

    override func makeBackingLayer() -> CALayer {
        let layer = super.makeBackingLayer()
        layer.backgroundColor = self.backgroundColor
        layer.cornerRadius = self.cornerRadius
        layer.cornerCurve = .continuous
        return layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
