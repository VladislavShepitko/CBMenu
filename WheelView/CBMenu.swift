//
//  CBMenu.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/23/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
typealias ToggleImages = (active:UIImage, unactive:UIImage)

enum CBMenuError : ErrorType {
    case AnimatorNullPointer
    
}


protocol CBMenuDataSource {
    func numberOfSegments() -> Int
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
    
}

protocol CBMenuDelegate {
    func sizeForSegments() -> CGSize
    func sizeForMenuButton()->CGSize
    func imagesForMenuButtonStates() -> ToggleImages
}

class CBMenu: UIView {
    
    var dataSource:CBMenuDataSource?
    var delegate:CBMenuDelegate?
    var animator:CBMenuAnimatorDelegate?
    
    lazy var backgroundView:BackgroundView! = {
        let view = BackgroundView(withSuperView: self)
        return view
        }()
    
    lazy var showHideButton:CBMenuItem! = {
        var images = (active:UIImage(), unactive:UIImage())
        if let _delegate = self.delegate {
            images = _delegate.imagesForMenuButtonStates()
        }
        let btn = CBMenuItem(active: images.active, unactive: images.unactive, frame: CGRectZero, onTap: self.onTapShowHideButton)
        return btn
        }()
    
    
    
    //it can be just 4 section. We devide circle for 4 piaces
    private(set) var sectionCount:Int = 1
    
    lazy private(set) var segmentCount:Int = {
        guard let _dataSource = self.dataSource else {
            return 0
        }
        return _dataSource.numberOfSegments()
        }()
    
    lazy private(set) var segments:[CBMenuItem] = {
        var _segments:[CBMenuItem] = []
        
        if let _dataSource = self.dataSource {
            //let angleForEachSection =  /*self.angle */ 90.radians
            //create segments
            for item in 0..<self.segmentCount {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let images = _dataSource.imageForSegment(at: indexPath)
                
                let destenationPosition = CGPointZero
                if let _animator = self.animator {
                    destenationPosition = _animator.destenationPositionForSegment(at indexPath)
                }
                
                let frame = CGRect(origin: destenationPosition, size: self.segmentSize)
                
                let newSegment = CBMenuItem(active: images.active, unactive: images.unactive, frame: frame, onTap: self.onTapSegment)
                let w = newSegment.widthAnchor.constraintEqualToConstant(self.segmentSize.width)
                let h = newSegment.heightAnchor.constraintEqualToConstant(self.segmentSize.height)
                newSegment.addConstraints([w,h])
                
                _segments.append(newSegment)
            }
            
        }
        return _segments
    }()
    
    
    //segments parameters
    lazy private(set) var segmentSize:CGSize =  {
        guard let _delegate = self.delegate else {
            return CGSizeZero
        }
        return _delegate.sizeForSegments()
        }()
    /*
    lazy var radius:Double  = {
    print("self frame: \(self.frame)")
    //print("background frame: \(self.backgroundView.frame)")
    let d = Double((max(self.frame.width, self.frame.height) / 2.0 )) - Double(self.segmentSize.width)
    //print("asdasd \(d)")
    return d
    }()*/
    
    lazy var origin:CGPoint = {
        //для того что бы расщитать корректный цента объекта не зависимо от анкор поинта нужно:
        //Расчитать ориджин поинт на основании ширины высоты и анкор поинта,
        //но так как оно найдет только верхний угол обьекта то нужно еще отнять половину ширины и высоты
        let pos = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x - self.segmentSize.width / 2, self.bounds.size.height * self.layer.anchorPoint.y - self.segmentSize.height / 2)
        //Ну а в итоге конвертировать из своей системы координат в родительскую
        let convertedPos = self.convertPoint(pos, toView: self.superview!)
        
        print("calc origin: \(pos)")
        print("background's origin: \(self.superview!.frame)")
        let bas = CGPoint(x: CGRectGetMidX(self.frame) - self.segmentSize.width / 2,
            y: CGRectGetMidY(self.frame) - self.segmentSize.height / 2)
        print("calc origin: \(pos)")
        print("background's origin: \(bas)")
        
