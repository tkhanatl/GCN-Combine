//
//  Login.h
//  GCN Combine
//
//  Created by Debi Samantrai on 06/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString  *m_cObjUserIdPtr;
    NSString  *m_cObjPasswordPtr;
    BOOL      isLoginSucceed;
    NSString  *m_cObjLastTimeDownloaded;
    NSString  *m_cObjFirstNamePtr;
    NSString  *m_cObjLastNamePtr;
    NSString  *m_cObjIdentifierPtr;
    BOOL       m_cIsAddedinOfflineMode;
    
}
@property (nonatomic)       BOOL       m_cIsAddedinOfflineMode;
@property (nonatomic,copy)  NSString  *m_cObjFirstNamePtr;
@property (nonatomic,copy)  NSString  *m_cObjLastNamePtr;
@property (nonatomic,copy)  NSString  *m_cObjIdentifierPtr;
@property (nonatomic,copy)  NSString  *m_cObjUserIdPtr;
@property (nonatomic,copy)  NSString  *m_cObjPasswordPtr;
@property (nonatomic)       BOOL      isLoginSucceed;
@property (nonatomic,copy)  NSString  *m_cObjLastTimeDownloaded;
@end
