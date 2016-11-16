//
//  BBMMTextView.swift
//  BBMMKeyBoard
//  给UITextView增加 占位文字
//  Created by LiYuhuan on 16/11/13.
//  Copyright © 2016年 LiYuhuan. All rights reserved.
//

import UIKit

public class BBMMTextView: UITextView {

   private lazy var  placeHoldLabel  = UILabel()
    /** 键盘Frame 改变完成 回调 */
   public var callBackKeyboardDidChangeFrame:((keyboardBeginFrame:CGRect,keyboardEndFrame:CGRect,changeDuration : NSTimeInterval   )->())?
    /** 键盘已经弹出回调 */
   public var callBackKeyboardDidShow : ( (notification : NSNotification) -> ())?
    /** 键盘已经隐藏回调 */
    public var callBackKeyboardDidHide : ( (notification : NSNotification) -> ())?
    
    public  init(){
        super.init(frame: CGRectZero, textContainer: nil)
        setPlaceHoldTextUI()
        addObserverKeyboardDidChange()
    }
   
   public init(frame:CGRect){
      super.init(frame: frame, textContainer: nil)
        setPlaceHoldTextUI()
        addObserverKeyboardDidChange()
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setPlaceHoldTextUI()
        addObserverKeyboardDidChange()
        
    }
    
   
   required  public init?(coder aDecoder: NSCoder) {
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
extension BBMMTextView{
  
   private func setPlaceHoldTextUI () {
        placeHoldLabel.font = self.font
        placeHoldLabel.frame = CGRectMake(10, 0, self.frame.size.width, 33)
        placeHoldLabel.textColor = UIColor.lightGrayColor()
        placeHoldLabel.text = "在此输入内容..."
        self.addSubview(placeHoldLabel)
        receiveTextChangeNotification()
    }

}
// MARK:- 设置展位属性
extension BBMMTextView {
 
    /// 设置占位文字的字体颜色 和 字体
    ///
    /// - parameter color   :占位文字颜色
    /// - parameter font    :占位文字字体
    ///
   public func setPlaceHoldTextAttribute (color:UIColor? , font:UIFont?) {
       
        self.placeHoldLabel.textColor = color ?? UIColor.lightGrayColor()
        self.placeHoldLabel.font = font ?? self.font
    }
    
    /// 设置占位文字
    ///
    /// - parameter placeHolderContext   :占位文字字符串
    ///
    
   public  func setPlaceHolderText (placeHolderContext:String?) {
        
        self.placeHoldLabel.text = placeHolderContext
    }

}

// MARK:- 添加文字改变监听
extension BBMMTextView {
 
    private func receiveTextChangeNotification(){
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"monitorChange:", name: UITextViewTextDidChangeNotification, object: nil)
    
    }
    @objc private func  monitorChange(nofy:NSNotification){
        print(nofy)
        self.placeHoldLabel.hidden = self.hasText()
        
    }

}

// MARK:- 键盘监听
extension BBMMTextView {
    
    private func addObserverKeyboardDidChange(){
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidChangeFrameNotification:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShowNotification:", name: UIKeyboardDidShowNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHideNotification:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    /// 键盘已经隐藏通知
    ///
    /// * notification : 通知对象
    ///
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
        //print(notification)
        if  callBackKeyboardDidChangeFrame != nil {
           
            let bgChangeFrame =  (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectZero
             let enChangeFrame =  (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectZero
             let durationk = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
            
            callBackKeyboardDidChangeFrame!( keyboardBeginFrame: bgChangeFrame, keyboardEndFrame: enChangeFrame, changeDuration: durationk)
        }
    }

}