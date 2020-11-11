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
        
        self.layer?.backgroundColor = CellView.deadColor
    }
    
    func update(cell: GameOfLifeCellState) {
        let halfStepPeriod = self.stepPeriod / 2.0
        let delay = cell.isAlive ? 0.0 : halfStepPeriod
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            let layer = self.layer!
            let newColor = cell.isAlive ? CellView.aliveColor : CellView.deadColor
            
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.fromValue = layer.backgroundColor
            animation.toValue = newColor
            animation.duration = halfStepPeriod

            layer.add(animation, forKey: "animation")
            layer.backgroundColor = newColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
