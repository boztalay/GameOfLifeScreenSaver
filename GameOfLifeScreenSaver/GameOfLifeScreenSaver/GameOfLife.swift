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
    private(set) var cells: [[Bool]]
    
    private var scratch: [[Bool]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.cells = Array(repeating: Array(repeating: false, count: self.height), count: self.width)
        self.scratch = Array(repeating: Array(repeating: false, count: self.height), count: self.width)
    }
    
    func randomizeCells(with proportionAlive: Double) {
        for x in 0 ..< self.width {
            for y in 0 ..< self.height {
                self.cells[x][y] = (Double.random(in: 0.0 ..< 1.0) < proportionAlive)
            }
        }
    }
    
    func step() {
        for x in 0 ..< self.width {
            for y in 0 ..< self.height {
                let livingNeighbors = self.livingNeighbors(ofCellAtX: x, cellY: y)
                
                if self.cells[x][y] {
                    if livingNeighbors < 2 || livingNeighbors > 3 {
                        self.scratch[x][y] = false
                    } else {
                        self.scratch[x][y] = true
                    }
                } else {
                    if livingNeighbors == 3 {
                        self.scratch[x][y] = true
                    } else {
                        self.scratch[x][y] = false
                    }
                }
            }
        }
        
        self.cells = self.scratch
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
