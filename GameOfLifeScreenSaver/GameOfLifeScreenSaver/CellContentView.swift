//
//  CellContentView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 11/17/20.
//

import Cocoa

class CellContentView: NSView {

    init(frame frameRect: NSRect, backgroundColor: CGColor, cornerRadius: CGFloat) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = backgroundColor
        self.layer?.cornerRadius = cornerRadius
        self.layer?.cornerCurve = .continuous
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
