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
    [self seedNewGame];
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

- (void)seedNewGame
{
    for(int i = 0; i < gridWidth; i++) {
        for(int j = 0; j < gridHeight; j++) {
            if((arc4random() % 10) == 0) {
                currentCellGrid[i][j] = BORN_CELL_AGE;
            } else {
                currentCellGrid[i][j] = DEAD_CELL_AGE;
            }
        }
    }
    
    for(int i = 0; i < gridWidth; i++) {
        for(int j = 0; j < gridHeight; j++) {
            if([self numberOfLiveNeighborsOfCellAtX:i andY:j] != 0) {
                if((arc4random() % 4) == 0) {
                    currentCellGrid[i][j] = BORN_CELL_AGE;
                } else {
                    currentCellGrid[i][j] = DEAD_CELL_AGE;
                }
            } else {
                if(currentCellGrid[i][j] == BORN_CELL_AGE) {
                    currentCellGrid[i][j] = BORN_CELL_AGE;
                } else {
                    currentCellGrid[i][j] = DEAD_CELL_AGE;
                }
            }
        }
    }
}

- (void)runGeneration
{
    if([self shouldSeedNewGame]) {
        [self resetGrids];
        [self seedNewGame];
    } else {
        [self copyNewerGridsToOlderGrids];
        [self calculateNextGeneration];
    }
}

- (BOOL)shouldSeedNewGame
{
    return ([self isTheCurrentGridEqualToTheLastGrid] || [self isTheCurrentGridEqualToTheLastLastGrid]);
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

- (void)copyNewerGridsToOlderGrids
{
    memcpy(lastLastCellGrid, lastCellGrid, sizeOfGridInBytes);
    memcpy(lastCellGrid, currentCellGrid, sizeOfGridInBytes);
}

- (void)calculateNextGeneration
{
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
