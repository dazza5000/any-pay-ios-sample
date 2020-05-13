//
//  AnyPayTransactionBase.h
//  AnyPay
//
//  Created by Ankit Gupta on 14/09/18.
//  Copyright © 2018 Dan McCann. All rights reserved.
//

#import "ANPCloudPOSEntity.h"
#import "ANPTransactionStatuses.h"

@interface AnyPayTransactionBase : ANPCloudPOSEntity

@property (nonatomic, copy) NSString *terminalID;
@property (nonatomic) ANPTransactionStatus status;
@property (nonatomic, copy) NSString *orderID;

@end
