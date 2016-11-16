# BBMMInput
纯swift代码提供两个类BBMMTextField 和 BBMMTextView 是对 UITextField 和 UITextView 的简单封装。
主要实现对textfield 和 textview增加占位文字。

# Start Wizard 

https://cocoapods.org/pods/BBMMInput

# core mehtod
## 设置占位文字的颜色和字体
 setPlaceHoldTextAttribute (color:UIColor? , font:UIFont?)
## 键盘事件回调 弹出、推下、和 frame chang 等事件的回调
  所有回调采用通知实现，其他小码 可以为其从新设置代理或者通知监听，也可直接使用 BBMMTextField 和 BBMMTextView 自带的键盘事件回调
  ### 键盘 UIKeyboardDidChangeFrame
   callBackKeyboardDidChangeFrame:((keyboardBeginFrame:CGRect,keyboardEndFrame:CGRect,changeDuration : NSTimeInterval   )->())?
   
   ### 键盘 UIKeyboardDidShow
    var callBackKeyboardDidShow : ( (notification : NSNotification) -> ())?
    
    ### 键盘 UIKeyboardDidHide
    var callBackKeyboardDidHide : ( (notification : NSNotification) -> ())?
