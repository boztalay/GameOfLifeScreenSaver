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

    private let stepPeriod: CGFloat
    
    init(stepPeriod: CGFloat) {
        self.stepPeriod = stepPeriod
        super.init(frame: .zero)
        self.layer?.backgroundColor = CellView.deadColor
    }
    
    func update(cell: GameOfLifeCellState) {
        let waveOrigin = CGPoint(
            x: self.superview!.frame.width / 2.0,
            y: self.superview!.frame.height / 2.0
        )

        let distanceFromWaveOrigin = waveOrigin.distance(to: self.frame.origin)
        let maxDistanceFromWaveOrigin = waveOrigin.distance(to: self.superview!.frame.size.point)
        let waveDistanceDelayProportion = distanceFromWaveOrigin / maxDistanceFromWaveOrigin
        
        let cellStateDelay = cell.isAlive ? 0.0 : (self.stepPeriod * 0.15)
        let delay = cellStateDelay + (self.stepPeriod * 0.55 * waveDistanceDelayProportion)
        let animationStartTime = DispatchTime.now() + Double(delay)
        
        DispatchQueue.main.asyncAfter(deadline: animationStartTime) {
            let layer = self.layer!
            let newColor = cell.isAlive ? CellView.aliveColor : CellView.deadColor
            
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.fromValue = layer.backgroundColor
            animation.toValue = newColor
            animation.duration = Double(self.stepPeriod * 0.25)

            layer.add(animation, forKey: nil)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.backgroundColor = newColor
            CATransaction.commit()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
