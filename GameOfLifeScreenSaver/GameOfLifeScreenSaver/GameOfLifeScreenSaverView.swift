//
//  GameOfLifeScreenSaverView.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/23/20.
//

import ScreenSaver

class GameOfLifeScreenSaverView: ScreenSaverView {
    
    private static let targetCellSize: CGFloat = 50.0
    private static let gameStepPeriod: CGFloat = 4.25

    private var game: GameOfLife
    private var cellViews: [[CellView]]

    override init?(frame: NSRect, isPreview: Bool) {
        // TODO: This is disgusting
        var gameWidth: Int?
        var gameHeight: Int?
        var cellSize: CGFloat?
        
        let initialGameWidth = Int(ceil(frame.width / GameOfLifeScreenSaverView.targetCellSize))

        for i in 0 ..< initialGameWidth {
            let gameWidthCandidate = initialGameWidth - i
            cellSize = frame.width / CGFloat(gameWidthCandidate)
            let gameHeightCandidate = Int(frame.height / cellSize!)
            
            let gameAspectRatio = Double(gameWidthCandidate) / Double(gameHeightCandidate)
            let frameAspectRatio = Double(frame.width / frame.height)
            
            let aspectRatioDelta = abs(frameAspectRatio - gameAspectRatio)
            if aspectRatioDelta < 0.01 {
                gameWidth = gameWidthCandidate
                gameHeight = gameHeightCandidate
                break
            }
        }

        self.game = GameOfLife(width: gameWidth!, height: gameHeight!)
        self.game.randomizeCells()
        self.game.step()
        
        self.cellViews = Array(repeating: [], count: gameWidth!)
        
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = Double(GameOfLifeScreenSaverView.gameStepPeriod)

        self.game.mapCells { x, y, _ in
            let frame = NSRect(
                x: CGFloat(x) * cellSize!,
                y: CGFloat(y) * cellSize!,
                width: cellSize!,
                height: cellSize!
            )
            
            let cellView = CellView(frame: frame, stepPeriod: GameOfLifeScreenSaverView.gameStepPeriod)
            self.addSubview(cellView)

            self.cellViews[x].append(cellView)
        }
    }

    override func makeBackingLayer() -> CALayer {
        let layer = super.makeBackingLayer()
        layer.backgroundColor = CellView.deadColor
        return layer
    }
    
    override func animateOneFrame() {
        self.game.mapCells { x, y, cell in
            self.cellViews[x][y].update(cell: cell)
        }

        self.game.step()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
