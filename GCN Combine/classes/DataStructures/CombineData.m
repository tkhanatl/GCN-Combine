//
//  CombineData.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/02/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import "CombineData.h"
#import "Macros.h"

@implementation CombineData
//@synthesize m_cObjCombineIDPtr;
@synthesize m_cObjCombineName,m_cObjEndDate,m_cObjStartDate,m_cObjTournamentName,m_cObjStatusPtr;
@synthesize sportstype,m_cObjCombineId;

-(id)init
{
    if (self = [super init])
    {
//        m_cObjCombineIDPtr          = (NSString *)nil;
        m_cObjCombineName           = (NSString *)nil;
        m_cObjEndDate               = (NSString *)nil;
        m_cObjStartDate             = (NSString *)nil;
        m_cObjTournamentName        = (NSString *)nil;
        m_cObjStatusPtr             = (NSString *)nil;
        sportstype                  =  -1;
        m_cObjCombineId             =  -1;
    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(m_cObjStatusPtr)
//    SAFE_RELEASE(m_cObjCombineIDPtr)
    SAFE_RELEASE(m_cObjCombineName)
    SAFE_RELEASE(m_cObjEndDate)
    SAFE_RELEASE(m_cObjStartDate)
    SAFE_RELEASE(m_cObjTournamentName)
//    SAFE_RELEASE(m_cObjCombineIDPtr)
    [super dealloc];
}

@end
