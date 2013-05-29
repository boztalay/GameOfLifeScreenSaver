//
//  GameOfLifeEngine.m
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import "GameOfLifeEngine.h"

#define BORN_CELL_AGE 0
#define DEAD_CELL_AGE -1

@implementation GameOfLifeEngine

- (id)initWithGridWidth:(int)_gridWidth andGridHeight:(int)_gridHeight
{
    self = [super init];
    if(self) {
        gridWidth = _gridWidth;
        gridHeight = _gridHeight;
        
        [self initializeGrids];
    }
    return self;
}

- (void)initializeGrids
{
    [self allocateGrids];
    [self resetGrids];
    [self seedNewGame];
}

- (void)allocateGrids
{
    gridRowSizeInBytes = gridWidth * sizeof(int*);
    gridColumnSizeInBytes = gridHeight * sizeof(int);
    
    currentCellGrid = malloc(gridRowSizeInBytes);
    lastCellGrid = malloc(gridRowSizeInBytes);
    lastLastCellGrid = malloc(gridRowSizeInBytes);
    
    for(int i = 0; i < gridWidth; i++) {
        currentCellGrid[i] = malloc(gridColumnSizeInBytes);
        lastCellGrid[i] = malloc(gridColumnSizeInBytes);
        lastLastCellGrid[i] = malloc(gridColumnSizeInBytes);
    }
}

- (void)resetGrids
{
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            currentCellGrid[x][y] = DEAD_CELL_AGE;
            lastCellGrid[x][y] = DEAD_CELL_AGE;
            lastLastCellGrid[x][y] = DEAD_CELL_AGE;
        }
    }
}

- (void)seedNewGame
{
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            if((arc4random() % 10) == 0) {
                currentCellGrid[x][y] = BORN_CELL_AGE;
            }
        }
    }
    
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            if([self numberOfLiveNeighborsOfCellAtX:x andY:y inGrid:currentCellGrid] != 0) {
                if((arc4random() % 4) == 0) {
                    currentCellGrid[x][y] = BORN_CELL_AGE;
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
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            if([self isCellAliveAtX:x andY:y] != [self isCellAliveAtX:x andY:y inGrid:lastCellGrid]) {
                return false;
            }
        }
    }
    
    return true;
}

- (BOOL)isTheCurrentGridEqualToTheLastLastGrid
{
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            if([self isCellAliveAtX:x andY:y] != [self isCellAliveAtX:x andY:y inGrid:lastLastCellGrid]) {
                return false;
            }
        }
    }
    
    return true;
}

- (void)copyNewerGridsToOlderGrids
{
    for(int x = 0; x < gridWidth; x++) {
        memcpy(lastLastCellGrid[x], lastCellGrid[x], gridColumnSizeInBytes);
        memcpy(lastCellGrid[x], currentCellGrid[x], gridColumnSizeInBytes);
    }
}

- (void)calculateNextGeneration
{
    for(int x = 0; x < gridWidth; x++) {
        for(int y = 0; y < gridHeight; y++) {
            int numberOfNeighbors = [self numberOfLiveNeighborsOfCellAtX:x andY:y inGrid:lastCellGrid];
            
            if([self isCellAliveAtX:x andY:y inGrid:lastCellGrid]) {
                if(numberOfNeighbors == 2 || numberOfNeighbors == 3) {
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

- (int)numberOfLiveNeighborsOfCellAtX:(int)x andY:(int)y inGrid:(int**)grid
{
    int startX = x - 1 + gridWidth;
    int endX = startX + 3;
    
    int startY = y - 1 + gridHeight;
    int endY = startY + 3;
    
    int liveNeighbors = 0;
    
    for(int neighborX = startX; neighborX < endX; neighborX++) {
        for(int neighborY = startY; neighborY < endY; neighborY++) {
            int limitedNeighborX = (neighborX % gridWidth);
            int limitedNeighborY = (neighborY % gridHeight);
            
            if(limitedNeighborX != x || limitedNeighborY != y) {
                if([self isCellAliveAtX:limitedNeighborX andY:limitedNeighborY inGrid:grid]) {
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
    return [self isCellAliveAtX:x andY:y inGrid:currentCellGrid];
}

- (BOOL)isCellAliveAtX:(int)x andY:(int)y inGrid:(int**)grid
{
    return (grid[x][y] != DEAD_CELL_AGE);
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

- (NSString*)buildGridsString
{
    NSMutableString* gridString = [[NSMutableString alloc] init];
    
    for(int y = gridHeight - 1; y >= 0; y--) {
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", currentCellGrid[x][y] + 1];
        }
        [gridString appendString:@"  "];
        
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", lastCellGrid[x][y] + 1];
        }
        [gridString appendString:@"  "];
        
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", lastLastCellGrid[x][y] + 1];
        }
        [gridString appendString:@"\r\n"];
    }
    
    return gridString;
}

- (NSString*)buildNeighborsString
{
    NSMutableString* gridString = [[NSMutableString alloc] init];
    
    for(int y = gridHeight - 1; y >= 0; y--) {
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", [self numberOfLiveNeighborsOfCellAtX:x andY:y inGrid:currentCellGrid]];
        }
        [gridString appendString:@"  "];
        
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", [self numberOfLiveNeighborsOfCellAtX:x andY:y inGrid:lastCellGrid]];
        }
        [gridString appendString:@"  "];
        
        for(int x = 0; x < gridWidth; x++) {
            [gridString appendFormat:@"%d", [self numberOfLiveNeighborsOfCellAtX:x andY:y inGrid:lastLastCellGrid]];
        }
        [gridString appendString:@"\r\n"];
    }
    
    return gridString;
}

@end
