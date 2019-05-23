//
//  BFSOrderItem.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFsCmdHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFsCmdItem : NSObject

@property (nonatomic, assign) BFSOrderType orderType;
@property (nonatomic, assign) BFsCmdPriority orderPrority;
@property (nonatomic, assign) ItemTaskBlock taskBlock;
@property (nonatomic, assign) ItemResultBlock resultBlock;

@property (nonatomic, assign) NSUInteger testIndex;

#pragma mark - Methods

+ (instancetype)cmdItem;

@end

NS_ASSUME_NONNULL_END
