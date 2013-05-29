//
//  GameOfLifeScreenSaverView.h
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/24/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "BOZGameOfLifeEngine.h"
#import "BOZGameOfLifeGridSizeCalculator.h"

@interface BOZGameOfLifeScreenSaverView : ScreenSaverView {
    BOZGameOfLifeEngine* gameOfLife;
    BOZGameOfLifeGridSizeCalculator* gridSizeCalculator;
}

@end
