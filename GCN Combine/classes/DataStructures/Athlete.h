//
//  Athlete.h
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Athlete : NSObject
{
    NSString        *m_cObjFirstNamePtr;
    NSString        *m_cObjLastNamePtr;
    NSString        *m_cObjEmailIdPtr;
    NSString       *m_cObjPhoneNumberPtr;
    NSString        *m_cObjAddressPtr;
    NSString        *m_cPhotoNamePtr;
    NSString        *m_cAthleteId;
    BOOL             isFavouriteAthlete;
    NSString        *m_cObjSportsPtr;
    NSString        *m_cObjSchoolNamePtr;
    NSString        *m_cObjTeamNamePtr;
    NSString        *m_cObjPositionPtr;
    NSString        *m_cObjSchoolYearPtr;
    NSString        *m_cObjCityNamePtr;
    NSString        *m_cObjStateNamePtr;
    NSString        *m_cObjZipCodePtr;
    NSString        *m_cObjTypePtr;
    NSString        *m_cObjNickNamePtr;
    NSString        *m_cObjPasswordPtr;
    NSString        *m_cObjCellPhoneNumberPtr;
    NSString        *m_cObjFB_IDPtr;
    NSString        *m_cObjTwit_IDPtr;
    NSString        *m_cObjPersonal_InfoPtr;
    NSString        *m_cObjSchoolCoachNamePtr;
    NSString        *m_cObjClubCoachNamePtr;
    NSString        *m_cObjBirthDatePtr;
    NSString        *m_cObjHeightPtr;
    NSString        *m_cObjWeightPtr;
    NSString        *m_cObjWingSpanPtr;
    NSString        *m_cObjReachPtr;
    NSString        *m_cObjShoeSizePtr;
    NSString        *m_cObjU_IDPtr;
    NSString        *m_cObjActivePtr;
    NSString        *m_cObjGenderPtr;
    BOOL            m_cIsAddedinOfflineMode;
    BOOL            m_cIsPhotoAddedInOfflineMode;
    
}
@property (nonatomic)           BOOL            m_cIsAddedinOfflineMode;
@property (nonatomic,copy)      NSString        *m_cObjFirstNamePtr;
@property (nonatomic,copy)      NSString        *m_cObjLastNamePtr;
@property (nonatomic,copy)      NSString        *m_cObjEmailIdPtr;
@property (nonatomic,copy)      NSString       *m_cObjPhoneNumberPtr;
@property (nonatomic,copy)      NSString        *m_cObjAddressPtr;
@property (nonatomic,copy)      NSString        *m_cPhotoNamePtr;
@property (nonatomic,copy)    NSString        *m_cAthleteId;
@property (nonatomic)           BOOL             isFavouriteAthlete;
@property (nonatomic,copy) NSString        *m_cObjSportsPtr;
@property (nonatomic,copy) NSString        *m_cObjSchoolNamePtr;
@property (nonatomic,copy) NSString        *m_cObjTeamNamePtr;
@property (nonatomic,copy) NSString        *m_cObjPositionPtr;
@property (nonatomic,copy) NSString        *m_cObjSchoolYearPtr;
@property (nonatomic,copy) NSString        *m_cObjCityNamePtr;
@property (nonatomic,copy) NSString        *m_cObjStateNamePtr;
@property (nonatomic,copy) NSString        *m_cObjZipCodePtr;
@property (nonatomic,copy) NSString        *m_cObjNickNamePtr;
@property (nonatomic,copy) NSString        *m_cObjPasswordPtr;
@property (nonatomic,copy) NSString        *m_cObjCellPhoneNumberPtr;
@property (nonatomic,copy) NSString        *m_cObjFB_IDPtr;
@property (nonatomic,copy) NSString        *m_cObjTwit_IDPtr;
@property (nonatomic,copy) NSString        *m_cObjPersonal_InfoPtr;
@property (nonatomic,copy) NSString        *m_cObjSchoolCoachNamePtr;
@property (nonatomic,copy) NSString        *m_cObjClubCoachNamePtr;
@property (nonatomic,copy) NSString        *m_cObjBirthDatePtr;
@property (nonatomic,copy) NSString        *m_cObjHeightPtr;
@property (nonatomic,copy) NSString        *m_cObjWeightPtr;
@property (nonatomic,copy) NSString        *m_cObjWingSpanPtr;
@property (nonatomic,copy) NSString        *m_cObjReachPtr;
@property (nonatomic,copy) NSString        *m_cObjShoeSizePtr;
@property (nonatomic,copy) NSString        *m_cObjU_IDPtr;
@property (nonatomic,copy) NSString        *m_cObjActivePtr;
@property (nonatomic,copy) NSString        *m_cObjTypePtr;
@property (nonatomic,copy) NSString        *m_cObjGenderPtr;
@property (nonatomic)      BOOL             m_cIsPhotoAddedInOfflineMode;

@end
