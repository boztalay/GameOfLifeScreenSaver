//
//  BOZGameOfLifeGridSizeCalculator.m
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/29/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import "BOZGameOfLifeGridSizeCalculator.h"

@implementation BOZGameOfLifeGridSizeCalculator

- (id)initWithViewFrame:(NSRect)frame
{
    self = [super init];
    if(self) {
        CGFloat targetCellSize = 25.0f;
        
        CGFloat largestPossibleCellSize = gcd((int)frame.size.width, (int)frame.size.height);
        cellSizeInPoints = largestPossibleCellSize;
        
        while(abs(cellSizeInPoints - targetCellSize) > (cellSizeInPoints / 2.0f)) {
            cellSizeInPoints = cellSizeInPoints / 2.0f;
        }
        
        gridWidthInCells = (int)(frame.size.width / cellSizeInPoints);
        gridHeightInCells = (int)(frame.size.height / cellSizeInPoints);
        
        roundedCellSizeInPoints = (roundf(cellSizeInPoints * 2.0f) / 2.0f);
    }
    return self;
}

- (int)gridWidthInCells
{
    return gridWidthInCells;
}

- (int)gridHeightInCells
{
    return gridHeightInCells;
}

- (CGFloat)cellSizeInPoints
{
    return cellSizeInPoints;
}

- (CGFloat)roundedCellSizeInPoints
{
    return roundedCellSizeInPoints;
}

@end
