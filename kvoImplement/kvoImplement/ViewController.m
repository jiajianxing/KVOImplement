//
//  ViewController.m
//  kvoImplement
//
//  Created by pro on 16/8/6.
//  Copyright © 2016年 贾建兴. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"
@interface ViewController ()


/* model */
@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     KVO底层实现
     1.自定义NSKVONotifying_Person子类
     2.重写setName,在内部恢复父类做法,通知观察者
     3.如何让外界调用自定义person类的子类方法,修改当前对象的ISA指针,指向NSKVONotifying_Person
     */
    
    Person *per = [[Person alloc] init];
    [per JJX_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    _person = per;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"name改变为%@", _person.name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    
    //用成员变量赋值,监听不会触发
    //    _person->_name = [NSString stringWithFormat:@"我是%d", i++];
    _person.name = [NSString stringWithFormat:@"我是%d", i++];
    
}
@end
