//
//  GameOfLife.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/24/20.
//

import Foundation

enum GameOfLifeCellState {
    case dead
    case alive
    case born
    case dying
    
    var isAlive: Bool {
        return (self == .alive || self == .born)
    }
    
    var isTransitioning: Bool {
        return (self == .born || self == .dying)
    }
}

class GameOfLife {

    private static let initialProportionAlive = 0.3
    
    private(set) var width: Int
    private(set) var height: Int

    private var previousCells: [[GameOfLifeCellState]]
    private var cells: [[GameOfLifeCellState]]
    private var nextCells: [[GameOfLifeCellState]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.previousCells = Array(repeating: Array(repeating: .dead, count: self.height), count: self.width)
        self.cells = Array(repeating: Array(repeating: .dead, count: self.height), count: self.width)
        self.nextCells = Array(repeating: Array(repeating: .dead, count: self.height), count: self.width)
    }

    func mapCells(block: (Int, Int, GameOfLifeCellState) -> ()) {
        for x in 0 ..< self.width {
            for y in 0 ..< self.height {
                block(x, y, self.cells[x][y])
            }
        }
    }
    
    func randomizeCells() {
        self.mapCells { x, y, _ in
            self.nextCells[x][y] = (Double.random(in: 0.0 ..< 1.0) < GameOfLife.initialProportionAlive) ? .born : .dead
        }
    }

    func step() {
        self.previousCells = self.cells
        self.cells = self.nextCells
        
        self.mapCells { x, y, cell in
            let livingNeighbors = self.livingNeighbors(ofCellAtX: x, cellY: y)
            let nextCell: GameOfLifeCellState
            
            if cell.isAlive {
                if livingNeighbors >= 2 && livingNeighbors <= 3 {
                    nextCell = .alive
                } else {
                    nextCell = .dying
                }
            } else {
                if livingNeighbors == 3 {
                    nextCell = .born
                } else {
                    nextCell = .dead
                }
            }
            
            self.nextCells[x][y] = nextCell
        }
        
        if self.isGameStatic() || self.isGameAlternating() {
            self.randomizeCells()
        }
    }
    
    private func livingNeighbors(ofCellAtX cellX: Int, cellY: Int) -> Int {
        var aliveCount = 0
        
        for x in (cellX - 1) ... (cellX + 1) {
            for y in (cellY - 1) ... (cellY + 1) {
                guard x != cellX || y != cellY else {
                    continue
                }
                
                let wrappedX = (x + self.width) % self.width
                let wrappedY = (y + self.height) % self.height
                
                if self.cells[wrappedX][wrappedY].isAlive {
                    aliveCount += 1
                }
            }
        }
        
        return aliveCount
    }
    
    private func isGameStatic() -> Bool {
        return self.areCellGridsEqual(cellsA: self.cells, cellsB: self.previousCells)
    }
    
    private func isGameAlternating() -> Bool {
        return self.areCellGridsEqual(cellsA: self.nextCells, cellsB: self.previousCells)
    }
    
    private func areCellGridsEqual(cellsA: [[GameOfLifeCellState]], cellsB: [[GameOfLifeCellState]]) -> Bool {
        var areEqual = true
        
        self.mapCells { x, y, _ in
            if cellsA[x][y].isAlive != cellsB[x][y].isAlive {
                areEqual = false
            }
        }
        
        return areEqual
    }
}
