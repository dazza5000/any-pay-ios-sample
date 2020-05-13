//
//  ANPPriorityPaymentsEndpoint.h
//  AnyPay
//
//  Created by Ankit Gupta on 29/07/18.
//  Copyright © 2018 Dan McCann. All rights reserved.
//

#import "AnyPayEndpoint.h"

@interface ANPPriorityPaymentsEndpoint : AnyPayEndpoint

@property (nonatomic, copy) NSString *merchantID;
@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

+ (nonnull instancetype)sharedInstance;
- (void)initializeWithConsumerKey:(nonnull NSString *)consumerKey consumerSecret:(nonnull NSString *)consumerSecret merchantID:(nonnull NSString *)merchantID gatewayURL:(nullable NSString *)gatewayURL;

- (void)cancelTransaction:(ANPTransaction *)transaction;

- (void)fetchTransactions:(void (^)(NSArray *))completionHandler;

@end
