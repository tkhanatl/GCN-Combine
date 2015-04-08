//
//  ServerTransactionDelegate.h
//  GCN Combine
//
//  Created by DP Samantrai on 07/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

@protocol ServerTransactionDelegate<NSObject>
- (void)serverTransactionSucceeded;
- (void)serverTransactionFailed;
@optional
- (void)handleAthletDetailDownloadSucceed;
- (void)handleAthletDetailDownloadFailed;
- (void)serverConnectionDidFailWithError;
-(void)photoDownloadSucceed;
-(void)photoDownloadFailed;
-(void)handleCombineListDownloadSucceed;
-(void)handleCombineListDownloadFailed;
-(void)handleCombineTestDownloadSucceed;
-(void)handleCombineTestDownloadFailed;
-(void)photoUploadSucceed;
-(void)photoUploadFailed;
@end
