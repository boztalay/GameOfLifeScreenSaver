//
//  GameOfLifeEngine.m
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import "GameOfLifeEngine.h"

@implementation GameOfLifeEngine

- (void)initWithGridWidth:(NSInteger)_gridWidth andGridHeight:(NSInteger)_gridHeight
{
    gridWidth = _gridWidth;
    gridHeight = _gridHeight;
}

- (void)runGeneration
{
    
}

- (NSInteger)getAgeOfCellAtCoordinate:(NSPoint)cellCoordinate
{
    return 0;
}

- (BOOL)isCellAliveAtCoordinate:(NSPoint)cellCoordinate
{
    return NO;
}

- (NSInteger)getGridWidth
{
    return gridWidth;
}

- (NSInteger)getGridHeight
{
    return gridHeight;
}

@end
