//
//  GameOfLifeEngine.m
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import "GameOfLifeEngine.h"

#define DEAD_CELL_AGE -1
#define BORN_CELL_AGE 0

@implementation GameOfLifeEngine

- (void)initWithGridWidth:(int)_gridWidth andGridHeight:(int)_gridHeight
{
    gridWidth = _gridWidth;
    gridHeight = _gridHeight;
    
    [self initializeGrids];
}

- (void)initializeGrids
{
    [self allocateGrids];
    [self resetGrids];
    [self seedGrids];
}

- (void)allocateGrids
{
    sizeOfGridInBytes = gridWidth * gridHeight * sizeof(int);
    
    currentCellGrid = malloc(sizeOfGridInBytes);
    lastCellGrid = malloc(sizeOfGridInBytes);
    lastLastCellGrid = malloc(sizeOfGridInBytes);
}

- (void)resetGrids
{
    for(int y = 0; y < gridHeight; y++) {
        for(int x = 0; x < gridWidth; x++) {
            currentCellGrid[x][y] = DEAD_CELL_AGE;
            lastCellGrid[x][y] = DEAD_CELL_AGE;
            lastLastCellGrid[x][y] = DEAD_CELL_AGE;
        }
    }
}

- (void)seedGrids
{
    
}

- (void)runGeneration
{
    [self copyGridsDown];
    
    for(int y = 0; y < gridHeight; y++) {
        for(int x = 0; x < gridWidth; x++) {
            int numberOfNeighbors = [self numberOfLiveNeighborsOfCellAtX:x andY:y];
            
            if([self isCellInLastGridAliveAtX:x andY:y]) {
                if(numberOfNeighbors == 2 && numberOfNeighbors == 3) {
                    currentCellGrid[x][y] = lastCellGrid[x][y] + 1;
                } else {
                    currentCellGrid[x][y] = DEAD_CELL_AGE;
                }
            } else {
                if(numberOfNeighbors == 3) {
                    currentCellGrid[x][y] = BORN_CELL_AGE;
                } else {
                    currentCellGrid[x][y] = DEAD_CELL_AGE;
                }
            }
        }
    }
    
    [self detectBoringGridAndResetIfNecessary];
}

- (void)copyGridsDown
{
    memcpy(lastLastCellGrid, lastCellGrid, sizeOfGridInBytes);
    memcpy(lastCellGrid, currentCellGrid, sizeOfGridInBytes);
}

- (int)numberOfLiveNeighborsOfCellAtX:(int)x andY:(int)y
{
    int startX = x - 1 + gridWidth;
    int endX = startX + 3;
    
    int startY = y - 1 + gridHeight;
    int endY = startY + 3;
    
    int liveNeighbors = 0;
    
    for(int neighborY = startY; neighborY < endY; neighborY++) {
        for(int neighborX = startX; neighborX < endX; neighborX++) {
            if(neighborX != x && neighborY != y) {
                if([self isCellAliveAtX:(neighborX % gridWidth) andY:(neighborY % gridHeight)]) {
                    liveNeighbors++;
                }
            }
        }
    }
    
    return liveNeighbors;
}

- (void)detectBoringGridAndResetIfNecessary
{
    if([self isTheCurrentGridEqualToTheLastGrid] || [self isTheCurrentGridEqualToTheLastLastGrid]) {
        [self resetGrids];
        [self seedGrids];
    }
}

- (BOOL)isTheCurrentGridEqualToTheLastGrid
{
    for(int y = 0; y < gridHeight; y++) {
        for(int x = 0; x < gridWidth; x++) {
            if([self isCellAliveAtX:x andY:y] != [self isCellInLastGridAliveAtX:x andY:y]) {
                return false;
            }
        }
    }
    
    return true;
}

- (BOOL)isTheCurrentGridEqualToTheLastLastGrid
{
    for(int y = 0; y < gridHeight; y++) {
        for(int x = 0; x < gridWidth; x++) {
            if([self isCellAliveAtX:x andY:y] != [self isCellInLastLastGridAliveAtX:x andY:y]) {
                return false;
            }
        }
    }
    
    return true;
}

- (int)getAgeOfCellAtX:(int)x andY:(int)y
{
    return currentCellGrid[x][y];
}

- (BOOL)isCellAliveAtX:(int)x andY:(int)y
{
    return (currentCellGrid[x][y] != DEAD_CELL_AGE);
}

- (BOOL)isCellInLastGridAliveAtX:(int)x andY:(int)y
{
    return (lastCellGrid[x][y] != DEAD_CELL_AGE);
}

- (BOOL)isCellInLastLastGridAliveAtX:(int)x andY:(int)y
{
    return (lastLastCellGrid[x][y] != DEAD_CELL_AGE);
}

- (int)getGridWidth
{
    return gridWidth;
}

- (int)getGridHeight
{
    return gridHeight;
}

- (void)dealloc {
    free(currentCellGrid);
    free(lastCellGrid);
    free(lastLastCellGrid);
    
    [super dealloc];
}

@end
