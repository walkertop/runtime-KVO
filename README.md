# runtime-KVO
开篇提醒：OC中的KVO及其KVO的基础知识可参见：[深入runtime探究KVO](http://www.jianshu.com/p/e3024286c06f)
## Swift中，原本没有KVO模式，为何这么说，请看下文：

KVO本质上是基于`runtime`的动态分发机制，通过`key`来监听`value`的值。
OC能够实现监听因为都遵守了`NSKeyValueCoding`协议
OC所有的类都是继承自`NSObject`，其默认已经遵守了该协议，但Swift不是基于`runtime`的， Swift 中的属性处于性能等方面的考虑默认是关闭动态分发的，只有在属性前加 `dynamic`才会开启运行时，允许监听属性的变化。



### KVO在OC和Swift中的区别：
OC中，所有的类继承自 `NSObject` ，它对 KVO提供了默认实现,但Swift不是。
原因有二：
#### 第一：Swift 中继承自`NSObject`的属性处于性能等方面的考虑，默认是关闭动态分发的， 所以无法使用KVO，不过可以在属性前加上`dynamic`来打开。

```
class Person：NSObject {
//name不支持KVO监听，age支持KVO
var name: String
dynamic var age: Int = 0			

init(name: String,age: Int) {
    self.name = name
    self.age =age
}
```
#### 第二： 不是所有的类都继承自`NSObject`,不继承自的对象
譬如：

```
class Person {
var name: String?
var age: Int = 0

init(name: String,age: Int) {
	self.name = name
	self.age =age
}
```
该类根本无法调用

```
  open func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?)
```
方法，所以肯定无法使用KVO观察者模式，但Swift中提供了属性观察器（`didSet`,`willSet`）来解决这种问题；




```
class Father: NSObject {

var firstName: String = "First" {
        willSet {   //新值设置之前被调用
            print("willSet的新值是\(newValue)")
        }
        didSet { //新值设置之后立即调用
            print("didSet的新值是\(oldValue)")
        }
    }
 }
```


## KVO的正常使用：（“三步走”思想）

```
第一步：注册
    open func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?)
    
第二步：监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) 
    
第三步：移除
    open func removeObserver(_ observer: NSObject, forKeyPath keyPath: String)
```

## 代码演示

```

import UIKit

//监听UISlider的滑动，把滑动的结果传递给UIProgressView，以显示滑动进度

class viewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.progressView.addObserver(self, forKeyPath: "progress", options: .new, context: nil)
        self.slider.addObserver(self, forKeyPath: "value", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "value" {
            if let value = change?[NSKeyValueChangeKey.newKey] as? Float {
                self.progressView.progress = value/self.slider.maximumValue
                view.alpha = CGFloat(self.progressView.progress)
                self.textLabel.font = UIFont.systemFont(ofSize: view.alpha * 20)
                self.textField.text = self.father?.firstName
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    deinit {
        self.progressView.removeObserver(self, forKeyPath: "progress")
        self.slider.removeObserver(self, forKeyPath: "value")
    }
}
```
