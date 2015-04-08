//
//  Tests.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/02/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import "Tests.h"
#import "Macros.h"

@implementation Tests
@synthesize m_cObjTestAttemptsPtr,m_cObjTestDataTypePtr,m_cObjTestNamePtr,m_cObjTestTypePtr,m_cObjTestResultsPtr,m_cObjCombineId,m_cObjTestId,m_cObjTestSequence;

-(id)init
{
    if (self = [super init]) {
    
        m_cObjTestNamePtr       = (NSString *)nil;
        m_cObjTestTypePtr       = (NSString *)nil;
        m_cObjTestDataTypePtr   = (NSString *)nil;
        m_cObjTestAttemptsPtr   = (NSString *)nil;
        m_cObjTestResultsPtr    = (NSString *)nil;
        m_cObjCombineId         = -1;
        m_cObjTestId            = -1;
        m_cObjTestSequence      = -1;
    }
    return self;
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjTestNamePtr)
    SAFE_RELEASE(m_cObjTestTypePtr)
    SAFE_RELEASE(m_cObjTestDataTypePtr)
    SAFE_RELEASE(m_cObjTestAttemptsPtr)
    SAFE_RELEASE(m_cObjTestResultsPtr)
    
    [super dealloc];
}

@end
