//
//  CellView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/27/20.
//

import Cocoa

class CellView: NSView {
    
    private let stepPeriod: Double
    private let totalGenerationCount: Int
    private var lastGenerationAlive: Int?
    
    override var isOpaque: Bool {
        return false
    }
    
    init(stepPeriod: Double, totalGenerationCount: Int) {
        self.stepPeriod = stepPeriod
        self.totalGenerationCount = totalGenerationCount
        super.init(frame: .zero)
        
        self.layer?.backgroundColor = .clear
    }
    
    func update(cell: GameOfLifeCellState, generation: Int) {
//        if cell.isAlive {
//            self.lastGenerationAlive = generation
//        }
//
//        guard let lastGenerationAlive = self.lastGenerationAlive else {
//            self.layer?.backgroundColor = .white
//            self.layer?.opacity = 0.0
//            return
//        }
//
//        var visibilityProportion = CGFloat(lastGenerationAlive) / CGFloat(self.totalGenerationCount) * 0.85
//        if lastGenerationAlive < self.totalGenerationCount {
//            visibilityProportion = visibilityProportion * 0.75
//        }
//
//        self.layer?.backgroundColor = .black
//        self.layer?.opacity = Float(visibilityProportion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
