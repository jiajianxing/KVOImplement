//
//  NSObject+KVO.m
//  响应式编程kvo
//
//  Created by pro on 16/8/4.
//  Copyright © 2016年 贾建兴. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

NSString * const observerKey = @"observer";

@implementation NSObject (KVO)


- (void)JJX_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    /*
     KVO底层实现
     1.自定义NSKVONotifying_Person子类
     2.重写setName,在内部恢复父类做法,通知观察者
     3.如何让外界调用自定义person类的子类方法,修改当前对象的ISA指针,指向NSKVONotifying_Person
     */
    
    [self lowImpletion:keyPath Observer:observer];
    
    
}


- (void)lowImpletion:(NSString *)keyPath Observer:(NSObject *)observer
{
    uint count;
    //拼接set方法字符串
    NSString *setKeyMethod = [NSString stringWithFormat:@"set%@:", [keyPath capitalizedString]];
    
    //找出所有方法
    Method *methodList = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {//遍历所有方法
        
        Method method = methodList[i];
        SEL selMethod = method_getName(method);
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(selMethod)];
        if ([methodName isEqualToString:setKeyMethod]) {//找到set方法,则用自己写的方法交换,用在子类里相当于重写
            
            Method method1 = class_getInstanceMethod([self class], selMethod);
            Method method2 = class_getInstanceMethod([self class], @selector(setvalue:));
            
            method_exchangeImplementations(method1, method2);
            
        }
        
    }
    
    
    //构建子类名称
    NSString *newClassName = [NSString stringWithFormat:@"Notifying_%@", NSStringFromClass([self class])];
    
    //    创建子类
    Class newClass = objc_allocateClassPair(self.class, (__bridge const void *)(newClassName), 0);
    //注册子类
    objc_registerClassPair(newClass);
    
    
    //保存observer
    objc_setAssociatedObject(self, (__bridge const void *)(observerKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //修改ISA指针(将isa指针修改为刚创建的子类)
    object_setClass(self, [newClass class]);

}


- (void)setvalue:(NSString *)value
{
    [self setvalue:value];
    //获得observer
    id observer = objc_getAssociatedObject(self, (__bridge const void *)(observerKey));
    //接受通知发出响应
    [observer observeValueForKeyPath:value ofObject:self change:nil context:nil];
}


@end
