//
//  CellView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/27/20.
//

import Cocoa

class CellView: NSView {
    
    private static let deadColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    private static let aliveColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    
    private let stepPeriod: Double
    
    init(stepPeriod: Double) {
        self.stepPeriod = stepPeriod
        super.init(frame: .zero)
    }
    
    func update(cell: GameOfLifeCellState) {
        if cell.isAlive {
            self.layer?.backgroundColor = CellView.aliveColor
        } else {
            self.layer?.backgroundColor = CellView.deadColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
