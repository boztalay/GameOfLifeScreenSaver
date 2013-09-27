//
//  GameOfLifeEngine.h
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOZGameOfLifeGridSizeCalculator.h"

@interface BOZGameOfLifeEngine : NSObject {
    int** currentCellGrid;
    int** lastCellGrid;
    int** lastLastCellGrid;
    
    int gridWidth;
    int gridHeight;
    
    size_t gridRowSizeInBytes;
    size_t gridColumnSizeInBytes;
}

- (id)initWithGridSizeCalculator:(BOZGameOfLifeGridSizeCalculator*)gridSizeCalculator;

- (void)runGeneration;

- (int)getAgeOfCellAtX:(int)x andY:(int)y;
- (BOOL)isCellAliveAtX:(int)x andY:(int)y;

- (int)getGridWidth;
- (int)getGridHeight;

@end