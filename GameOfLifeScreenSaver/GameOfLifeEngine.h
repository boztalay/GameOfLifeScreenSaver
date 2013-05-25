//
//  GameOfLifeEngine.h
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameOfLifeEngine : NSObject {
    NSInteger* cellGrid;
    
    NSInteger gridWidth;
    NSInteger gridHeight;
}

- (void)initWithGridWidth:(NSInteger)gridWidth andGridHeight:(NSInteger)gridHeight;

- (void)runGeneration;

- (NSInteger)getAgeOfCellAtCoordinate:(NSPoint)cellCoordinate;
- (BOOL)isCellAliveAtCoordinate:(NSPoint)cellCoordinate;

- (NSInteger)getGridWidth;
- (NSInteger)getGridHeight;

@end
