//
//  ViewController.swift
//  GameOfLifeScreenSaverTestApp
//
//  Created by Ben Oztalay on 10/23/20.
//

import Cocoa

class ViewController: NSViewController {
    
    private var screenSaverView: GameOfLifeScreenSaverView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenSaverView = GameOfLifeScreenSaverView(frame: self.view.bounds, isPreview: false)!
        self.view.addSubview(screenSaverView)
    }
    
    override func viewDidAppear() {
        self.screenSaverView.startAnimation()
    }
}
