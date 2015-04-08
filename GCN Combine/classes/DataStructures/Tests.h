//
//  Tests.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/02/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tests : NSObject
{
    NSInteger       m_cObjTestId;
    NSInteger       m_cObjCombineId;
    NSString        *m_cObjTestNamePtr;
    NSString        *m_cObjTestTypePtr;
    NSString        *m_cObjTestDataTypePtr;
    NSString        *m_cObjTestAttemptsPtr;
    NSString        *m_cObjTestResultsPtr;
    NSInteger       m_cObjTestSequence;
    
}
@property (nonatomic,assign)NSInteger       m_cObjCombineId;
@property (nonatomic,copy)NSString      *m_cObjTestResultsPtr;
@property (nonatomic,assign)NSInteger       m_cObjTestId;
//@property (nonatomic,copy)NSString      *m_cObjCombineIdPtr;
@property (nonatomic,copy)NSString      *m_cObjTestNamePtr;
@property (nonatomic,copy)NSString      *m_cObjTestTypePtr;
@property (nonatomic,copy)NSString      *m_cObjTestDataTypePtr;
@property (nonatomic,copy)NSString      *m_cObjTestAttemptsPtr;
@property (nonatomic,assign)NSInteger    m_cObjTestSequence;
@end
