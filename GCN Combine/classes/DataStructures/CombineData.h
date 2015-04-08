//
//  CombineData.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/02/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CombineData : NSObject
{
//    NSString        *m_cObjCombineIDPtr;
    NSInteger       m_cObjCombineId;
    NSString        *m_cObjCombineName;
    NSString        *m_cObjTournamentName;
    NSString        *m_cObjEndDate;
    NSString        *m_cObjStartDate;
    NSString        *m_cObjStatusPtr;
    NSInteger       sportstype;
}

//@property (nonatomic,copy)    NSString        *m_cObjCombineIDPtr;
@property (nonatomic,assign)  NSInteger       m_cObjCombineId;
@property (nonatomic,copy)    NSString        *m_cObjCombineName;
@property (nonatomic,copy)    NSString        *m_cObjTournamentName;
@property (nonatomic,copy)    NSString        *m_cObjEndDate;
@property (nonatomic,copy)    NSString        *m_cObjStartDate;
@property (nonatomic,copy)    NSString        *m_cObjStatusPtr;
@property (nonatomic,assign)    NSInteger       sportstype;
@end
