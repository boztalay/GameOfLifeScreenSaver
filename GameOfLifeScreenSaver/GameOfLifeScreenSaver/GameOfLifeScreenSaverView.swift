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
    
    private var game: GameOfLife

    override init?(frame: NSRect, isPreview: Bool) {
        let width = Int(Int(frame.width) + GameOfLifeScreenSaverView.cellSize) / GameOfLifeScreenSaverView.cellSize
        let height = Int(Int(frame.height) + GameOfLifeScreenSaverView.cellSize) / GameOfLifeScreenSaverView.cellSize
        self.game = GameOfLife(width: width, height: height)
        self.game.randomizeCells(with: GameOfLifeScreenSaverView.initialProportionAlive)
        
        super.init(frame: frame, isPreview: isPreview)

        self.animationTimeInterval = 1.0
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let horizontalOffset = (self.frame.width - CGFloat(self.game.width * GameOfLifeScreenSaverView.cellSize)) / 2.0
        let verticalOffset = (self.frame.height - CGFloat(self.game.height * GameOfLifeScreenSaverView.cellSize)) / 2.0

        for x in 0 ..< self.game.width {
            for y in 0 ..< self.game.height {
                let cellRect = NSRect(
                    x: CGFloat(x * GameOfLifeScreenSaverView.cellSize) + horizontalOffset,
                    y: CGFloat(y * GameOfLifeScreenSaverView.cellSize) + verticalOffset,
                    width: CGFloat(GameOfLifeScreenSaverView.cellSize),
                    height: CGFloat(GameOfLifeScreenSaverView.cellSize)
                )

                if self.game.cells[x][y] {
                    NSColor.white.setFill()
                } else {
                    NSColor.black.setFill()
                }

                cellRect.fill()
            }
        }
    }
    
    override func animateOneFrame() {
        self.game.step()
        self.setNeedsDisplay(self.bounds)
    }
    
    override var hasConfigureSheet: Bool {
        return false
    }
    
    override var configureSheet: NSWindow? {
        return nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
