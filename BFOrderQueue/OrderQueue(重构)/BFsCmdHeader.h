//
//  BFsCmdHeader.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2019/5/23.
//  Copyright © 2019年 BFAlex. All rights reserved.
//

#ifndef BFsCmdHeader_h
#define BFsCmdHeader_h

// 指令渠道
typedef enum {
    BFsCmdTypeUnknow = 0,
    BFsCmdTypeNetwork,
    BFsCmdTypeBluetooth,
} BFSOrderType;
// 指令优先级
typedef enum {
    BFsCmdPriorityLow = 0,
    BFsCmdPriorityNormal,
    BFsCmdPriorityMiddle,
    BFsCmdPriorityHightest,
} BFsCmdPriority;

typedef void (^ItemTaskBlock)(void);
typedef void (^ItemResultBlock)(NSError *error, id result);

#endif /* BFsCmdHeader_h */
