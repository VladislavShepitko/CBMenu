//
//  ViewController.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/19/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*
    let numberOfSegments:Int = 3
    let angle:Double = 100.0
    
    let segmentOffset:Double = 100
    */
    
    lazy var menu:CBMenu! = {
        let animator = CBMenuCircularAnimator()
        let m = CBMenu(withDataSource: self, delegate: self,animator: animator)
        return m
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.wheelStarter.addTarget(self, action: "buttonTap:", forControlEvents: .TouchUpInside)
        //self.backgroundView.userInteractionEnabled = true
        print("view did load")
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        self.view.addSubview(self.menu)
        
        
        //make button's constraint
        let centerX = NSLayoutConstraint(item: self.menu, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: self.menu, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let width = self.menu.widthAnchor.constraintEqualToConstant(300)
        let height = self.menu.heightAnchor.constraintEqualToConstant(30)
        //self.menu.layer.anchorPoint = CGPoint(x: 0.15, y: 0.15)
        self.view.addConstraints([centerX,centerY,width,height])
        print("sasd")
        
        self.menu.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController:CBMenuDataSource, CBMenuDelegate {
    func sizeForSegments() -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    func sizeForMenuButton()->CGSize
    {
        return CGSize(width: 32, height: 32)
    }
    func imagesForMenuButtonStates() -> ToggleImages
    {
        return (UIImage(named: "008-mark-1")!,UIImage(named: "002-mark")!)
    }
    
    func numberOfSegments() -> Int
    {
        return 4
    }
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
    {
        return (UIImage(named: "003-like-1")!,UIImage(named: "007-like")!)
    }
}

