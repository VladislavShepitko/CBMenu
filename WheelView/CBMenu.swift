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


protocol CBMenuDataSource:class {
    func numberOfSegments() -> Int
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
}

protocol CBMenuDelegate:class {
    func sizeForSegments() -> CGSize
    func sizeForMenuButton()->CGSize
    func imagesForMenuButtonStates() -> ToggleImages
}

class CBMenu: UIView {
    
    weak var dataSource:CBMenuDataSource?
    weak var delegate:CBMenuDelegate?
    weak var animator:CBMenuAnimatorDelegate?
    
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
    
    
    lazy private(set) var segmentCount:Int = {
        guard let _dataSource = self.dataSource else {
            return 0
        }
        return _dataSource.numberOfSegments()
        }()
    
    lazy private(set) var segments:[CBMenuItem] = {
        var _segments:[CBMenuItem] = []
        
        if let _dataSource = self.dataSource {
            //create segments
            for item in 0..<self.segmentCount {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let images = _dataSource.imageForSegment(at: indexPath)
                
                var destenationPosition = CGPointZero
                if let _animator = self.animator {
                    destenationPosition = _animator.destenationPositionForSegment(self, at:indexPath)
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
    
    
    lazy var origin:CGPoint = {
        //для того что бы расчитать корректный цента объекта не зависимо от анкор поинта нужно:
        //Расчитать ориджин поинт на основании ширины высоты и анкор поинта,
        //но так как оно найдет только верхний угол обьекта то нужно еще отнять половину ширины и высоты
        let pos = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x - self.segmentSize.width / 2.0, self.bounds.size.height * self.layer.anchorPoint.y - self.segmentSize.height / 2.0)
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
    
    //MARK:- segment's tap handler
    func onTapSegment(sender:UIButton){
        onTapShowHideButton(self.showHideButton)
        //delegate function
    }
    func onTapShowHideButton(sender:UIButton){
        if self.isMenuExpanded {
            //hide
            do {
                try self.hideSegments()
            }catch {
                print(error)
            }
        }else {
            //show
            do {
                try self.showSegments()
            }catch {
                print(error)
            }
        }
        self.isMenuExpanded = !self.isMenuExpanded
        print("tap on menu button")
    }
    
    //MARK:-  animation functions
    func showSegments() throws {
        guard let _animator = self.animator else {
            throw CBMenuError.AnimatorNullPointer
        }
        if let willAnimate = _animator.wilShowBackground {
            willAnimate(self, background: self.backgroundView)
        }
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            //Here call delegates function
            if let animateBackground = _animator.showBackground{
                animateBackground(self, background: self.backgroundView)
            }
            
            for (index, segment) in self.segments.enumerate() {
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                if let willShow = _animator.willShowSegment{
                    willShow(self, at: indexPath, segment: segment)
                }
                //perform show animation for each segment
                _animator.showSegment(self, at: indexPath, segment: segment)
                if let didShow = _animator.didShowSegment{
                    didShow(self, at: indexPath, segment: segment)
                }
            }
            }) { (_) -> Void in
                //after all animations is complete we can call comletion func
                if let didShow = _animator.didShowBackground {
                    didShow(self, background: self.backgroundView)
                }
            }
                
        }
        
        func hideSegments()throws {
            guard let _animator = self.animator else {
                throw CBMenuError.AnimatorNullPointer
            }
            if let willAnimate = _animator.wilHideBackground {
                willAnimate(self, background: self.backgroundView)
            }
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                //Here call delegates function
                if let animateBackground = _animator.hideBackground{
                    animateBackground(self, background: self.backgroundView)
                }
                for (index, segment) in self.segments.enumerate() {
                    let indexPath = NSIndexPath(forItem: index, inSection: 0)
                    if let willHide = _animator.willHideSegment{
                        willHide(self, at: indexPath, segment: segment)
                    }
                    
                    _animator.hideSegment(self, at: indexPath, segment: segment)
                    if let didHide = _animator.didHideSegment{
                        didHide(self, at: indexPath, segment: segment)
                    }
                }
                }) { (_) -> Void in
                    //after all animations is complete we can call comletion func
                    if let didHide = _animator.didHideBackground {
                        didHide(self, background: self.backgroundView)
                    }
            }
            
        }
        
        
}

