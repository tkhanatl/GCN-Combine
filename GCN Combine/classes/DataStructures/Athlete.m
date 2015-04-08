//
//  Athlete.m
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "Athlete.h"
#import "AppDelegate.h"
#import "Macros.h"

@implementation Athlete

@synthesize m_cObjFirstNamePtr,m_cObjLastNamePtr,m_cObjEmailIdPtr,m_cObjPhoneNumberPtr,m_cObjAddressPtr,m_cPhotoNamePtr,m_cAthleteId,isFavouriteAthlete;
@synthesize m_cObjSportsPtr,m_cObjSchoolNamePtr,m_cObjTeamNamePtr,m_cObjPositionPtr,m_cObjSchoolYearPtr,m_cObjCityNamePtr,m_cObjStateNamePtr,m_cObjZipCodePtr;
@synthesize m_cObjTypePtr,m_cObjNickNamePtr,m_cObjPasswordPtr,m_cObjActivePtr,m_cObjBirthDatePtr,m_cObjClubCoachNamePtr,m_cObjFB_IDPtr,m_cObjHeightPtr,m_cObjCellPhoneNumberPtr,m_cObjPersonal_InfoPtr,m_cObjReachPtr,m_cObjSchoolCoachNamePtr,m_cObjShoeSizePtr,m_cObjTwit_IDPtr,m_cObjU_IDPtr,m_cObjWeightPtr,m_cObjWingSpanPtr,m_cObjGenderPtr;
@synthesize m_cIsAddedinOfflineMode,m_cIsPhotoAddedInOfflineMode;



-(id)init
{
    self=[super init];
    if (self) {
        m_cObjFirstNamePtr  =   (NSString *)nil;
        m_cObjLastNamePtr   =   (NSString *)nil;
        m_cObjEmailIdPtr    =   (NSString *)nil;
        m_cObjPhoneNumberPtr   = (NSString *)nil;
        m_cObjAddressPtr    =   (NSString *)nil;
        m_cPhotoNamePtr     =   (NSString *)nil;
        isFavouriteAthlete  =   NO;
        m_cAthleteId        =   (NSString *)nil;
        m_cObjSportsPtr             =(NSString*)nil;
        m_cObjSchoolNamePtr             =(NSString*)nil;
        m_cObjTeamNamePtr               =(NSString*)nil;
        m_cObjPositionPtr          =(NSString*)nil;
        m_cObjSchoolYearPtr             = (NSString*)nil;
        m_cObjCityNamePtr               = (NSString *)nil;
        m_cObjStateNamePtr              = (NSString *)nil;
        m_cObjZipCodePtr                = (NSString *)nil;
        m_cObjTypePtr               =(NSString*)nil;
        m_cObjNickNamePtr           =(NSString*)nil;
        m_cObjPasswordPtr           =(NSString*)nil;
        m_cObjActivePtr             =(NSString*)nil;
        m_cObjBirthDatePtr          =(NSString*)nil;
        m_cObjClubCoachNamePtr      =(NSString*)nil;
        m_cObjFB_IDPtr              =(NSString*)nil;
        m_cObjHeightPtr             =(NSString*)nil;
        m_cObjCellPhoneNumberPtr    =(NSString*)nil;
        m_cObjPersonal_InfoPtr      =(NSString*)nil;
        m_cObjReachPtr              =(NSString*)nil;
        m_cObjSchoolCoachNamePtr    =(NSString*)nil;
        m_cObjShoeSizePtr           =(NSString*)nil;
        m_cObjTwit_IDPtr            =(NSString*)nil;
        m_cObjU_IDPtr               =(NSString*)nil;
        m_cObjWeightPtr             =(NSString*)nil;
        m_cObjWingSpanPtr           =(NSString*)nil;
        m_cObjGenderPtr             =(NSString*)nil;
        
        m_cIsAddedinOfflineMode     = NO;
        m_cIsPhotoAddedInOfflineMode = NO;

    }
    return self;
}
-(void)dealloc
{
    SAFE_RELEASE(m_cObjFirstNamePtr)
    SAFE_RELEASE(m_cObjLastNamePtr)
    SAFE_RELEASE(m_cObjEmailIdPtr)
    SAFE_RELEASE(m_cObjAddressPtr)
    SAFE_RELEASE(m_cPhotoNamePtr)
    SAFE_RELEASE(m_cObjPhoneNumberPtr)
    
    SAFE_RELEASE(m_cObjSportsPtr)
    SAFE_RELEASE(m_cObjSchoolNamePtr)
    SAFE_RELEASE(m_cObjTeamNamePtr)
    SAFE_RELEASE(m_cObjPositionPtr)
    SAFE_RELEASE(m_cObjSchoolYearPtr)
    SAFE_RELEASE(m_cObjCityNamePtr)
    SAFE_RELEASE(m_cObjStateNamePtr)
    SAFE_RELEASE(m_cObjZipCodePtr)
    
    SAFE_RELEASE(m_cObjWeightPtr)
    SAFE_RELEASE(m_cObjWingSpanPtr)
    SAFE_RELEASE(m_cObjU_IDPtr)
    SAFE_RELEASE(m_cObjTwit_IDPtr)
   
    SAFE_RELEASE(m_cObjShoeSizePtr)
    SAFE_RELEASE(m_cObjSchoolCoachNamePtr)
    SAFE_RELEASE(m_cObjReachPtr)
    SAFE_RELEASE(m_cObjPersonal_InfoPtr)
    SAFE_RELEASE(m_cObjHeightPtr)
    SAFE_RELEASE(m_cObjFB_IDPtr)
    SAFE_RELEASE(m_cObjClubCoachNamePtr)
    SAFE_RELEASE(m_cObjBirthDatePtr)
    SAFE_RELEASE(m_cObjActivePtr)
    SAFE_RELEASE(m_cObjPasswordPtr)
    SAFE_RELEASE(m_cObjNickNamePtr)
    SAFE_RELEASE(m_cObjCellPhoneNumberPtr)
    SAFE_RELEASE(m_cObjTypePtr)
    SAFE_RELEASE(m_cAthleteId)
    SAFE_RELEASE(m_cObjGenderPtr)
    
    [super dealloc];
}

@end
