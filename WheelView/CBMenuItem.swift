//
//  CBMenuItem.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/23/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

typealias ItemCallBack = (sender:UIButton)->()

class TapButton:UIButton {
    private var activeImage:UIImage?
    private var unactiveImage:UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(active:UIImage, unactive:UIImage, frame:CGRect = CGRectZero){
        self.init(frame:frame)
        
        self.activeImage = active
        self.unactiveImage = unactive
        self.addTarget(self, action: "onTap:", forControlEvents: .TouchUpInside)
    }
    func onTap(sender:UIButton){
        if let actImg = self.activeImage, let unactImg = self.unactiveImage {
            if sender.imageView?.image == actImg {
                sender.setImage(unactImg, forState: .Normal)
            }else if sender.imageView?.image == unactImg {
                sender.setImage(actImg, forState: .Normal)
            }
        }
    }
}

class CBMenuItem: UIButton {
    
    private var activeImage:UIImage?
    private var unactiveImage:UIImage?
    private var callBack:ItemCallBack?
    
    private(set) var destenationPosition:CGPoint = CGPointZero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false 
        setupView()

    }
    convenience init(active:UIImage, unactive:UIImage, frame:CGRect, onTap: ItemCallBack) {
        self.init(frame: CGRectZero)
        self.activeImage = active
        self.unactiveImage = unactive
        self.destenationPosition = frame.origin
        self.setImage(unactive, forState: .Normal)
        self.callBack = onTap
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        addTarget(self, action: "onTap:", forControlEvents: .TouchUpInside)
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func onTap(sender:UIButton){
        if let actImg = self.activeImage, let unactImg = self.unactiveImage {
            if sender.imageView?.image == actImg {
                sender.setImage(unactImg, forState: .Normal)
            }else if sender.imageView?.image == unactImg {
                sender.setImage(actImg, forState: .Normal)
            }
        }
        if let cb = callBack {
            cb(sender:sender)
        } 
    }
}
