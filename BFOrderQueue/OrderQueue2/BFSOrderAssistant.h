//
//  BFSOrderAssistant.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFSOrderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFSOrderAssistant : NSObject

@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

+ (instancetype)assistant;
- (BOOL)addOrder:(BFSOrderItem *)order;
- (void)cancelAllOrders;

//- (NSObject *)synchronizeExecuteOrder:(BFSOrderItem *)order;

@end

NS_ASSUME_NONNULL_END
