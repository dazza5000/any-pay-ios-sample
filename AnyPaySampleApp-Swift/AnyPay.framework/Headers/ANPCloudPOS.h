//
//  ANPCloudPOS.h
//  AnyPay
//
//  Created by Ankit Gupta on 13/09/18.
//  Copyright © 2018 Dan McCann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANPMeaningfulError, AnyPayTransaction, ANPShadowTransactionRequest;
@interface ANPCloudPOS : NSObject

//@property (nonatomic, copy) NSString *cloudPOSURL;

+ (instancetype)sharedInstance;
- (void)activateTerminal:(AnyPayTerminal *)terminal completionHandler:(void (^)(AnyPayTerminal *terminal, ANPMeaningfulError * _Nullable))completionHandler;
- (void)getTransactions:(AnyPayTerminal *)terminal forReader:(NSString *)connectedReader completionHandler:(void (^)(AnyPayTransaction *transaction, ANPMeaningfulError * _Nullable))completionHandler;
- (void)getTransactions:(AnyPayTerminal *)terminal completionHandler:(void (^)(AnyPayTransaction *transaction, ANPMeaningfulError * _Nullable))completionHandler;
- (void)updateTransaction:(AnyPayTransaction *)transaction terminal:(AnyPayTerminal *)terminal completionHandler:(void (^)(AnyPayTransaction *transaction, ANPMeaningfulError * _Nullable))completionHandler;
- (void)acceptTransaction:(AnyPayTransaction *)transaction terminal:(AnyPayTerminal *)terminal completionHandler:(void (^)(BOOL success, ANPMeaningfulError * _Nullable))completionHandler;
- (void)submitDeviceInfo:(NSDictionary *)readerInfo terminal:(AnyPayTerminal *)terminal completionHandler:(void (^)(BOOL success, ANPMeaningfulError * _Nullable))completionHandler;
- (void)shadowTransaction:(ANPShadowTransactionRequest *)shadowTransaction terminal:(AnyPayTerminal *)terminal shadowApiUrl:(NSString *)url completionHandler:(void (^)(BOOL success, ANPMeaningfulError * _Nullable))completionHandler;

@end
