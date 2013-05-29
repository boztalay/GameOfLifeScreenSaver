//
//  BOZGameOfLifeGridSizeCalculator.h
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/29/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOZGCD.h"

@interface BOZGameOfLifeGridSizeCalculator : NSObject {
    int gridWidthInCells;
    int gridHeightInCells;
    
    CGFloat cellSizeInPoints;
    CGFloat roundedCellSizeInPoints;
}

- (id)initWithViewFrame:(NSRect)frame;

- (int)gridWidthInCells;
- (int)gridHeightInCells;

- (CGFloat)cellSizeInPoints;
- (CGFloat)roundedCellSizeInPoints;

@end
