//
//  ViewController.m
//  Demo-KVO
//
//  Created by 郭彬 on 16/6/14.
//  Copyright © 2016年 walker. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property(nonatomic,assign)NSInteger num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc]init];
    p.name = @"张三";
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    //KVO的原理是监听set方法，默认属性的方法不会监听
    
//    p.name = @"李四";
//    [p setName:@"haha"];
//    p->_name = @"lisi";

    _num = 1;
    /**
     *  [被监听(观察)者
        addObserver:监听(观察)者 
        forKeyPath:监听属性 
        options: 监听到属性改变之后, 传递什么值 
        context:传递的参数];
     */
    
    // 给p这个对象添加一个监听, 监听p对象的age属性的改变, 只要age属性改变就通知self，执行self中的监听方法
    p.age = 18;
    [p addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    p.age = 20;
    
    // 给p这个对象添加一个监听, 监听p对象的age属性的改变, 只要age属性改变就通知self，执行self中的监听方法
    [self addObserver:p forKeyPath:@"num" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

    self.num = 3;
    _num = 2;
    
    //一定要移除对象
    [p removeObserver:self forKeyPath:@"name"];
    [self removeObserver:p forKeyPath:@"num"];
    [p removeObserver:self forKeyPath:@"age"];
}

/**
 *  实现监听方法,只有监听的属性变化才会执行该方法
 *
 *  @param keyPath 被监听的属性名称
 *  @param object  被监听的对象
 *  @param change  这个字典保存了变更信息,具体是哪些信息取决于注册时的 NSKeyValueObservingOptions
 *  @param context 注册监听的时候传入的值
 */

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"name"]) {
    NSLog(@"keyPath = %@, object = %@ , change = %@, context = %@", keyPath, object, change, context);
    }
    
    if ([keyPath isEqualToString:@"age"]) {
        NSLog(@"keyPath = %@, object = %@ , change = %@, context = %@", keyPath, object, change, context);
        NSInteger newAge = [change[NSKeyValueChangeNewKey] integerValue];
        //监听新值等于80，改变背景颜色
        if (newAge == 80) {
            self.view.backgroundColor = [UIColor blueColor];
        }
    }
}

@end
