//
//  BBMMTextField.swift
//  BBMMKeyBoard
//
//  Created by LiYuhuan on 16/11/15.
//  Copyright © 2016年 LiYuhuan. All rights reserved.
//

import UIKit

public class BBMMTextField: UITextField {

    private lazy var  placeHoldLabel  = UILabel()
    
    //keyboarddidchangeframe callback
    var callBackKeyboardDidChangeFrame:((keyboardBeginFrame:CGRect,keyboardEndFrame:CGRect,changeDuration : NSTimeInterval   )->())?
    var callBackKeyboardDidShow : ( (notification : NSNotification) -> ())?
    
    var callBackKeyboardDidHide : ( (notification : NSNotification) -> ())?
    
 
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setPlaceHoldTextUI()
        addObserverKeyboardDidChange()
        print(" init(frame:CGRect)")
    }
    

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("aDecoder")
        setPlaceHoldTextUI()
        addObserverKeyboardDidChange()
    }
    
   
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
//MARK:-设置textview占位控件
extension BBMMTextField{
    
    func setPlaceHoldTextUI () {
        placeHoldLabel.font = self.font
        placeHoldLabel.frame = CGRectMake(10, 0, self.frame.size.width, 33)
        placeHoldLabel.textColor = UIColor.lightGrayColor()
        placeHoldLabel.text = "在此输入内容..."
        self.addSubview(placeHoldLabel)
        receiveTextChangeNotification()
    }
    
}
// MARK:- 设置展位属性
extension BBMMTextField {
    
    func setPlaceHoldTextAttribute (color:UIColor? , font:UIFont?) {
        
        self.placeHoldLabel.textColor = color ?? UIColor.lightGrayColor()
        self.placeHoldLabel.font = font ?? self.font
    }
    
    func setPlaceHolderText (placeHolderContext:String?) {
        
        self.placeHoldLabel.text = placeHolderContext
    }
    
}

// MARK:- 添加监听
extension BBMMTextField {
    
    private func receiveTextChangeNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"monitorChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
    }
    @objc private func  monitorChange(nofy:NSNotification){
        //print(nofy)
        self.placeHoldLabel.hidden = self.hasText()
        
    }
    
}

// MARK:- 键盘监听
extension BBMMTextField {
    
    private func addObserverKeyboardDidChange(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidChangeFrameNotification:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShowNotification:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHideNotification:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    //键盘推下通知
    @objc private func keyboardDidHideNotification(notification:NSNotification) {
        if callBackKeyboardDidHide != nil {
            
            callBackKeyboardDidHide!(notification: notification)
            
        }
    }
    
    //键盘弹出通知
    @objc private func keyboardDidShowNotification(notification:NSNotification){
        
        if callBackKeyboardDidShow != nil {
            
            callBackKeyboardDidShow!(notification: notification)
            
        }
        
    }
    
    //键盘frame 改变通知 包含键盘frame改变涉及的时间、和开始frame 结束frame
    @objc private func keyboardDidChangeFrameNotification(notification:NSNotification){
        
        if  callBackKeyboardDidChangeFrame != nil {
            
            let bgChangeFrame =  (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectZero
            let enChangeFrame =  (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectZero
            let durationk = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
            
            callBackKeyboardDidChangeFrame!( keyboardBeginFrame: bgChangeFrame, keyboardEndFrame: enChangeFrame, changeDuration: durationk)
        }
    }
    
}