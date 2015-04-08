//
//  UserInfo.m
//  GCN Combine
//
//  Created by Debi Samantrai on 06/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "UserInfo.h"
#import "Macros.h"

@implementation UserInfo
@synthesize m_cObjUserIdPtr,m_cObjPasswordPtr,isLoginSucceed,m_cObjLastTimeDownloaded;
@synthesize m_cObjFirstNamePtr,m_cObjIdentifierPtr,m_cObjLastNamePtr;
@synthesize m_cIsAddedinOfflineMode;

-(id)init
{
    if(self = [super init])
       {
           m_cObjUserIdPtr          = (NSString *)nil;
           m_cObjPasswordPtr        = (NSString *)nil;
           isLoginSucceed           = NO;
           m_cObjLastTimeDownloaded = (NSString *)nil;
           m_cObjFirstNamePtr  = (NSString *)nil;
           m_cObjLastNamePtr   = (NSString *)nil;
           m_cObjIdentifierPtr = (NSString *)nil;
           m_cIsAddedinOfflineMode = NO;
        }
       return self;
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjUserIdPtr)
    SAFE_RELEASE(m_cObjPasswordPtr)
    
    SAFE_RELEASE(m_cObjLastTimeDownloaded)
    SAFE_RELEASE(m_cObjFirstNamePtr)
    SAFE_RELEASE(m_cObjLastNamePtr)
    SAFE_RELEASE(m_cObjIdentifierPtr)
    
    [super dealloc];
}

@end
