//
//  GameOfLife.swift
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 10/24/20.
//

import Foundation

class GameOfLife {
    
    private(set) var width: Int
    private(set) var height: Int

    private var cells: [[Bool]]
    private var nextCells: [[Bool]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.cells = Array(repeating: Array(repeating: false, count: self.height), count: self.width)
        self.nextCells = Array(repeating: Array(repeating: false, count: self.height), count: self.width)
    }

    func mapCells(block: (Int, Int, Bool, Bool) -> ()) {
        for x in 0 ..< self.width {
            for y in 0 ..< self.height {
                block(x, y, self.cells[x][y], self.nextCells[x][y])
            }
        }
    }
    
    func randomizeCells(with proportionAlive: Double) {
        self.mapCells { x, y, _, _ in
            self.nextCells[x][y] = (Double.random(in: 0.0 ..< 1.0) < proportionAlive)
        }
    }

    func step() {
        self.cells = self.nextCells
        
        self.mapCells { x, y, cell, _ in
            let livingNeighbors = self.livingNeighbors(ofCellAtX: x, cellY: y)
            var nextCell = false
            
            if cell {
                if livingNeighbors >= 2 && livingNeighbors <= 3 {
                    nextCell = true
                }
            } else {
                if livingNeighbors == 3 {
                    nextCell = true
                }
            }
            
            self.nextCells[x][y] = nextCell
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
                
                if self.cells[wrappedX][wrappedY] {
                    aliveCount += 1
                }
            }
        }
        
        return aliveCount
    }
}
