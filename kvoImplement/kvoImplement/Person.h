//
//  Person.h
//  响应式编程kvo
//
//  Created by pro on 16/8/4.
//  Copyright © 2016年 贾建兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    @public
    NSString *_name;
}



/* 名称 */
@property (nonatomic, copy) NSString *name;



@end
