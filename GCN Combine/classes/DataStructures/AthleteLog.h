//
//  AthleteLog.h
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthleteLog : NSObject
{
    BOOL              m_cIsAddedinOfflineMode;
    NSInteger        m_cObjTestId;
    NSString         *m_cObjAthleteIdPtr;
    NSInteger        m_cObjCombineId;
    NSString         *m_cObjTestResultPtr;
}
@property (nonatomic,copy)  NSString         *m_cObjTestResultPtr;
@property (nonatomic,assign)NSInteger        m_cObjTestId;
@property (nonatomic,assign)NSInteger        m_cObjCombineId;
@property (nonatomic,copy)  NSString         *m_cObjAthleteIdPtr;
@property (nonatomic)       BOOL              m_cIsAddedinOfflineMode;




@end
