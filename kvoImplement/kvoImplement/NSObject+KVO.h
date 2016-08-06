//
//  NSObject+KVO.h
//  响应式编程kvo
//
//  Created by pro on 16/8/4.
//  Copyright © 2016年 贾建兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)


NS_ASSUME_NONNULL_BEGIN




- (void)JJX_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

NS_ASSUME_NONNULL_END

@end
