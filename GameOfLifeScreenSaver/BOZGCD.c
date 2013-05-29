//
//  BOZGCD.c
//  GameOfLifeScreenSaver
//
//  Created by Ben Oztalay on 5/29/13.
//  Copyright (c) 2013 Ben Oztalay. All rights reserved.
//

int gcd(int m, int n) {
    int t, r;
    
    if (m < n) {
        t = m;
        m = n;
        n = t;
    }
    
    r = m % n;
    
    if (r == 0) {
        return n;
    } else {
        return gcd(n, r);
    }
}