//
//  CellView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/27/20.
//

import Cocoa

class CellView: NSView {
    
    private static let deadColor  = NSColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0).cgColor
    private static let aliveColor = NSColor(red: 0.90, green: 0.90, blue: 0.95, alpha: 1.0).cgColor

    private let stepPeriod: CGFloat
    
    init(stepPeriod: CGFloat) {
        self.stepPeriod = stepPeriod
        super.init(frame: .zero)
    }
    
    override func makeBackingLayer() -> CALayer {
        let layer = super.makeBackingLayer()
        layer.backgroundColor = CellView.deadColor
        return layer
    }
    
    func update(cell: GameOfLifeCellState) {
        // (0, 0)
//        let waveOrigin = CGPoint.zero
//        let maxDistanceFromWaveOrigin = waveOrigin.distance(to: self.superview!.frame.size.point)
        
        // Middle of left edge
//        let waveOrigin = CGPoint(
//            x: 0.0,
//            y: self.superview!.frame.height / 2.0
//        )
//        let maxDistanceFromWaveOrigin = waveOrigin.distance(to: self.superview!.frame.size.point)
        
        // Center
        let waveOrigin = self.superview!.bounds.center
        let maxDistanceFromWaveOrigin = waveOrigin.distance(to: self.superview!.frame.size.point)

        let distanceFromWaveOrigin = waveOrigin.distance(to: self.frame.center)
        let waveDistanceDelayProportion = distanceFromWaveOrigin / maxDistanceFromWaveOrigin
        let easedDistanceDelayProportion = self.eaze(waveDistanceDelayProportion)
        
        let cellStateDelay = cell.isAlive ? 0.0 : (self.stepPeriod * 0.15 * easedDistanceDelayProportion)
        let delay = cellStateDelay + (self.stepPeriod * 0.55 * easedDistanceDelayProportion)
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
    
    private func eaze(_ x: CGFloat) -> CGFloat {
        // www.easings.net
        return sin((x * CGFloat.pi) / 2.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
