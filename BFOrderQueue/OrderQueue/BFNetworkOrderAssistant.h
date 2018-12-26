//
//  BFNetworkOrderAssistant.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/11/22.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFOrderAssistant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFNetworkOrderAssistant : BFOrderAssistant

@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

@end

NS_ASSUME_NONNULL_END
