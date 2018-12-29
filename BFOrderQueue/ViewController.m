//
//  ViewController.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/9/17.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "ViewController.h"
#import "BFOrderAssistant.h"
#import "BFNetworkOrderAssistant.h"
#import "BFSOrderAssistant.h"
#import "OrderAssisantSample.h"

@interface ViewController ()
@property (nonatomic, strong) BFOrderAssistant *orderAssistant;
@property (nonatomic, strong) BFSOrderAssistant *orderAssistant2;
@property (nonatomic, strong) OrderAssisantSample *orderAssistant3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testOrderAssistant];
//    [self testOrderAssistant2];
    [self testOrderAssistant3];
}

- (void)testOrderAssistant {

    self.orderAssistant = [BFNetworkOrderAssistant assistant];
    for (int i = 0; i < 10; i++) {
        BFOrderItem *orderItem = [BFOrderItem order];
        orderItem.orderType = BFOrderTypeNetwork;
        orderItem.orderPrority = i % 4;
        orderItem.testIndex = i;
        orderItem.taskBlock = ^{
            NSLog(@"执行具体任务内容");
        };

        [self.orderAssistant addOrder:orderItem];
    }
    NSLog(@"添加完成所有指令");
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.orderAssistant cancelAllOrders];
        NSLog(@"取消了所有任务");
    }];
}

//- (void)testOrderAssistant {
//
//    self.orderAssistant = [BFOrderAssistant assistant];
//    for (int i = 0; i < 10; i++) {
//        BFOrderItem *orderItem = [BFOrderItem order];
//        orderItem.orderType = BFOrderTypeNetwork;
//        orderItem.orderPrority = i % 4;
//        orderItem.testIndex = i;
//
//        [self.orderAssistant addOrder:orderItem];
//    }
//    NSLog(@"添加完成所有指令");
//}

- (void)testOrderAssistant2 {
    
    self.orderAssistant2 = [BFSOrderAssistant assistant];
    for (int i = 0; i < 10; i++) {
        BFSOrderItem *orderItem = [BFSOrderItem order];
        orderItem.orderType = BFSOrderTypeNetwork;
        orderItem.orderPrority = i % 4;
        orderItem.testIndex = i;
        orderItem.taskBlock = ^{
            NSLog(@"执行具体任务内容");
        };
        
        [self.orderAssistant2 addOrder:orderItem];
    }
    NSLog(@"添加完成所有指令");
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.orderAssistant2 cancelAllOrders];
        NSLog(@"取消了所有任务");
    }];
}

- (void)testOrderAssistant3 {
    
    self.orderAssistant3 = [OrderAssisantSample assistant];
    for (int i = 0; i < 10; i++) {
        BFSOrderItem *orderItem = [BFSOrderItem order];
        orderItem.orderType = BFSOrderTypeNetwork;
        orderItem.orderPrority = i % 4;
        orderItem.testIndex = i;
        orderItem.taskBlock = ^{
            NSLog(@"执行具体任务内容");
        };
        
        [self.orderAssistant3 addOrder:orderItem];
    }
    NSLog(@"添加完成所有指令");
}


@end
