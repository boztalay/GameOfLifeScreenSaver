//
//  GameOfLifeScreenSaverView.m
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import "BOZGameOfLifeScreenSaverView.h"

@implementation BOZGameOfLifeScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/2.0];
        
        gridSizeCalculator = [[BOZGameOfLifeGridSizeCalculator alloc] initWithViewFrame:frame];
        
        gameOfLife = [[BOZGameOfLifeEngine alloc] initWithGridSizeCalculator:gridSizeCalculator];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    NSBezierPath* rectPath;
    NSRect squareRect;
    
    for(int y = 0; y < [gameOfLife getGridHeight]; y++) {
        for(int x = 0; x < [gameOfLife getGridWidth]; x++) {
            squareRect = NSMakeRect((CGFloat)x * [gridSizeCalculator cellSizeInPoints], (CGFloat)y * [gridSizeCalculator cellSizeInPoints], [gridSizeCalculator roundedCellSizeInPoints], [gridSizeCalculator roundedCellSizeInPoints]);
            rectPath = [NSBezierPath bezierPathWithRect:squareRect];
            
            if([gameOfLife isCellAliveAtX:x andY:y]) {
                [[NSColor whiteColor] set];
            } else {
                [[NSColor blackColor] set];
            }
            
            [rectPath fill];
        }
    }
    
    [gameOfLife runGeneration];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
