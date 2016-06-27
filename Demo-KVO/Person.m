//
//  Person.m
//  Demo-KVO
//
//  Created by 郭彬 on 16/6/14.
//  Copyright © 2016年 walker. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"num"]) {
        NSLog(@"keyPath = %@, object = %@ , change = %@, context = %@", keyPath, object, change, context);
        NSInteger newNum = [change[NSKeyValueChangeNewKey] integerValue];
        //监听新值等于3，改变背景颜色
        if (newNum == 3) {
            NSLog(@"进入到了%@类的方法",[self class]);
        }
    }
}

@end
