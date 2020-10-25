//
//  GameOfLifeScreenSaverView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/23/20.
//

import ScreenSaver

class GameOfLifeScreenSaverView: ScreenSaverView {
    
    private static let cellSize: Int = 50
    private static let initialProportionAlive = 0.3
    
    private static let frameRate = 60.0
    private static let transitionTime = 2.0
    private static let deadCellColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    private static let livingCellColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var game: GameOfLife
    private var transitionProportion: Double
    
    private var transitionProportionIncrement: Double {
        return (1.0 / (GameOfLifeScreenSaverView.frameRate * GameOfLifeScreenSaverView.transitionTime))
    }

    override init?(frame: NSRect, isPreview: Bool) {
        let width = Int(Int(frame.width) + GameOfLifeScreenSaverView.cellSize) / GameOfLifeScreenSaverView.cellSize
        let height = Int(Int(frame.height) + GameOfLifeScreenSaverView.cellSize) / GameOfLifeScreenSaverView.cellSize
        self.game = GameOfLife(width: width, height: height)
        self.game.randomizeCells(with: GameOfLifeScreenSaverView.initialProportionAlive)
        
        self.transitionProportion = 0.0
        
        super.init(frame: frame, isPreview: isPreview)

        self.animationTimeInterval = 1.0 / GameOfLifeScreenSaverView.frameRate
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let horizontalOffset = (self.frame.width - CGFloat(self.game.width * GameOfLifeScreenSaverView.cellSize)) / 2.0
        let verticalOffset = (self.frame.height - CGFloat(self.game.height * GameOfLifeScreenSaverView.cellSize)) / 2.0
        
        self.game.mapCells { x, y, cell, nextCell in
            let cellRect = NSRect(
                x: CGFloat(x * GameOfLifeScreenSaverView.cellSize) + horizontalOffset,
                y: CGFloat(y * GameOfLifeScreenSaverView.cellSize) + verticalOffset,
                width: CGFloat(GameOfLifeScreenSaverView.cellSize),
                height: CGFloat(GameOfLifeScreenSaverView.cellSize)
            )
            
            let cellColor = self.color(forCell: cell, transitioningTo: nextCell)
            cellColor.setFill()
            cellRect.fill()
        }
    }
    
    override func animateOneFrame() {
        self.transitionProportion += self.transitionProportionIncrement
        
        if self.transitionProportion >= 1.0 {
            self.transitionProportion = 0.0
            self.game.step()
        }
        
        self.setNeedsDisplay(self.bounds)
    }
    
    private func color(forCell cell: Bool, transitioningTo nextCell: Bool) -> NSColor {
        guard nextCell != cell else {
            if cell {
                return GameOfLifeScreenSaverView.livingCellColor
            } else {
                return GameOfLifeScreenSaverView.deadCellColor
            }
        }

        let startColor: NSColor
        let endColor: NSColor

        if cell {
            startColor = GameOfLifeScreenSaverView.livingCellColor
            endColor = GameOfLifeScreenSaverView.deadCellColor
        } else {
            startColor = GameOfLifeScreenSaverView.deadCellColor
            endColor = GameOfLifeScreenSaverView.livingCellColor
        }

        let eased = self.ease(x: self.transitionProportion)

        return NSColor(
            red: startColor.redComponent + ((endColor.redComponent - startColor.redComponent) * CGFloat(eased)),
            green: startColor.greenComponent + ((endColor.greenComponent - startColor.greenComponent) * CGFloat(eased)),
            blue: startColor.blueComponent + ((endColor.blueComponent - startColor.blueComponent) * CGFloat(eased)),
            alpha: 1.0
        )
    }

    private func ease(x: Double) -> Double {
        // https://easings.net/#easeInOutQuad
        return (x < 0.5) ? (2 * x * x) : (1.0 - pow((-2.0 * x) + 2.0, 2) / 2.0);
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