        return convertedPos
        }()
    
    //MARK:- menu parameters
    var isMenuExpanded:Bool = false
    /*
    //MARK:- animation's parameters
    let SHOW_SEGMENTS_ANIMATION_DURATION = 0.4
    let HIDE_SEGMENTS_ANIMATION_DURATION = 0.4
    
    let SHOW_SEGMENTS_ANIMATION_DELAY = 0.0
    let HIDE_SEGMENTS_ANIMATION_DELAY = 0.1*/
    
    //MARK:- initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(withDataSource dataSource:CBMenuDataSource,delegate: CBMenuDelegate, animator:CBMenuAnimatorDelegate, frame: CGRect = CGRectZero){
        self.init(frame: frame)
        self.dataSource = dataSource
        self.delegate = delegate
        self.animator = animator
    }
    
    //Call this method when datasource delegate and frame already initialized, and it can correctly calculate segment's destenation positions
    func setupView(){
        self.layoutIfNeeded()
        //createSegments()
        initializeAdditionlViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeAdditionlViews(){
        func targetToSelfCenter(targetView:UIView) -> (centerX:NSLayoutConstraint, centerY:NSLayoutConstraint) {
            //make button's constraint
            let centerX = targetView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
            let centerY = targetView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
            return (centerX,centerY)
        }
        
        //add button to view and make it's constraints
        self.addSubview(showHideButton)
        var sizeForMenuButton = CGSize(width: 32, height: 32)
        if let _delegate = self.delegate {
            sizeForMenuButton = _delegate.sizeForMenuButton()
        }
        //make button's constraint
        let buttonCenter = targetToSelfCenter(showHideButton)
        
        let buttonWidth = showHideButton.widthAnchor.constraintEqualToConstant(sizeForMenuButton.width)
        let buttonHeight = showHideButton.heightAnchor.constraintEqualToConstant(sizeForMenuButton.height)
        self.addConstraints([buttonCenter.centerX,buttonCenter.centerY,buttonWidth,buttonHeight])
        
        //add gackground view to view and make it's constraints
        //self.insertSubview(backgroundView, belowSubview: showHideButton)
        
        let backgroundCenter = targetToSelfCenter(backgroundView)
        
        let backgroundWidth = backgroundView.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let backgroundHeight = backgroundView.heightAnchor.constraintEqualToAnchor(self.heightAnchor)
        
        self.addConstraints([backgroundCenter.centerX,backgroundCenter.centerY,backgroundWidth,backgroundHeight])
        self.backgroundView.layoutIfNeeded()
    }
    /*
    func createSegments(){
    //set number of items in view
    if let _dataSource = self.dataSource {
    for section in 0..<self.sectionCount{
    let angleForEachSection =  /*self.angle */ 90.radians
    //create segments
    for item in 0..<self.segmentCount {
    let indexPath = NSIndexPath(forItem: item, inSection: section)
    let images = _dataSource.imageForSegment(at: indexPath)
    
    let position = self.pointOnCircle(self.origin, numberOfSegments: self.segmentCount, angle: angleForEachSection, index: item, radius: self.radius)
    
    let frame = CGRect(origin: position, size: self.segmentSize)
    
    let newSegment = CBMenuItem(active: images.active, unactive: images.unactive, frame: frame, onTap: self.onTapSegment)
    let w = newSegment.widthAnchor.constraintEqualToConstant(self.segmentSize.width)
    let h = newSegment.heightAnchor.constraintEqualToConstant(self.segmentSize.height)
    newSegment.addConstraints([w,h])
    self.segments.append(newSegment)
    }
    }
    }
    }*/
    
    //MARK:- segment's tap handler
    func onTapSegment(sender:UIButton){
        onTapShowHideButton(self.showHideButton)
        //delegate function
    }
    func onTapShowHideButton(sender:UIButton){
        if self.isMenuExpanded {
            //hide
            //self.hideSegments()
        }else {
            //show
            //try self.showSegments()
        }
        self.isMenuExpanded = !self.isMenuExpanded
        print("tap on menu button")
    }
    
    //MARK:-  animation functions
    func showSegments() throws {
        guard let _animator = self.animator else {
            throw CBMenuError.AnimatorNullPointer
        }
        for (index, segment) in self.segments.enumerate() {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let willShow = _animator.willShowSegment{
                willShow(at: indexPath, segment: segment)
            }
            _animator.showSegment(at: indexPath, segment: segment)
            if let didShow = _animator.didShowSegment{
                didShow(at: indexPath, segment: segment)
            }
        }
        /*UIView.animateWithDuration(SHOW_SEGMENTS_ANIMATION_DURATION, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
        self.backgroundView.expand()
        }, completion: nil)
        */
        //let angleForEachSection =  /*self.angle */ 90.radians
        
        //let startPoint = self.pointOnCircle(self.origin, numberOfSegments: self.segmentCount, angle: angleForEachSection, index: num, radius: self.radius)
        /*
        for (index,segment) in self.segments.enumerate() {
        //reset segment's origin point
        segment.transform = CGAffineTransformMakeTranslation(self.origin.x, self.origin.y)
        self.backgroundView.addSubview(segment)
        
        UIView.animateWithDuration(SHOW_SEGMENTS_ANIMATION_DURATION, delay: SHOW_SEGMENTS_ANIMATION_DELAY * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
        let destenation = segment.destenationPosition
        segment.transform = CGAffineTransformMakeTranslation(destenation.x, destenation.y)
        segment.alpha = 1
        }, completion: nil)
        }*/
    }
    func hideSegments()throws {
        guard let _animator = self.animator else {
            throw CBMenuError.AnimatorNullPointer
        }
        for (index, segment) in self.segments.enumerate() {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let willHide = _animator.willHideSegment{
                willHide(at: indexPath, segment: segment)
            }
            _animator.hideSegment(at: indexPath, segment: segment)
            if let didHide = _animator.didHideSegment{
                didHide(at: indexPath, segment: segment)
            }
        }
        
        /*
        UIView.animateWithDuration(0.1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { () -> Void in
        }) { (_) -> Void in
        for (index,segment) in self.segments.enumerate() {
        UIView.animateWithDuration(self.HIDE_SEGMENTS_ANIMATION_DURATION, delay: self.HIDE_SEGMENTS_ANIMATION_DELAY * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction, .CurveEaseOut ], animations: { () -> Void in
        segment.transform = CGAffineTransformMakeTranslation(self.origin.x, self.origin.y)
        segment.alpha = 0
        }, completion: {(_)in
        segment.removeFromSuperview()
        })
        }
        }
        */
    }
    
    //MARK:- helper functions
    func pointOnCircle(origin:CGPoint, numberOfSegments:Int, angle:Double,index:Int,radius:Double) -> CGPoint {
        let x = origin.x  - CGFloat(sin(angle / Double(numberOfSegments) * Double(index)) * radius)
        let y = origin.y  - CGFloat(cos(angle / Double(numberOfSegments) * Double(index)) * radius)
        return CGPoint(x: x, y: y)
    }
}

