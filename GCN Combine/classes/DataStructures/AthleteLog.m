//
//  AthleteLog.m
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AthleteLog.h"
#import "AppDelegate.h"
#import "Macros.h"

@implementation AthleteLog


@synthesize m_cObjAthleteIdPtr,m_cObjTestResultPtr,m_cObjCombineId,m_cObjTestId,m_cIsAddedinOfflineMode;

-(id)init
{
    self = [super init];
    if (self) {
 
        m_cIsAddedinOfflineMode     =  NO;
        m_cObjTestId                = -1;
        m_cObjAthleteIdPtr          = (NSString *)nil;
        m_cObjCombineId             = -1;
        m_cObjTestResultPtr         = (NSString *)nil;
        
    }
    return self;
}
-(void)dealloc
{
   
    SAFE_RELEASE(m_cObjAthleteIdPtr)
    SAFE_RELEASE(m_cObjTestResultPtr)
    
    [super dealloc];
}
@end
