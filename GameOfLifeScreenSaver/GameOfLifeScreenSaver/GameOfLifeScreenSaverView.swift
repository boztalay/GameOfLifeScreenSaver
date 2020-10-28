//
//  GameOfLifeScreenSaverView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/23/20.
//

import ScreenSaver

enum GameOfLifeScreenSaverTransitionState {
    case cellsBorn
    case cellsDying
}

class GameOfLifeScreenSaverView: ScreenSaverView {
    
    private static let targetCellSize: CGFloat = 50.0
    
    private static let frameRate = 60.0
    private static let transitionTime = 2.75
    private static let deadCellColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    private static let livingCellColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var game: GameOfLife
    private var cellSize: CGFloat
    private var transitionProportion: Double
    private var transitionState: GameOfLifeScreenSaverTransitionState
    
    private var transitionProportionIncrement: Double {
        return (1.0 / (GameOfLifeScreenSaverView.frameRate * GameOfLifeScreenSaverView.transitionTime))
    }

    override init?(frame: NSRect, isPreview: Bool) {
        let gameWidth = Int(frame.width / GameOfLifeScreenSaverView.targetCellSize)
        self.cellSize = frame.width / CGFloat(gameWidth)
        let gameHeight = Int(frame.height / self.cellSize)

        self.game = GameOfLife(width: gameWidth, height: gameHeight)
        self.game.randomizeCells()
        self.game.step()
        
        self.transitionProportion = 0.0
        self.transitionState = .cellsBorn
        
        super.init(frame: frame, isPreview: isPreview)

        self.animationTimeInterval = 1.0 / GameOfLifeScreenSaverView.frameRate
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.game.mapCells { x, y, cell in
            let cellRect = NSRect(
                x: floor(CGFloat(x) * self.cellSize),
                y: floor(CGFloat(y) * self.cellSize),
                width: ceil(self.cellSize),
                height: ceil(self.cellSize)
            )

            let cellColor = self.color(forCell: cell)
            cellColor.setFill()
            cellRect.fill()
        }
    }
    
    override func animateOneFrame() {
        self.transitionProportion += self.transitionProportionIncrement
        
        if self.transitionProportion >= 1.0 {
            self.transitionProportion = 0.0
            
            switch self.transitionState {
                case .cellsBorn:
                    self.transitionState = .cellsDying
                case .cellsDying:
                    self.transitionState = .cellsBorn
                    self.game.step()
            }
        }
        
        self.setNeedsDisplay(self.bounds)
    }
    
    private func color(forCell cell: GameOfLifeCellState) -> NSColor {
        guard cell.isTransitioning else {
            if cell.isAlive {
                return GameOfLifeScreenSaverView.livingCellColor
            } else {
                return GameOfLifeScreenSaverView.deadCellColor
            }
        }
        
        if self.transitionState == .cellsBorn && cell == .dying {
            return GameOfLifeScreenSaverView.livingCellColor
        }
        
        if self.transitionState == .cellsDying && cell == .born {
            return GameOfLifeScreenSaverView.livingCellColor
        }

        let startColor: NSColor
        let endColor: NSColor

        if cell == .born {
            startColor = GameOfLifeScreenSaverView.deadCellColor
            endColor = GameOfLifeScreenSaverView.livingCellColor
        } else {
            startColor = GameOfLifeScreenSaverView.livingCellColor
            endColor = GameOfLifeScreenSaverView.deadCellColor
        }

        let progress = self.ease(x: self.transitionProportion)
        
        return NSColor(
            red: startColor.redComponent + ((endColor.redComponent - startColor.redComponent) * CGFloat(progress)),
            green: startColor.greenComponent + ((endColor.greenComponent - startColor.greenComponent) * CGFloat(progress)),
            blue: startColor.blueComponent + ((endColor.blueComponent - startColor.blueComponent) * CGFloat(progress)),
            alpha: 1.0
        )
    }

    private func ease(x: Double) -> Double {
        // https://easings.net/
        return -(cos(Double.pi * x) - 1.0) / 2.0
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
