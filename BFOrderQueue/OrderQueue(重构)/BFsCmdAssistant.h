//
//  BFSOrderAssistant.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFsCmdItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFsCmdAssistant : NSObject

@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

+ (instancetype)assistant;
- (BOOL)addOrder:(BFsCmdItem *)order;
- (void)cancelAllOrders;

- (id)synchronizeExecuteOrder:(BFsCmdItem *)order;
- (void)handOrderResult:(id)result order:(BFsCmdItem *)order;

@end

NS_ASSUME_NONNULL_END
