//
//  CellView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/27/20.
//

import Cocoa

class CellView: NSView {

    static let deadColor  = CGColor(red:   0.0 / 255.0, green:   0.0 / 255.0, blue:   0.0 / 255.0, alpha: 1.0)
    static let aliveColor = CGColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)

    private let stepPeriod: CGFloat
    private var contentView: CellContentView!
    
    init(frame: CGRect, stepPeriod: CGFloat) {
        self.stepPeriod = stepPeriod
        super.init(frame: frame)
    }
    
    override func layout() {
        super.layout()
        
        let margin = self.frame.width * 0.10
        self.contentView = CellContentView(
            frame: CGRect (
                x: margin / 2.0,
                y: margin / 2.0,
                width: self.frame.width - margin,
                height: self.frame.height - margin
            ),
            backgroundColor: CellView.deadColor,
            cornerRadius: margin * 1.5
        )

        self.contentView.layer?.backgroundColor = CellView.deadColor
        self.addSubview(self.contentView)
    }
    
    func update(cell: GameOfLifeCellState) {
        let waveOrigin = self.superview!.bounds.center
        let maxDistanceFromWaveOrigin = waveOrigin.distance(to: self.superview!.frame.size.point)

        let distanceFromWaveOrigin = waveOrigin.distance(to: self.frame.center)
        let waveDistanceDelayProportion = distanceFromWaveOrigin / maxDistanceFromWaveOrigin
        let easedDistanceDelayProportion = self.eaze(waveDistanceDelayProportion)

        let cellStateDelay = cell.isAlive ? 0.0 : (self.stepPeriod * 0.15)
        let delay = (cellStateDelay + (self.stepPeriod * 0.60)) * easedDistanceDelayProportion
        let animationStartTime = DispatchTime.now() + Double(delay)

        DispatchQueue.main.asyncAfter(deadline: animationStartTime) {
            let newColor = cell.isAlive ? CellView.aliveColor : CellView.deadColor
            
            CATransaction.begin()
            CATransaction.disableActions()

            let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
            colorAnimation.fromValue = self.contentView.layer?.backgroundColor
            colorAnimation.toValue = newColor
            colorAnimation.duration = Double(self.stepPeriod * 0.25)

            self.contentView.layer?.add(colorAnimation, forKey: "backgroundColor")
            self.contentView.layer?.backgroundColor = newColor

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
