//
//  ViewController.swift
//  GameOfLifeScreenSaverTestApp
//
//  Created by Ben Oztalay on 10/23/20.
//

import Cocoa

class ViewController: NSViewController {
    
    private static let totalGenerationCount = 30
    
    private var screenSaverView: GameOfLifeScreenSaverView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenSaverView = GameOfLifeScreenSaverView(frame: self.view.bounds, isPreview: false, totalGenerationCount: ViewController.totalGenerationCount + 2)!
        self.view.addSubview(screenSaverView)
    }
    
    override func viewDidAppear() {
        self.screenSaverView.animationTimeInterval = 1000
        self.screenSaverView.startAnimation()
        
        for _ in 0 ..< ViewController.totalGenerationCount {
            self.screenSaverView.animateOneFrame()
        }
    }
}
