//
//  HttpController.m
//  GCN Combine
//
//  Created by DP Samantrai on 06/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HttpHandler.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "Macros.h"
#import "AddAthleteViewController.h"
#import "CombineData.h"
#import "Tests.h"
#include <sys/xattr.h>


//Narasimhaiah adding to make a webcall to make the sync request faster 9-4-13 - start
@interface WebCalls : NSObject
{
    void(^webCallDidFinish)(NSString *response);
    
    BOOL bFinished_i;
}

@property (nonatomic, retain) NSMutableData *responseData;

-(void)setWebCallDidFinish:(void (^)(NSString *))wcdf;

-(void)webCall :(NSString *)webCall_p;

@end
//Narasimhaiah adding to make a webcall to make the sync request faster 9-4-13 - end


@implementation HttpHandler
@synthesize lObjAthleteArrayPtr;
@synthesize m_cObjAthletePtr;
@synthesize IsUpdateSuccess;
@synthesize ISUploadlogSuccess;
@synthesize m_cObjServerTransactionDelegatePtr;
@synthesize m_cObjPhotoPathPtr;
@synthesize m_cAthleteId;
@synthesize isPhotoDownloadSucceed;
@synthesize m_cObjAddAthleteURLPtr,m_cObjDownloadAthDetailPtr,m_cObjDownloadAthListURLPtr,m_cObjLogpostURLPtr;
@synthesize m_cObjLoginRequestURLPtr;
@synthesize m_cObjDownloadImageURLPtr;
@synthesize m_cObjDownloadCombineIDsURLPtr,m_cObjDownloadCombineTestsURLPtr;
@synthesize m_cObjUploadImageURLPtr;
@synthesize m_cObjCombineIdPtr;
@synthesize m_cObjURLConnectionPtr;
@synthesize m_cObjDownloadAthListURLForCombineIdPtr,m_cObjAthleteListPtr,m_cObjResponseArray;
-(id)init
{
    self= [super init];
    if (self) {
        responseData = (NSMutableData *)nil;
        lObjAthleteArrayPtr = (NSMutableArray *)nil;
        
        Athlete *lObjAthletePtr = [[Athlete alloc] init];
        self.m_cObjAthletePtr = lObjAthletePtr;
        SAFE_RELEASE(lObjAthletePtr)
        
        IsUpdateSuccess = NO;
        m_cObjServerTransactionDelegatePtr = nil;
        ISUploadlogSuccess = NO;
        
        
        m_cObjURLConnectionPtr = (NSURLConnection *)nil;
        m_cObjURLRequestPtr = (NSMutableURLRequest *)nil;
        m_cObjWebDataPtr = (NSMutableData *)nil;
        m_cObjRequestHeadersPtr = (NSMutableArray *)nil;
        isPhotoDownloadSucceed = NO;
        m_cObjDownloadAthListURLForCombineIdPtr=(NSString *)nil;
        m_cObjAthleteListPtr=(NSArray *)nil;
        m_cObjResponseArray=(NSMutableDictionary *)nil;
        //gObjAppDelegatePtr.IsUpdateForEthlete=NO;
        
        //add the language change notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivelocalizedServerChanged:)
                                                     name:@"localizedServerChanged"
                                                   object:nil];

        
    }
    return self;
}

//language change notification observer delegate method
- (void)receivelocalizedServerChanged:(NSNotification *)notification
{
    [self initializeControlText];
}
-(void)cancelDownload
{
    [self.m_cObjURLConnectionPtr cancel];
    m_cObjWebDataPtr = nil;
}
- (void)initializeControlText
{
     
    //reassign the control text based on the selected language
    if ([gObjAppDelegatePtr.m_cUserSelServer isEqualToString:@"Production"])
    {
       m_cObjLogpostURLPtr =@"http://api.gamechangernation.com/service.svc/json/CombineResultsNewAct";
         m_cObjAddAthleteURLPtr =@"http://api.gamechangernation.com/Service.svc/json/AthleteCombineAct";//sougat change this on 12/9/13
       //m_cObjAddAthleteURLPtr =@"http://api.gamechangernation.com/service.svc/json/AthleteAct";
       m_cObjDownloadAthListURLPtr =@"http://api.gamechangernation.com/Service.svc/json/GCNAthleteCombine/";//sougat change this on 12/9/13
       // m_cObjDownloadAthListURLPtr =@"http://api.gamechangernation.com/service.svc/json/Athlete/0/";
       m_cObjDownloadAthDetailPtr =@"http://api.gamechangernation.com/service.svc/json/AllAthlete/%@/null";
       m_cObjLoginRequestURLPtr  = @"http://api.gamechangernation.com/service.svc/json/GCNTrainerLogin";
       m_cObjDownloadImageURLPtr =@"http://www.gamechangernation.com/ProfilePhotos/%@";
       m_cObjDownloadCombineIDsURLPtr = @"http://api.gamechangernation.com/service.svc/json/CombineNew/0/null";
       m_cObjDownloadCombineTestsURLPtr = @"http://api.gamechangernation.com/service.svc/json/GCNCombineTestsNew/%d";
       m_cObjUploadImageURLPtr =@"http://api.gamechangernation.com/webservice.asmx/AthleteImageUpload";
               
        

    }
    else
    {
        m_cObjLogpostURLPtr =@"http://testgcnapi.rojoli.com/service.svc/json/CombineResultsNewAct";
        m_cObjAddAthleteURLPtr = @"http://testgcnapi.rojoli.com/Service.svc/json/AthleteCombineAct";
       // m_cObjAddAthleteURLPtr = @"http://testgcnapi.rojoli.com/service.svc/json/AthleteAct";//sougat change this on 12/9/13
        m_cObjDownloadAthListURLPtr =@"http://testgcnapi.rojoli.com/Service.svc/json/GCNAthleteCombine/";
        m_cObjDownloadAthDetailPtr =@"http://testgcnapi.rojoli.com/service.svc/json/AllAthlete/%@/null";
        m_cObjLoginRequestURLPtr = @"http://testgcnapi.rojoli.com/service.svc/json/GCNTrainerLogin";
        m_cObjDownloadImageURLPtr =@"http://gc.rojoli.com/profilephotos/%@";
        m_cObjDownloadCombineIDsURLPtr = @"http://testgcnapi.rojoli.com/service.svc/json/CombineNew/0/null";
        m_cObjDownloadCombineTestsURLPtr = @"http://testgcnapi.rojoli.com/service.svc/json/GCNCombineTestsNew/%d";
        m_cObjUploadImageURLPtr = @"http://testgcnapi.rojoli.com/webservice.asmx/AthleteImageUpload";
    }
    
}
//Narasimhaiah adding to get Combine ID list 28-2-13 - start
-(void)downloadCombineIds
{
    
    if (YES==[gObjAppDelegatePtr isNetworkAvailable]) //sougata added this on 16 aug
    {
        requestisFor = CombineID;
        [self runWithRequest:m_cObjDownloadCombineIDsURLPtr requestString:@"" requestMethod:@"GET"];

    }
    else//sougata added this on 16 aug
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
        
    }
    
//    [self runWithRequest:m_cObjDownloadCombineIDsURLPtr requestString:@"" requestMethod:@"GET"];
    
}
-(void)downloadCombineTests:(NSInteger )pObjCombineIDPtr
{
    if (YES==[gObjAppDelegatePtr isNetworkAvailable]) //sougata added this on 16 aug
    {
    requestisFor = CombineTests;
    m_cObjCombineIdPtr = pObjCombineIDPtr;
    [self runWithRequest:[NSString stringWithFormat:m_cObjDownloadCombineTestsURLPtr,pObjCombineIDPtr] requestString:@"" requestMethod:@"GET"];
    }
    else//sougata added this on 16 aug
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
        
    }
    

}

//Narasimhaiah adding to get Combine ID list 28-2-13 - end
-(void)loginRequest:(UserInfo *)pObjUserInfoPtr
           deviceId:(NSString *)pObjDeviceIdPtr
{
    NSString *lObjRequestString = (NSString *)nil;
    gObjAppDelegatePtr.m_cObjUserInfoPtr = pObjUserInfoPtr;
    
#if 0
    lObjRequestString = [NSString stringWithFormat:@"{\"EMAIL\":\"%@\",\"PASSWORD\":\"%@\",\"TYPE\":\"T\"}",pObjUserInfoPtr.m_cObjUserIdPtr,pObjUserInfoPtr.m_cObjPasswordPtr];
#else
    lObjRequestString = [NSString stringWithFormat:@"{\"EMAIL\":\"%@\",\"PASSWORD\":\"%@\"}",pObjUserInfoPtr.m_cObjUserIdPtr,pObjUserInfoPtr.m_cObjPasswordPtr];
#endif
    if (YES==[gObjAppDelegatePtr isNetworkAvailable]) //sougata added this on 16 aug
    {
     requestisFor = Login;
     [self runWithRequest:[NSString stringWithFormat:@"%@",m_cObjLoginRequestURLPtr] requestString:lObjRequestString requestMethod:@"POST"];
    }
    else//sougata added this on 16 aug
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
        
    }

}
-(void)uploadRequest :(Athlete *)pObjAthletePtr isNewAthlete:(BOOL)isForNewAthlete
{
    self.m_cObjAthletePtr = pObjAthletePtr;
    NSString *lObjRequestString = (NSString *)nil;
    NSInteger  schoolYear = -1;
    NSInteger  uID = -1;
    NSInteger  sport = -1;
    
    if ([pObjAthletePtr.m_cObjNickNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjNickNamePtr || [pObjAthletePtr.m_cObjNickNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjNickNamePtr = @"";
    if ([pObjAthletePtr.m_cObjEmailIdPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjEmailIdPtr || [pObjAthletePtr.m_cObjEmailIdPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjEmailIdPtr = @"";
    if ([pObjAthletePtr.m_cObjPasswordPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjPasswordPtr || [pObjAthletePtr.m_cObjPasswordPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjPasswordPtr = @"";
    if ([pObjAthletePtr.m_cObjSchoolYearPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjSchoolYearPtr || [pObjAthletePtr.m_cObjSchoolYearPtr isEqualToString:@""])
    {
        pObjAthletePtr.m_cObjSchoolYearPtr = @"0";
        schoolYear = 0;
    }
    else{
        schoolYear = [pObjAthletePtr.m_cObjSchoolYearPtr integerValue];
    }
    if ([pObjAthletePtr.m_cObjU_IDPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjU_IDPtr || [pObjAthletePtr.m_cObjU_IDPtr isEqualToString:@""])
    {
        pObjAthletePtr.m_cObjU_IDPtr = @"0";
        uID = 0;
    }
    else{
        uID = [pObjAthletePtr.m_cObjU_IDPtr integerValue];
    }
    if ([pObjAthletePtr.m_cObjAddressPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjAddressPtr || [pObjAthletePtr.m_cObjAddressPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjAddressPtr = @"";
    if ([pObjAthletePtr.m_cObjCityNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjCityNamePtr || [pObjAthletePtr.m_cObjCityNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjCityNamePtr = @"";
    if ([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjStateNamePtr || [pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjStateNamePtr = @"";
    if ([pObjAthletePtr.m_cObjZipCodePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjZipCodePtr || [pObjAthletePtr.m_cObjZipCodePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjZipCodePtr = @"";
    if ([pObjAthletePtr.m_cObjCellPhoneNumberPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjCellPhoneNumberPtr || [pObjAthletePtr.m_cObjCellPhoneNumberPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjCellPhoneNumberPtr = @"";
    if ([pObjAthletePtr.m_cObjFB_IDPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjFB_IDPtr || [pObjAthletePtr.m_cObjFB_IDPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjFB_IDPtr = @"";
    if ([pObjAthletePtr.m_cObjTwit_IDPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjTwit_IDPtr || [pObjAthletePtr.m_cObjTwit_IDPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjTwit_IDPtr = @"";
    if ([pObjAthletePtr.m_cObjPhoneNumberPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjPhoneNumberPtr || [pObjAthletePtr.m_cObjPhoneNumberPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjPhoneNumberPtr = @"";
    if ([pObjAthletePtr.m_cObjPersonal_InfoPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjPersonal_InfoPtr || [pObjAthletePtr.m_cObjPersonal_InfoPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjPersonal_InfoPtr = @"";
    if ([pObjAthletePtr.m_cObjSchoolNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjSchoolNamePtr || [pObjAthletePtr.m_cObjSchoolNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjSchoolNamePtr = @"";
    if ([pObjAthletePtr.m_cObjSchoolCoachNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjSchoolCoachNamePtr || [pObjAthletePtr.m_cObjSchoolCoachNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjSchoolCoachNamePtr = @"";
    if ([pObjAthletePtr.m_cObjTeamNamePtr isEqualToString:@""] || (NSString *)nil == pObjAthletePtr.m_cObjTeamNamePtr || [pObjAthletePtr.m_cObjTeamNamePtr isEqualToString:@" "])
        pObjAthletePtr.m_cObjTeamNamePtr = @"";
    if ([pObjAthletePtr.m_cObjClubCoachNamePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjClubCoachNamePtr || [pObjAthletePtr.m_cObjClubCoachNamePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjClubCoachNamePtr = @"";
    if ([pObjAthletePtr.m_cObjBirthDatePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjBirthDatePtr || [pObjAthletePtr.m_cObjBirthDatePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjBirthDatePtr = @"01/01/1900";
    if ([pObjAthletePtr.m_cObjHeightPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjHeightPtr || [pObjAthletePtr.m_cObjHeightPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjHeightPtr = @"";
    if ([pObjAthletePtr.m_cObjWeightPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjWeightPtr || [pObjAthletePtr.m_cObjWeightPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjWeightPtr = @"";
    if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjSportsPtr || [pObjAthletePtr.m_cObjSportsPtr isEqualToString:@""]){
        pObjAthletePtr.m_cObjSportsPtr = @"1";
        sport =1;
    }
    else{
        if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"General"]){
            
            sport =1;
        }
        else if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"Baseball"]){
                        sport =2;
        }
        else if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"Basketball"]){
            
            sport =3;
        }
        else if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"Football"]){
            
            sport = 4;
        }
        else if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"Lacrosse"]){
            
            sport =5;
        }
        else if ([pObjAthletePtr.m_cObjSportsPtr isEqualToString:@"Volleyball"]){
                        sport =6;
        }
        
    }
    if ([pObjAthletePtr.m_cObjWingSpanPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjWingSpanPtr || [pObjAthletePtr.m_cObjWingSpanPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjWingSpanPtr = @"";
    if ([pObjAthletePtr.m_cObjReachPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjReachPtr || [pObjAthletePtr.m_cObjReachPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjReachPtr = @"";
    if ([pObjAthletePtr.m_cObjShoeSizePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjShoeSizePtr || [pObjAthletePtr.m_cObjShoeSizePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjShoeSizePtr = @"";
    if ([pObjAthletePtr.m_cObjPositionPtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjPositionPtr || [pObjAthletePtr.m_cObjPositionPtr isEqualToString:@""])
        pObjAthletePtr.m_cObjPositionPtr = @"";
//    if ([pObjAthletePtr.m_cObjTypePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjTypePtr || [pObjAthletePtr.m_cObjTypePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjTypePtr = @"A";
//    if ([pObjAthletePtr.m_cObjActivePtr isEqualToString:@" "] || (NSString *)nil == pObjAthletePtr.m_cObjActivePtr || [pObjAthletePtr.m_cObjActivePtr isEqualToString:@""])
        pObjAthletePtr.m_cObjActivePtr = @"Y";
    
    
    if (YES == isForNewAthlete) 
    {
        
#if 0
        lObjRequestString = [NSString stringWithFormat:@"{\"Action\":\"A\",\"Identifier\":\"0\",\"TYPE\":\"%@\",\"FNAME\":\"%@\",\"LNAME\":\"%@\",\"NICKNAME\":\"%@\",\"IMAGE\":\"%@\",\"EMAIL\":\"%@\",\"PASSWORD\":\"%@\",\"ADDRESS\":\"%@\",\"CITY\":\"%@\",\"STATE\":\"%@\",\"ZIP\":\"%@\",\"CELL_PHONE\":\"%@\",\"HOME_PHONE\":\"%@\",\"FB_ID\":\"%@\",\"TWIT_ID\":\"%@\",\"PERSONAL_INFO\":\"%@\",\"SCHOOL_NAME\":\"%@\",\"SCHOOL_COACH_NAME\":\"%@\",\"CLUB_TEAM_NAME\":\"%@\",\"CLUB_COACH_NAME\":\"%@\",\"BIRTH_DATE\":\"%@\",\"YEAR\":%d,\"HEIGHT\":\"%@\",\"WEIGHT\":\"%@\",\"WINGSPAN\":\"%@\",\"REACH\":\"%@\",\"SHOE_SIZE\":\"%@\",\"SPORT\":%d,\"U_ID\":%d,\"ACTIVE\":\"%@\",\"POSITION\":\"%@\"}",pObjAthletePtr.m_cObjTypePtr,pObjAthletePtr.m_cObjFirstNamePtr,pObjAthletePtr.m_cObjLastNamePtr,pObjAthletePtr.m_cObjNickNamePtr,pObjAthletePtr.m_cPhotoNamePtr,pObjAthletePtr.m_cObjEmailIdPtr,pObjAthletePtr.m_cObjPasswordPtr,pObjAthletePtr.m_cObjAddressPtr,pObjAthletePtr.m_cObjCityNamePtr,pObjAthletePtr.m_cObjStateNamePtr,pObjAthletePtr.m_cObjZipCodePtr,pObjAthletePtr.m_cObjCellPhoneNumberPtr,pObjAthletePtr.m_cObjPhoneNumberPtr,pObjAthletePtr.m_cObjFB_IDPtr,pObjAthletePtr.m_cObjTwit_IDPtr,pObjAthletePtr.m_cObjPersonal_InfoPtr,pObjAthletePtr.m_cObjSchoolNamePtr,pObjAthletePtr.m_cObjSchoolCoachNamePtr,pObjAthletePtr.m_cObjTeamNamePtr,pObjAthletePtr.m_cObjClubCoachNamePtr,pObjAthletePtr.m_cObjBirthDatePtr,schoolYear,pObjAthletePtr.m_cObjHeightPtr,pObjAthletePtr.m_cObjWeightPtr,pObjAthletePtr.m_cObjWingSpanPtr,pObjAthletePtr.m_cObjReachPtr,pObjAthletePtr.m_cObjShoeSizePtr,sport,uID,pObjAthletePtr.m_cObjActivePtr,pObjAthletePtr.m_cObjPositionPtr];
#endif//sougata comment this on 12/9/13 for add combine id to jsondata 
        
        lObjRequestString = [NSString stringWithFormat:@"{\"Action\":\"A\",\"Identifier\":\"0\",\"TYPE\":\"%@\",\"FNAME\":\"%@\",\"LNAME\":\"%@\",\"NICKNAME\":\"%@\",\"IMAGE\":\"%@\",\"EMAIL\":\"%@\",\"PASSWORD\":\"%@\",\"ADDRESS\":\"%@\",\"CITY\":\"%@\",\"STATE\":\"%@\",\"ZIP\":\"%@\",\"CELL_PHONE\":\"%@\",\"HOME_PHONE\":\"%@\",\"FB_ID\":\"%@\",\"TWIT_ID\":\"%@\",\"PERSONAL_INFO\":\"%@\",\"SCHOOL_NAME\":\"%@\",\"SCHOOL_COACH_NAME\":\"%@\",\"CLUB_TEAM_NAME\":\"%@\",\"CLUB_COACH_NAME\":\"%@\",\"BIRTH_DATE\":\"%@\",\"YEAR\":\"%d\",\"HEIGHT\":\"%@\",\"WEIGHT\":\"%@\",\"WINGSPAN\":\"%@\",\"REACH\":\"%@\",\"SHOE_SIZE\":\"%@\",\"SPORT\":\"%d\",\"U_ID\":\"%d\",\"ACTIVE\":\"%@\",\"POSITION\":\"%@\",\"GENDER\":\"%@\",\"CombineId\":\"%@\"}",pObjAthletePtr.m_cObjTypePtr,pObjAthletePtr.m_cObjFirstNamePtr,pObjAthletePtr.m_cObjLastNamePtr,pObjAthletePtr.m_cObjNickNamePtr,pObjAthletePtr.m_cPhotoNamePtr,pObjAthletePtr.m_cObjEmailIdPtr,pObjAthletePtr.m_cObjPasswordPtr,pObjAthletePtr.m_cObjAddressPtr,pObjAthletePtr.m_cObjCityNamePtr,pObjAthletePtr.m_cObjStateNamePtr,pObjAthletePtr.m_cObjZipCodePtr,pObjAthletePtr.m_cObjCellPhoneNumberPtr,pObjAthletePtr.m_cObjPhoneNumberPtr,pObjAthletePtr.m_cObjFB_IDPtr,pObjAthletePtr.m_cObjTwit_IDPtr,pObjAthletePtr.m_cObjPersonal_InfoPtr,pObjAthletePtr.m_cObjSchoolNamePtr,pObjAthletePtr.m_cObjSchoolCoachNamePtr,pObjAthletePtr.m_cObjTeamNamePtr,pObjAthletePtr.m_cObjClubCoachNamePtr,pObjAthletePtr.m_cObjBirthDatePtr,schoolYear,pObjAthletePtr.m_cObjHeightPtr,pObjAthletePtr.m_cObjWeightPtr,pObjAthletePtr.m_cObjWingSpanPtr,pObjAthletePtr.m_cObjReachPtr,pObjAthletePtr.m_cObjShoeSizePtr,sport,uID,pObjAthletePtr.m_cObjActivePtr,pObjAthletePtr.m_cObjPositionPtr,pObjAthletePtr.m_cObjGenderPtr,gObjAppDelegatePtr.m_cCMBNIDPtr];

        NSLog(@"lObjRequestString:%@",lObjRequestString);
        
        if (YES==[gObjAppDelegatePtr isNetworkAvailable]) //sougata added this on 16 aug.
        {
            requestisFor = Upload;
            [self runWithRequest:m_cObjAddAthleteURLPtr requestString:lObjRequestString requestMethod:@"POST"];
        }
//        requestisFor = Upload;
//        [self runWithRequest:m_cObjAddAthleteURLPtr requestString:lObjRequestString requestMethod:@"POST"];
        else//sougata added this on 16 aug
        {
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                          message:@"Connection failed" 
                                                         delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
            
        }

    }
    else
    {
        if((NSString *)nil != pObjAthletePtr.m_cObjStateNamePtr)
        {
            NSArray *lObjStateNameArrayPtr = [pObjAthletePtr.m_cObjStateNamePtr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
            if (lObjStateNameArrayPtr.count > 1) {
                pObjAthletePtr.m_cObjStateNamePtr = [lObjStateNameArrayPtr objectAtIndex:1];
            }
        }
        lObjRequestString = [NSString stringWithFormat:@"{\"Action\":\"U\",\"Identifier\":\"%@\",\"TYPE\":\"%@\",\"FNAME\":\"%@\",\"LNAME\":\"%@\",\"NICKNAME\":\"%@\",\"IMAGE\":\"%@\",\"EMAIL\":\"%@\",\"PASSWORD\":\"%@\",\"ADDRESS\":\"%@\",\"CITY\":\"%@\",\"STATE\":\"%@\",\"ZIP\":\"%@\",\"CELL_PHONE\":\"%@\",\"HOME_PHONE\":\"%@\",\"FB_ID\":\"%@\",\"TWIT_ID\":\"%@\",\"PERSONAL_INFO\":\"%@\",\"SCHOOL_NAME\":\"%@\",\"SCHOOL_COACH_NAME\":\"%@\",\"CLUB_TEAM_NAME\":\"%@\",\"CLUB_COACH_NAME\":\"%@\",\"BIRTH_DATE\":\"%@\",\"YEAR\":\"%d\",\"HEIGHT\":\"%@\",\"WEIGHT\":\"%@\",\"WINGSPAN\":\"%@\",\"REACH\":\"%@\",\"SHOE_SIZE\":\"%@\",\"SPORT\":\"%d\",\"U_ID\":\"%d\",\"ACTIVE\":\"%@\",\"POSITION\":\"%@\",\"GENDER\":\"%@\",\"CombineId\":\"%@\"}",pObjAthletePtr.m_cAthleteId,pObjAthletePtr.m_cObjTypePtr,pObjAthletePtr.m_cObjFirstNamePtr,pObjAthletePtr.m_cObjLastNamePtr,pObjAthletePtr.m_cObjNickNamePtr,pObjAthletePtr.m_cPhotoNamePtr,pObjAthletePtr.m_cObjEmailIdPtr,pObjAthletePtr.m_cObjPasswordPtr,pObjAthletePtr.m_cObjAddressPtr,pObjAthletePtr.m_cObjCityNamePtr,pObjAthletePtr.m_cObjStateNamePtr,pObjAthletePtr.m_cObjZipCodePtr,pObjAthletePtr.m_cObjCellPhoneNumberPtr,pObjAthletePtr.m_cObjPhoneNumberPtr,pObjAthletePtr.m_cObjFB_IDPtr,pObjAthletePtr.m_cObjTwit_IDPtr,pObjAthletePtr.m_cObjPersonal_InfoPtr,pObjAthletePtr.m_cObjSchoolNamePtr,pObjAthletePtr.m_cObjSchoolCoachNamePtr,pObjAthletePtr.m_cObjTeamNamePtr,pObjAthletePtr.m_cObjClubCoachNamePtr,pObjAthletePtr.m_cObjBirthDatePtr,schoolYear,pObjAthletePtr.m_cObjHeightPtr,pObjAthletePtr.m_cObjWeightPtr,pObjAthletePtr.m_cObjWingSpanPtr,pObjAthletePtr.m_cObjReachPtr,pObjAthletePtr.m_cObjShoeSizePtr,sport,uID,pObjAthletePtr.m_cObjActivePtr,pObjAthletePtr.m_cObjPositionPtr,pObjAthletePtr.m_cObjGenderPtr,gObjAppDelegatePtr.m_cCMBNIDPtr];
        NSLog(@"lObjRequestString:%@",lObjRequestString);
        if (YES==[gObjAppDelegatePtr isNetworkAvailable]) 
        {
            requestisFor = updateAthlet;
            
            [self runWithRequest:m_cObjAddAthleteURLPtr requestString:lObjRequestString requestMethod:@"POST"];
        }
        
//        requestisFor = updateAthlet;
//        
//        [self runWithRequest:m_cObjAddAthleteURLPtr requestString:lObjRequestString requestMethod:@"POST"];
        else//sougata added this on 16 aug
        {
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                          message:@"Connection failed" 
                                                         delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
            
        }

        
    }
}
-(void)downloadAthleteInformation:(Athlete *)pObjAthletePtr
{
    gObjAppDelegatePtr.isForAthleteDetailDownload = YES;
    requestisFor = DownloadAthleteDetail;
    m_cAthleteId = pObjAthletePtr.m_cAthleteId;
    self.m_cObjAthletePtr = pObjAthletePtr;
   // NSString *tempIDString = [NSString stringWithFormat:@"%@",m_cAthleteId];
     if (YES == [gObjAppDelegatePtr isNetworkAvailable])
    {

        [self runWithRequest:[NSString stringWithFormat:m_cObjDownloadAthDetailPtr,m_cAthleteId] requestString:@"" requestMethod:@"GET"];
   }
    else//sougata added this on 16 aug
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
        
    }

}
-(void)uploadImage:(Athlete *)pObjAthletePtr
{
    self.m_cObjAthletePtr = pObjAthletePtr;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = NO;
    NSData *myData;
    NSString *lObjPhotoFolderPtr = (NSString *)nil;
    NSString *lObjLoginRequestStrngPtr = (NSString *)nil;
    NSData  *lObjDataPtr = (NSData *)nil;
    NSHTTPURLResponse *lObjUrlResponsePtr = (NSHTTPURLResponse *)nil;
    NSError *lObJErrorPtr = (NSError *)nil;
    NSData *lObjUploadDataPtr = (NSData *)nil;
    //NSString *lObjImageNamePathPtr = (NSString *)nil;
    
    if (requestisFor == updateAthlet || gObjAppDelegatePtr.IsPendingImage == YES) {

        if ((NSString *)nil != pObjAthletePtr.m_cPhotoNamePtr && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders :pObjAthletePtr.m_cAthleteId AthImageName:pObjAthletePtr.m_cPhotoNamePtr];
            
            fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            
            if (NO == fileExists && (NSString *)nil != pObjAthletePtr.m_cPhotoNamePtr && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:pObjAthletePtr.m_cPhotoNamePtr];
                
                fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            }
        }
        
        if (YES == fileExists) {
            
            myData = [NSData dataWithContentsOfFile:lObjPhotoFolderPtr];
            base64formatImagePtr = [self base64forData:myData];
            
            lObjLoginRequestStrngPtr = [NSString stringWithFormat:@"{\"Identifier\":\"%@\",\"IMAGEDATA\":\"%@\"}",pObjAthletePtr.m_cAthleteId,base64formatImagePtr];
            
            if(YES == [gObjAppDelegatePtr isNetworkAvailable])
            {
                NSURL           *lObjUrlPtr = (NSURL *)nil;
                NSString        *lObjPostLengthPtr = (NSString *)nil;
                
                
                lObjPostLengthPtr = [NSString stringWithFormat:@"%d", [lObjLoginRequestStrngPtr length]];
                
                
                lObjUrlPtr = [NSURL URLWithString:m_cObjUploadImageURLPtr];
                lObjUploadDataPtr = [NSData dataWithBytes:[lObjLoginRequestStrngPtr UTF8String] length:[lObjLoginRequestStrngPtr length]];
                
                //Intialize the Request object.
                m_cObjURLRequestPtr = [NSMutableURLRequest requestWithURL:lObjUrlPtr];
                [m_cObjURLRequestPtr setTimeoutInterval:20.0];
                [m_cObjURLRequestPtr setHTTPMethod:@"POST"];
                [m_cObjURLRequestPtr setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [m_cObjURLRequestPtr setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [m_cObjURLRequestPtr setValue:[NSString stringWithFormat:@"%d", [lObjUploadDataPtr length]] forHTTPHeaderField:@"Content-Length"];
                [m_cObjURLRequestPtr setHTTPBody:lObjUploadDataPtr];
                
                lObjDataPtr = [NSURLConnection sendSynchronousRequest:m_cObjURLRequestPtr returningResponse:&lObjUrlResponsePtr error:&lObJErrorPtr];
                m_cObjWebDataPtr = [[NSMutableData alloc]initWithData:lObjDataPtr];
               
//                [gObjAppDelegatePtr.m_cObjOperationQueuePtr cancelAllOperations];
//                [gObjAppDelegatePtr.m_cObjOperationQueuePtr cancellall]
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                
                if ([lObjUrlResponsePtr statusCode] == 413) {
                    NSString *responseString = [NSString stringWithFormat:@"Response Code - %d \n Reponse message - %@, ImageSize - %d",[lObjUrlResponsePtr statusCode],[lObJErrorPtr localizedDescription],gObjAppDelegatePtr.imagesize];
                    
                    lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [lObjAlertViewPtr show];
                    SAFE_RELEASE(lObjAlertViewPtr)
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
                }
                else{
                    if ((NSError *)nil == lObJErrorPtr) {
                        if (m_cObjWebDataPtr.length >0) {
                            
                            //                        isPhotoDownloadSucceed = YES;
                            //                        gObjAppDelegatePtr.m_cObjImageDatePtr = m_cObjWebDataPtr;
                            [self handleAthletePhotoUpload];
                        }
                    }
                    else{
                        DSLog(@"Error response -%@",[lObJErrorPtr localizedDescription]);
                        //isPhotoDownloadSucceed = NO;
                        if([NSThread isMainThread])
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        else
                            [self performSelectorOnMainThread:@selector(informPhotoUploadNotificationToDelegate) withObject:nil waitUntilDone:NO];
                    }
                }             
               
            }
            else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
            {
//                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
            }

            if ((NSData *)nil != myData) {
                
                [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:lObjPhotoFolderPtr forKey:[NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cAthleteId]];
            }
            else{
                [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:[NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cAthleteId]];
            }
        }
        else{
            [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:[NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cAthleteId]];
        }
    }
    else if (requestisFor == Upload)
    {
        if ((NSString *)nil != pObjAthletePtr.m_cPhotoNamePtr && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders :pObjAthletePtr.m_cAthleteId AthImageName:pObjAthletePtr.m_cPhotoNamePtr];
            
            fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
            
            if (NO == fileExists && (NSString *)nil != pObjAthletePtr.m_cPhotoNamePtr && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![pObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjPhotoFolderPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:pObjAthletePtr.m_cPhotoNamePtr];
                
                fileExists = [fileManager fileExistsAtPath:lObjPhotoFolderPtr];
             }
          }
        
        if(YES == fileExists)
        {
            myData = [NSData dataWithContentsOfFile:lObjPhotoFolderPtr];
            base64formatImagePtr = [self base64forData:myData];

            NSString *lObjLoginRequestStrngPtr = (NSString *)nil;
        
            lObjLoginRequestStrngPtr = [NSString stringWithFormat:@"{\"Identifier\":\"%@\",\"IMAGEDATA\":\"%@\"}",pObjAthletePtr.m_cAthleteId,base64formatImagePtr];

            if(YES == [gObjAppDelegatePtr isNetworkAvailable])
            {
                NSURL           *lObjUrlPtr = (NSURL *)nil;
                NSString        *lObjPostLengthPtr = (NSString *)nil;
                
                
                lObjPostLengthPtr = [NSString stringWithFormat:@"%d", [lObjLoginRequestStrngPtr length]];
                
                
                lObjUrlPtr = [NSURL URLWithString:m_cObjUploadImageURLPtr];
                lObjUploadDataPtr = [NSData dataWithBytes:[lObjLoginRequestStrngPtr UTF8String] length:[lObjLoginRequestStrngPtr length]];

                //Intialize the Request object.
                m_cObjURLRequestPtr = [NSMutableURLRequest requestWithURL:lObjUrlPtr];
                [m_cObjURLRequestPtr setTimeoutInterval:5.0];
                [m_cObjURLRequestPtr setHTTPMethod:@"POST"];
                [m_cObjURLRequestPtr setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [m_cObjURLRequestPtr setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [m_cObjURLRequestPtr setValue:[NSString stringWithFormat:@"%d", [lObjUploadDataPtr length]] forHTTPHeaderField:@"Content-Length"];
                [m_cObjURLRequestPtr setHTTPBody:lObjUploadDataPtr];
                
                
                
//                NSString* ReqHeader = [NSString stringWithFormat: @"Time out Interval=\"%f\", Request_method=\"%@\"",
//                                        m_cObjURLRequestPtr.timeoutInterval, m_cObjURLRequestPtr.HTTPMethod];
//
//                DSLog(@"Req Header %@",ReqHeader);
//                DSLog(@"Accept Value %@",@"application/json");
//                DSLog(@"Content type %@",@"application/json");
//                DSLog(@"Request %@",[[NSString alloc] initWithData:lObjUploadDataPtr encoding:NSUTF8StringEncoding]);

                
                lObjDataPtr = [NSURLConnection sendSynchronousRequest:m_cObjURLRequestPtr returningResponse:&lObjUrlResponsePtr error:&lObJErrorPtr];
                m_cObjWebDataPtr = [[NSMutableData alloc]initWithData:lObjDataPtr];
//                DSLog(@"Response code %d",[lObjUrlResponsePtr statusCode]);
                
                
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                
                if ([lObjUrlResponsePtr statusCode] == 413) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    gObjAppDelegatePtr.responsestring = [NSString stringWithFormat:@"Response Code - %d \n Reponse message - %@, ImageSize - %d",[lObjUrlResponsePtr statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[lObjUrlResponsePtr statusCode]],gObjAppDelegatePtr.imagesize];
                    
                   // NSLog(@"Response %@",gObjAppDelegatePtr.responsestring);
                    
                    lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message: gObjAppDelegatePtr.responsestring  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [lObjAlertViewPtr show];
                    SAFE_RELEASE(lObjAlertViewPtr)
                }
                else
                {
                    if ((NSError *)nil == lObJErrorPtr) {
                        if (m_cObjWebDataPtr.length >0) {

                            [self handleAthletePhotoUpload];
                        }
                    }
                    else{

                        DSLog(@"Error response -%@",[lObJErrorPtr localizedDescription]);

                        if([NSThread isMainThread])
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        else
                            [self performSelectorOnMainThread:@selector(informPhotoUploadNotificationToDelegate) withObject:nil waitUntilDone:NO];
                    }
                }

            }
            else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
            {

            }
        }
        else
        {
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
        }
        }
}

-(void)uploadLog :(AthleteLog *)pObjAthleteLogPtr
            Tests:(Tests *)pObjTestsPtr
{        
    NSString *lObjLoginRequestStrngPtr = (NSString *)nil;
    if ((Tests *)nil == pObjTestsPtr) {
         lObjLoginRequestStrngPtr = [NSString stringWithFormat:NSLocalizedString(@"UploadLogScores", @""),pObjAthleteLogPtr.m_cObjCombineId,pObjAthleteLogPtr.m_cObjAthleteIdPtr,pObjAthleteLogPtr.m_cObjTestId,pObjAthleteLogPtr.m_cObjTestResultPtr];
    }
    else
    {
         lObjLoginRequestStrngPtr = [NSString stringWithFormat:NSLocalizedString(@"UploadLogScores", @""),pObjTestsPtr.m_cObjCombineId,pObjAthleteLogPtr.m_cObjAthleteIdPtr,pObjTestsPtr.m_cObjTestId,pObjAthleteLogPtr.m_cObjTestResultPtr];
    }
    if (YES==[gObjAppDelegatePtr isNetworkAvailable]) 
    {
        requestisFor = Uploadlog;
        [self runWithRequest:m_cObjLogpostURLPtr requestString:lObjLoginRequestStrngPtr requestMethod:@"POST"];
    }
    
//    requestisFor = Uploadlog;
//    [self runWithRequest:m_cObjLogpostURLPtr requestString:lObjLoginRequestStrngPtr requestMethod:@"POST"];
    else//sougata added this on 16 aug
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
        
    }

    
}

-(void)downloadRequest:(UserInfo *)pObjUserInfoPtr
{
#if 0
        requestisFor = Download;
        [self runWithRequest:m_cObjDownloadAthListURLPtr requestString:@"" requestMethod:@"GET"];
#else
    
    NSLog(@"%@",m_cObjDownloadAthListURLPtr);
    if (YES== [gObjAppDelegatePtr isNetworkAvailable])//sougata added this condition on 16 aug
    {

        NSString *lobjFirstString= (NSString *)nil;
        lobjFirstString=m_cObjDownloadAthListURLPtr;
            m_cObjDownloadAthListURLForCombineIdPtr=[NSString stringWithFormat:@"%@", [lobjFirstString stringByAppendingString:gObjAppDelegatePtr.m_cCMBNIDPtr]];
            requestisFor = Download;
            [self runWithRequest:m_cObjDownloadAthListURLForCombineIdPtr requestString:@"" requestMethod:@"GET"];

    }
    else
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                      message:@"Connection failed" 
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)

    }
#endif
 
}

-(void)downloadAthleteImage:(NSString *)pObjAthleteId
               AthImageName:(NSString *)pObjAthleteImageNamePtr
{
    NSString *lObjLoginRequestStrngPtr = (NSString *)nil;
    gObjAppDelegatePtr.m_cObjphotonamePtr = pObjAthleteImageNamePtr;
    m_cAthleteId = pObjAthleteId;
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    gObjAppDelegatePtr.m_cAthleteId = m_cAthleteId;
    
    lObjLoginRequestStrngPtr = [NSString stringWithFormat:m_cObjDownloadImageURLPtr,pObjAthleteImageNamePtr];
    
    NSURLResponse   *lObjUrlResponsePtr = (NSURLResponse *)nil;
    NSData          *lObjDataPtr        = (NSData *)nil;
    NSError         *lObJErrorPtr       = (NSError *)nil;
    if(YES == [gObjAppDelegatePtr isNetworkAvailable])
    {
        NSURL           *lObjUrlPtr = (NSURL *)nil;
        NSString        *lObjPostLengthPtr = (NSString *)nil;
        
        
        lObjPostLengthPtr = [NSString stringWithFormat:@"%d", [lObjLoginRequestStrngPtr length]];
        
        
        lObjUrlPtr = [NSURL URLWithString:lObjLoginRequestStrngPtr];
        
        //Intialize the Request object.
        m_cObjURLRequestPtr = [NSMutableURLRequest	requestWithURL:lObjUrlPtr
                                                 cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                             timeoutInterval: 30.0f];
//        m_cObjURLRequestPtr = [NSMutableURLRequest requestWithURL:lObjUrlPtr];
//        [m_cObjURLRequestPtr setTimeoutInterval:30.0];
        [m_cObjURLRequestPtr setHTTPMethod:@"GET"];
//        m_cObjURLConnectionPtr = [[NSURLConnection alloc]initWithRequest:m_cObjURLRequestPtr delegate:self];
        
        lObjDataPtr = [NSURLConnection sendSynchronousRequest:m_cObjURLRequestPtr returningResponse:&lObjUrlResponsePtr error:&lObJErrorPtr];
        m_cObjWebDataPtr = [[NSMutableData alloc]initWithData:lObjDataPtr];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ((NSError *)nil == lObJErrorPtr) {
            if (m_cObjWebDataPtr.length >0) {
                
                isPhotoDownloadSucceed = YES;
                gObjAppDelegatePtr.m_cObjImageDatePtr = m_cObjWebDataPtr;
                [self handleAthletePhotoDownload];
            }
        }
        else{
            DSLog(@"Error response -%@",[lObJErrorPtr localizedDescription]);
            isPhotoDownloadSucceed = NO;
            if([NSThread isMainThread])
                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr photoDownloadFailed];
            else
                [self performSelectorOnMainThread:@selector(informPhotoDownloadNotificationToDelegate) withObject:nil waitUntilDone:NO];
        }
    }
    else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
    }
}
-(void)runWithRequest:(NSString *)pObjURL 
        requestString:(NSString *)pObjRequestBodyPtr 
        requestMethod:(NSString *)pObjrqstMethod
{
    
//    NSLog(@"/---------------------\n");
    NSLog(@"%@",[NSString stringWithFormat:@"%@", pObjURL]);
//    NSLog(@"/---------------------\n");
//    
    if(YES == [NSThread isMainThread])
        //asynchronous request
        @try
    {
        if(YES == [gObjAppDelegatePtr isNetworkAvailable])
        {
            NSString        *lObjPostLengthPtr = (NSString *)nil;
            
            
            lObjPostLengthPtr = [NSString stringWithFormat:@"%d", [pObjRequestBodyPtr length]];
            
            NSURL *url = [NSURL URLWithString:pObjURL];
            
             NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setTimeoutInterval:10.0];
            //NSData *requestData = [pObjRequestBodyPtr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *requestData = [NSData dataWithBytes:[pObjRequestBodyPtr UTF8String] length:[pObjRequestBodyPtr length]];
            NSString *string = [[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"[[[[%@",string);
            
//            DSLog(@"Request = %@",[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
            
              [request setHTTPMethod:pObjrqstMethod];
            
            
            if ([pObjrqstMethod isEqualToString:@"POST"]) {
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody: requestData];
            }
            
            m_cObjURLConnectionPtr = [NSURLConnection connectionWithRequest:[request autorelease] delegate:self];
            
            if((NSURLConnection *)nil != m_cObjURLConnectionPtr)
            {
                if((NSMutableData *)nil != responseData)
                {
                    [responseData release];
                }
                responseData = [[NSMutableData alloc]init];
            }
            [m_cObjURLConnectionPtr start];
            
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        
    }
	@catch (NSException *x)
	{
        
	}
    
    

}
#pragma mark NSURLConnection delegate methods
-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    BOOL lRetVal = YES;
    lRetVal = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    return lRetVal;
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse	*lResponse = (NSHTTPURLResponse *)response;
    NSDictionary        *lObjHeaderPtr = (NSDictionary *)nil;
    
    
   // NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [lResponse statusCode];
     
//    DSLog(@"Status code %d",[lResponse statusCode]);
    NSLog(@"%d",code);
	if(lResponse.statusCode == 200 || lResponse.statusCode == 500)
	{
		lObjHeaderPtr = [lResponse allHeaderFields];
        m_cErrorCode= [[lObjHeaderPtr objectForKey:NSLocalizedString(@"ERROR_CODE_KEY", @"")] integerValue] ;
        m_cObjErrorStrPtr =  [lObjHeaderPtr objectForKey:NSLocalizedString(@"ERROR_MSG_KEY", @"")];
        m_cSuccess =  [[lObjHeaderPtr objectForKey:NSLocalizedString(@"SUCCESS_KEY", @"")] boolValue];
		[responseData setLength: 0];
    }
    else
	{
		m_cSuccess =  NO;
	}
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}
- (NSURLRequest *)connection:(NSURLConnection *)connection 
             willSendRequest:(NSURLRequest *)request 
            redirectResponse:(NSURLResponse *)response
{
	return request;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (YES == [gObjAppDelegatePtr isNetworkAvailable]) 
    {
        
        if (m_cObjErrorStrPtr == (NSString *)nil) 
        {
            m_cObjErrorStrPtr =[error localizedDescription];
        }
        if ((NSString *)nil != m_cObjErrorStrPtr)
        {
//            DSLog(@"%@",m_cObjErrorStrPtr);
            [gObjAppDelegatePtr stopProgressHandler];

            gObjAppDelegatePtr.isConnectionTimeout = YES;
             gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata added this on 16 aug
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];

        }
        
        else if (requestisFor == Upload || requestisFor == updateAthlet|| requestisFor == Uploadlog || requestisFor == Download || requestisFor == Login || requestisFor == DownloadAthleteDetail) {
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
        }
    else
    {
        gObjAppDelegatePtr.isConnectionTimeout = YES;
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    DSLog(@"Response = %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    // Do any additional setup after loading the view, typically from a nib.
if (YES== [gObjAppDelegatePtr isNetworkAvailable]) //sougata added this on 16 aug on 16 aug
{
    //NSString *lResponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response Data: %@",lResponse);
    
    if (requestisFor == Login)
    {
        gObjAppDelegatePtr.isForLogin = YES;
        NSInteger ISLoginSucceed = -1;
        
        NSError *err;
        NSData *response = responseData;
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:@"UserLoginJSONResult"];
                NSArray *lObjAthleteDataPtr = [lObjResponseArray objectForKey:@"AthleteData"];
                ISLoginSucceed = [[lObjResponseArray objectForKey:@"ResponseCode"] integerValue];
                
                for (NSMutableDictionary *tempDict in lObjAthleteDataPtr) {
                    
                    gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjFirstNamePtr = [tempDict objectForKey:@"FNAME"];
                    gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjLastNamePtr = [tempDict objectForKey:@"LNAME"];
                    gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjIdentifierPtr = [tempDict objectForKey:@"Identifier"];
                }
                
            }
        }        
        gObjAppDelegatePtr.m_cObjUserInfoPtr.isLoginSucceed = ISLoginSucceed;
        if (1 == ISLoginSucceed) {
            gObjAppDelegatePtr.m_cObjUserInfoPtr.isLoginSucceed = NO;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
        else if(0 == ISLoginSucceed){
            gObjAppDelegatePtr.m_cObjUserInfoPtr.isLoginSucceed = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
        }
        else
        {
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
    }
    else if (requestisFor == Upload)
    {
        NSError *err;
        NSString *lObjStatusPtr;
        NSData *response = responseData;
        NSString *string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"[[[[%@",string);

        
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
#if 0 //sougat block this on 12/9/13  for change  NSMutableDictionary *jsonArray key AthleteActionResult to AthleteCombineActionResult and put macros.
        if ((NSString *)nil != [jsonArray objectForKey:@"AthleteActionResult"] && jsonArray.count > 0 && ![[jsonArray objectForKey:@"AthleteActionResult"] isEqualToString:@"Fail"]) {
            lObjStatusPtr = [jsonArray objectForKey:@"AthleteActionResult"];
            self.m_cObjAthletePtr.m_cAthleteId =[jsonArray objectForKey:@"AthleteActionResult"];
            gObjAppDelegatePtr.m_cAthleteId =[jsonArray objectForKey:@"AthleteActionResult"];
           [self handleUpload];
            
        }
        else if([[jsonArray objectForKey:@"AthleteActionResult"] isEqualToString:@""] || [[jsonArray objectForKey:@"AthleteActionResult"] isEqualToString:@"Fail"] || [[jsonArray objectForKey:@"AthleteActionResult"] isEqualToString:@"fail"]) {
            gObjAppDelegatePtr.isConnectionTimeout = NO;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
#endif
        if ((NSString *)nil != [jsonArray objectForKey:ADDNEWATHLETEJSONKEY] && jsonArray.count > 0 && ![[jsonArray objectForKey:ADDNEWATHLETEJSONKEY] isEqualToString:@"Fail"]) {
            lObjStatusPtr = [jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
            self.m_cObjAthletePtr.m_cAthleteId =[jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
            gObjAppDelegatePtr.m_cAthleteId =[jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
            [self handleUpload];
            
        }
        else if([[jsonArray objectForKey:ADDNEWATHLETEJSONKEY] isEqualToString:@""] || [[jsonArray objectForKey:ADDNEWATHLETEJSONKEY] isEqualToString:@"Fail"] || [[jsonArray objectForKey:ADDNEWATHLETEJSONKEY] isEqualToString:@"fail"]) {
            gObjAppDelegatePtr.isConnectionTimeout = NO;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }

        else
        {
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];

        }
        [gObjAppDelegatePtr stopProgressHandler];

    }
    else if (requestisFor == updateAthlet)
    {
        NSError *err;
        NSString *lObjStatusPtr;
    
        NSData *response = responseData;
        NSString *string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"[[[[%@",string);
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
#if 0  //sougat block this on 12/9/13  for change  NSMutableDictionary *jsonArray key AthleteActionResult to AthleteCombineActionResult and put macros. 
        lObjStatusPtr = [jsonArray objectForKey:@"AthleteActionResult"];
        if(jsonArray.count > 0 && ([lObjStatusPtr isEqualToString:@"OK"] || 
                                   [lObjStatusPtr isEqualToString:@"Success"] || 
                                   [lObjStatusPtr isEqualToString:self.m_cObjAthletePtr.m_cAthleteId])) 
        {
            IsUpdateSuccess = YES;
            self.m_cObjAthletePtr.m_cAthleteId =[jsonArray objectForKey:@"AthleteActionResult"];
            gObjAppDelegatePtr.m_cAthleteId =[jsonArray objectForKey:@"AthleteActionResult"];
           // NSLog(@"lObjarr===========-%d",jsonArray.count);

            [self handleUpdateAthlete];
        }
#endif
        
        lObjStatusPtr = [jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
        if(jsonArray.count > 0 && ([lObjStatusPtr isEqualToString:@"OK"] || 
                                   [lObjStatusPtr isEqualToString:@"Success"] || 
                                   [lObjStatusPtr isEqualToString:self.m_cObjAthletePtr.m_cAthleteId])) 
        {
            IsUpdateSuccess = YES;
            self.m_cObjAthletePtr.m_cAthleteId =[jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
            gObjAppDelegatePtr.m_cAthleteId =[jsonArray objectForKey:ADDNEWATHLETEJSONKEY];
            // NSLog(@"lObjarr===========-%d",jsonArray.count);
            
            [self handleUpdateAthlete];
        }

        
        
        else if([lObjStatusPtr isEqualToString:@"Fail"])
        {
            IsUpdateSuccess = NO;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
        else
        {
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
            
        }
        lObjStatusPtr=nil;

    }
    else if (requestisFor == Uploadlog)
    {
        NSError *err;
        NSString *lObjStatusPtr;
        
          
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"[[[[%@",string);
        
        lObjStatusPtr = [jsonArray objectForKey:UPLOADLOGJSONKEY];
        if(jsonArray.count > 0 && ([lObjStatusPtr isEqualToString:@"Sucessfully"] || [lObjStatusPtr isEqualToString:@"sucessfully"]))
        {
            ISUploadlogSuccess = YES;
            [self handleUpdateLog];
        }
        else if([lObjStatusPtr isEqualToString:@"ERR"])
        {
            ISUploadlogSuccess = NO;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
        }
        else
        {
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
            
        }
    }
    else if (requestisFor == Download)
    {
        
        lObjAthleteArrayPtr = [[NSMutableArray alloc] init];
        
        NSError *err;
        NSInteger lObjStatusPtr;
        
        NSData *response = responseData;
       // NSString *string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *lObjMutableArrayPtr = [[NSMutableArray alloc]init];
        
        
        gObjAppDelegatePtr.m_cObjAthleteListPtr = lObjMutableArrayPtr;
        SAFE_RELEASE(lObjMutableArrayPtr)
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:DOWNLOADATHLETEJOSONKEY];
                NSArray *lObjAthleteListPtr = [lObjResponseArray objectForKey:DOWNLOADATHLETEJSONDATA];
                lObjStatusPtr = [[lObjResponseArray objectForKey:DOWNLOADATHLETERESPONSEJSONKEY] integerValue];
                
                
                if(lObjStatusPtr != 0){
                   // [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];//sougata block this on 31 oct
                    [gObjAppDelegatePtr.m_cDbHandler deleteAthlete]; 
                    [self performSelector:@selector(handleDownloadAthleteList) withObject:self afterDelay:1.0];//sougata adde4dc this on 31 oct
                }
                else if (lObjStatusPtr == 0)
                {
                    //[gObjAppDelegatePtr.m_cDbHandler deleteAthlete]; //After doing login again, need to update the athlete only. Why need to delete and insert again.
                    for (NSDictionary *tempDictionary in lObjAthleteListPtr) {
                        
                        Athlete *lObjAthletePtr = (Athlete *)nil;
                        lObjAthletePtr = [[Athlete alloc] init];
                        lObjAthletePtr.m_cAthleteId = [tempDictionary objectForKey:@"Identifier"];
                        lObjAthletePtr.m_cObjFirstNamePtr = [tempDictionary objectForKey:@"FNAME"];
                        lObjAthletePtr.m_cObjLastNamePtr = [tempDictionary objectForKey:@"LNAME"];
                        
                        [gObjAppDelegatePtr.m_cObjAthleteListPtr addObject:lObjAthletePtr];
                        [lObjAthleteArrayPtr addObject:lObjAthletePtr];
                        int rowCount =[gObjAppDelegatePtr.m_cDbHandler searchForAthleteDetail:lObjAthletePtr.m_cAthleteId];
                        
                        
                        if (rowCount == 0)
                        {
                            [gObjAppDelegatePtr.m_cDbHandler insertAthelete:lObjAthletePtr];
                            
                        }
                        else if(rowCount > 0)
                        {
                            [gObjAppDelegatePtr.m_cDbHandler updateAthleteFNLNID:lObjAthletePtr];
                        }
                        SAFE_RELEASE(lObjAthletePtr)
                    }
                    [self performSelector:@selector(handleDownloadAthleteList) withObject:self afterDelay:1.0];
                }
            }
        }
        else{
            
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
            UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
            lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"No Response from Server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [lObjAlertViewPtr show];
            SAFE_RELEASE(lObjAlertViewPtr)
            
        }
        SAFE_RELEASE(lObjAthleteArrayPtr)
        
        
    }
    else if (requestisFor == DownloadAthleteDetail)
    {
        
        lObjAthleteArrayPtr = [[NSMutableArray alloc] init];
        [gObjAppDelegatePtr stopProgressHandler];
        NSError *err;
        NSInteger lObjStatusPtr;

        NSData *response = responseData;
        NSString *string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"%@",string);
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:DOWNLOADATHLETEDETAILJSONKEY];
                NSArray *lObjAthleteListPtr = [lObjResponseArray objectForKey:DOWNLOADATHLETDETAILJSONDATKEY];
                lObjStatusPtr = [[lObjResponseArray objectForKey:DOWNLOADATHLETERESPONSEJSONKEY] integerValue];
                
                if (lObjStatusPtr == 0){
                    for (NSDictionary *tempDictionary in lObjAthleteListPtr) {

                        Athlete *lObjAthletePtr = (Athlete *)nil;
                        lObjAthletePtr = [[Athlete alloc]init];
                        
                        
                        if ((NSString *)nil != [tempDictionary objectForKey:@"Identifier"])
                            lObjAthletePtr.m_cAthleteId = [tempDictionary objectForKey:@"Identifier"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"FNAME"])
                            lObjAthletePtr.m_cObjFirstNamePtr = [tempDictionary objectForKey:@"FNAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"LNAME"])
                            lObjAthletePtr.m_cObjLastNamePtr = [tempDictionary objectForKey:@"LNAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TYPE"])
                            lObjAthletePtr.m_cObjTypePtr        = [tempDictionary objectForKey:@"TYPE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"EMAIL"])
                            lObjAthletePtr.m_cObjEmailIdPtr     = [tempDictionary objectForKey:@"EMAIL"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"PASSWORD"])
                            lObjAthletePtr.m_cObjPasswordPtr    = [tempDictionary objectForKey:@"PASSWORD"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"ADDRESS"])
                            lObjAthletePtr.m_cObjAddressPtr     = [tempDictionary objectForKey:@"ADDRESS"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"CITY"])
                            lObjAthletePtr.m_cObjCityNamePtr    = [tempDictionary objectForKey:@"CITY"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"STATE"])
                            lObjAthletePtr.m_cObjStateNamePtr   = [tempDictionary objectForKey:@"STATE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"ZIP"])
                            lObjAthletePtr.m_cObjZipCodePtr     = [tempDictionary objectForKey:@"ZIP"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"CELL_PHONE"])
                            lObjAthletePtr.m_cObjCellPhoneNumberPtr = [tempDictionary objectForKey:@"CELL_PHONE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"HOME_PHONE"])
                            lObjAthletePtr.m_cObjPhoneNumberPtr = [tempDictionary objectForKey:@"HOME_PHONE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"FB_ID"])
                            lObjAthletePtr.m_cObjFB_IDPtr       = [tempDictionary objectForKey:@"FB_ID"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TWIT_ID"])
                            lObjAthletePtr.m_cObjTwit_IDPtr     = [tempDictionary objectForKey:@"TWIT_ID"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"PERSONAL_INFO"])
                            lObjAthletePtr.m_cObjPersonal_InfoPtr = [tempDictionary objectForKey:@"PERSONAL_INFO"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"SCHOOL_NAME"])
                            lObjAthletePtr.m_cObjSchoolNamePtr = [tempDictionary objectForKey:@"SCHOOL_NAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"SCHOOL_COACH_NAME"])
                            lObjAthletePtr.m_cObjSchoolCoachNamePtr = [tempDictionary objectForKey:@"SCHOOL_COACH_NAME"];
                        if ((NSString *)nil != [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"SPORT"]])
                            lObjAthletePtr.m_cObjSportsPtr = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"SPORT"]];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"CLUB_TEAM_NAME"])
                            lObjAthletePtr.m_cObjTeamNamePtr = [tempDictionary objectForKey:@"CLUB_TEAM_NAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"CLUB_COACH_NAME"])
                            lObjAthletePtr.m_cObjClubCoachNamePtr = [tempDictionary objectForKey:@"CLUB_COACH_NAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"BIRTH_DATE"])
                            lObjAthletePtr.m_cObjBirthDatePtr = [tempDictionary objectForKey:@"BIRTH_DATE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"POSITION"])
                            lObjAthletePtr.m_cObjPositionPtr = [tempDictionary objectForKey:@"POSITION"];
                        if ((NSString *)nil != [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"YEAR"]])
                            lObjAthletePtr.m_cObjSchoolYearPtr =[NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"YEAR"]];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"HEIGHT"])
                            lObjAthletePtr.m_cObjHeightPtr = [tempDictionary objectForKey:@"HEIGHT"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"WEIGHT"])
                            lObjAthletePtr.m_cObjWeightPtr = [tempDictionary objectForKey:@"WEIGHT"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"WINGSPAN"])
                            lObjAthletePtr.m_cObjWingSpanPtr = [tempDictionary objectForKey:@"WINGSPAN"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"REACH"])
                            lObjAthletePtr.m_cObjReachPtr = [tempDictionary objectForKey:@"REACH"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"SHOE_SIZE"])
                            lObjAthletePtr.m_cObjShoeSizePtr = [tempDictionary objectForKey:@"SHOE_SIZE"];
                        if ((NSString *)nil != [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"U_ID"]])
                            lObjAthletePtr.m_cObjU_IDPtr = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"U_ID"]];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"ACTIVE"])
                            lObjAthletePtr.m_cObjActivePtr = [tempDictionary objectForKey:@"ACTIVE"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"NICKNAME"])
                            lObjAthletePtr.m_cObjNickNamePtr = [tempDictionary objectForKey:@"NICKNAME"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"IMAGE"])
                            lObjAthletePtr.m_cPhotoNamePtr = [tempDictionary objectForKey:@"IMAGE"];

                        lObjAthletePtr.isFavouriteAthlete = gObjAppDelegatePtr.IsinFavourites;
                        
                        
                        [lObjAthleteArrayPtr addObject:lObjAthletePtr];
                        int rowCount =[gObjAppDelegatePtr.m_cDbHandler searchForAthleteDetail:lObjAthletePtr.m_cAthleteId];
                        if (rowCount == 0)
                        {
                            [gObjAppDelegatePtr.m_cObjAthleteListPtr addObject:lObjAthletePtr];
                            gObjAppDelegatePtr.m_cObjAthleteDataStructurePtr = lObjAthletePtr;
                            [gObjAppDelegatePtr.m_cDbHandler insertAtheleteDetail:lObjAthletePtr];
                            [self informAthleteDetailDownloadNotificationToDelegate];
                        }
                        else if(rowCount > 0)
                        {
                            gObjAppDelegatePtr.m_cObjAthleteDataStructurePtr = lObjAthletePtr;
                            [gObjAppDelegatePtr.m_cDbHandler updateAthleteDetail:gObjAppDelegatePtr.m_cObjAthleteDataStructurePtr];
                            [self informAthleteDetailDownloadNotificationToDelegate];
                        }
                        SAFE_RELEASE(lObjAthletePtr)
                    }
                }
                else if(lObjStatusPtr !=0){
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
                }
            }
        }
        else{

            [gObjAppDelegatePtr stopProgressHandler];
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleAthletDetailDownloadFailed];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
        }
        SAFE_RELEASE(lObjAthleteArrayPtr)
    }
    else if (requestisFor == CombineID)
    {
        [gObjAppDelegatePtr stopProgressHandler];
        NSError *err;
        NSInteger lObjStatusPtr;
        
        NSData *response = responseData;
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:COMBINE];
                lObjStatusPtr = [[jsonArray objectForKey:DOWNLOADATHLETERESPONSEJSONKEY] integerValue];
                
                if (lObjStatusPtr == 0){
                    for (NSDictionary *tempDictionary in lObjResponseArray) {
                        
                        CombineData *lObjCombineDataPtr = (CombineData *)nil;
                        lObjCombineDataPtr = [[CombineData alloc] init];
                        
                        lObjCombineDataPtr.m_cObjCombineId = [[tempDictionary objectForKey:@"Identifier"] integerValue];
                        lObjCombineDataPtr.m_cObjCombineName = [tempDictionary objectForKey:@"CombineName"];
                        lObjCombineDataPtr.sportstype = [[tempDictionary objectForKey:@"SportsType"] integerValue];
                        lObjCombineDataPtr.m_cObjEndDate = [tempDictionary objectForKey:@"EndDate"];
                        lObjCombineDataPtr.m_cObjStartDate = [tempDictionary objectForKey:@"StartDate"];
                        lObjCombineDataPtr.m_cObjStatusPtr = [tempDictionary objectForKey:@"Status"];
                        
                        
                        int rowCount =[gObjAppDelegatePtr.m_cDbHandler searchForCombineId:lObjCombineDataPtr.m_cObjCombineId];
                        if (rowCount == 0)
                        {
                            [gObjAppDelegatePtr.m_cDbHandler insertCombineIDData:lObjCombineDataPtr];
                            
                        }
                        else if(rowCount > 0)
                        {
                            [gObjAppDelegatePtr.m_cDbHandler updateCombineIDData:lObjCombineDataPtr];
                        }
//                         [gObjAppDelegatePtr.m_cDbHandler insertCombineID:lObjCombineDataPtr];
                        
                        SAFE_RELEASE(lObjCombineDataPtr)
                        
                    }
                }
                else if(lObjStatusPtr !=0){
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineListDownloadFailed];
                }
            }
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineListDownloadSucceed];
        }
        else{
            
            [gObjAppDelegatePtr stopProgressHandler];
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineListDownloadFailed];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
        }
    }
    else if (requestisFor == CombineTests)
    {
        [gObjAppDelegatePtr stopProgressHandler];
        NSError *err;
        NSInteger lObjStatusPtr;
        
        NSData *response = responseData;
        NSString *string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"[[[[%@",string);
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:@"GCNCombineTestsNewInfoJsonResult"];
                NSMutableArray  *lObjCombineTestsArrayPtr = [lObjResponseArray objectForKey:@"CombineTestsNewData"];
                lObjStatusPtr = [[lObjResponseArray objectForKey:DOWNLOADATHLETERESPONSEJSONKEY] integerValue];
                
                if (lObjStatusPtr == 0)
                {
                    for (NSDictionary *tempDictionary in lObjCombineTestsArrayPtr)
                    {
                        Tests *lObjCombineTests = (Tests *)nil;
                        lObjCombineTests = [[Tests alloc] init];
                        
                        
                        lObjCombineTests.m_cObjTestId = [[tempDictionary objectForKey:@"TestID"] integerValue];
                        
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TestName"])
                            lObjCombineTests.m_cObjTestNamePtr = [tempDictionary objectForKey:@"TestName"];
                       
                        lObjCombineTests.m_cObjTestSequence = [[tempDictionary objectForKey:@"TestSequence"] integerValue];
                        
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TestType"])
                            lObjCombineTests.m_cObjTestTypePtr = [tempDictionary objectForKey:@"TestType"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TestDataType"])
                            lObjCombineTests.m_cObjTestDataTypePtr = [tempDictionary objectForKey:@"TestDataType"];
                        if ((NSString *)nil != [tempDictionary objectForKey:@"TestAttempts"])
                            lObjCombineTests.m_cObjTestAttemptsPtr = [tempDictionary objectForKey:@"TestAttempts"];
                        
                        
                        
                        lObjCombineTests.m_cObjCombineId = m_cObjCombineIdPtr;
                        [gObjAppDelegatePtr.m_cDbHandler insertCombineTests:lObjCombineTests];
                        SAFE_RELEASE(lObjCombineTests)
                        
                    }
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineTestDownloadSucceed];
                }
                else if(lObjStatusPtr !=0)
                {
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineTestDownloadFailed];
                }
            }
        }
        else{
            
            [gObjAppDelegatePtr stopProgressHandler];
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleCombineTestDownloadFailed];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
        }
    }

 }
//sougata added this on 16 aug
 else
 {
     [gObjAppDelegatePtr stopProgressHandler];
     gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
     UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
     lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                   message:@"Connection failed" 
                                                  delegate:nil cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
     [lObjAlertviewPtr show];
     SAFE_RELEASE(lObjAlertviewPtr)
 
 }
    //end
}
-(void)informAthleteDetailDownloadNotificationToDelegate
{
    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
    [self handleAthleteDetailDownload];
}
-(void)handleAthleteDetailDownload
{
    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleAthletDetailDownloadSucceed];
}
-(void)handleDownloadAthleteList
{
    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
//    [gObjAppDelegatePtr stopProgressHandler];
//    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
}
-(void)handleAthletePhotoDownload
{
        UIImage *lObjImagePtr = (UIImage *)nil;
        NSLog(@"Image Data %@",[[NSString alloc] initWithData:m_cObjWebDataPtr encoding:NSUTF8StringEncoding]);
        lObjImagePtr = [UIImage imageWithData:m_cObjWebDataPtr];
    
//        DSLog(@"Image Data %@",[[NSString alloc] initWithData:m_cObjWebDataPtr encoding:NSUTF8StringEncoding]);
    
        NSString *lObjFolderPathPtr =  [gObjAppDelegatePtr createPhotoFolders:m_cAthleteId];
        NSString *imagePath = (NSString *)nil;
        if ((UIImage *)nil !=lObjImagePtr)
        {
            imagePath = [lObjFolderPathPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cObjphotonamePtr]];
            gObjAppDelegatePtr.m_cObjphotonamePtr = imagePath;
            //extracting image from the picker and saving it
            
            NSData *webData = UIImagePNGRepresentation(lObjImagePtr);
//            NSData *webData = UIImageJPEGRepresentation(lObjImagePtr, 0.0);
//            NSLog(@"Image data %@",webData);
            
            [webData writeToFile:imagePath atomically:YES];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            gObjAppDelegatePtr.ImagefileExists = [fileManager fileExistsAtPath:imagePath];
            
            
            //Narasimhaiah updating the key value pair with new key value pair 26-2-13 - start
            NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
            
            if (athleteIdsPtr.count > 0) {
                for (int i=0; i<athleteIdsPtr.count; i++) {
                    if ([gObjAppDelegatePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                        
                        [gObjAppDelegatePtr.m_cObjDictionaryPtr removeObjectForKey:gObjAppDelegatePtr.m_cAthleteId];
                    }
                }
            }
            //Narasimhaiah updating the key value pair with new key value pair 26-2-13 - end                
            
            if (YES ==gObjAppDelegatePtr.ImagefileExists && (NSMutableData *)nil != m_cObjWebDataPtr)
            {
                isPhotoDownloadSucceed = YES;
                [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:imagePath forKey:gObjAppDelegatePtr.m_cAthleteId];
                NSString *lObjImageNamePtr = [imagePath lastPathComponent];
                if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7)
                {
                    [gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto:gObjAppDelegatePtr.m_cAthleteId AthPhotoname:lObjImageNamePtr];
                }
                else
                {
                    [gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto :gObjAppDelegatePtr.m_cAthleteId AthPhotoname:lObjImageNamePtr];

                }
               
                
            }
            else
            {
                isPhotoDownloadSucceed = NO;
                [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:gObjAppDelegatePtr.m_cAthleteId];
                if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7)
                {
                    [gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto:gObjAppDelegatePtr.m_cAthleteId AthPhotoname:@""];
                }
                else
                {
                    [gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto :gObjAppDelegatePtr.m_cAthleteId  AthPhotoname:@""];
                    
                }

                //[gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto :m_cAthleteId AthPhotoname:@""];
            }
        }
        else
        {
            isPhotoDownloadSucceed = NO;
            [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:gObjAppDelegatePtr.m_cAthleteId];
//            [gObjAppDelegatePtr.m_cDbHandler insertAtheletePhoto:m_cAthleteId :@""];
        }

    if([NSThread isMainThread])
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr photoDownloadSucceed];
    else
        [self performSelectorOnMainThread:@selector(informPhotoDownloadNotificationToDelegate) withObject:nil waitUntilDone:NO];
    
}
- (void)informPhotoDownloadNotificationToDelegate
{
    if (YES == isPhotoDownloadSucceed) {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr photoDownloadSucceed];
    }
    else
    {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr photoDownloadFailed];
    }
}

- (void)informPhotoUploadNotificationToDelegate
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)handleAthletePhotoUpload
{
        NSInteger ISPhotoUploadSucceed = -1;
        
        NSError *err;
        NSData *response = m_cObjWebDataPtr;
        NSLog(@"Response data %@",[[NSString alloc] initWithData:m_cObjWebDataPtr encoding:NSUTF8StringEncoding]);
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
        
        if (jsonArray.count > 0)
        {
            for (NSArray *item in jsonArray.allKeys)
            {
                
                NSMutableDictionary *lObjResponseArray = [jsonArray objectForKey:@"AthleteImageActionResult"];
                
                ISPhotoUploadSucceed = [[lObjResponseArray objectForKey:@"ResponseCode"] integerValue];
            }
        }
        
        if (1 == ISPhotoUploadSucceed) {
            
            //[gObjAppDelegatePtr.m_cObjserverTransDelegatePtr photoUploadFailed];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if(gObjAppDelegatePtr.m_cObjImageDatePtr != (NSData *)nil)
                self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = YES;
            else
                self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO;
            [gObjAppDelegatePtr.m_cDbHandler updateAthleteDetail:self.m_cObjAthletePtr];
            if(gObjAppDelegatePtr.IsAboutView == YES)
            [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
            
        }
#if 0
        else if(0 == ISPhotoUploadSucceed)
#else
        else
#endif
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if(gObjAppDelegatePtr.m_cObjImageDatePtr != (NSData *)nil)
                    self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO;
                else
                    self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO;  
                [gObjAppDelegatePtr.m_cDbHandler updateAthleteDetail:self.m_cObjAthletePtr];
            if(gObjAppDelegatePtr.IsAboutView == YES)
                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
            }
       
}
-(void)handleUpload
{    
    
    [gObjAppDelegatePtr.m_cObjAthleteListPtr addObject:self.m_cObjAthletePtr];
        
    gObjAppDelegatePtr.m_cAthleteId = self.m_cObjAthletePtr.m_cAthleteId;
    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    
    NSString *imagePath;
    NSString *tempString = [NSString stringWithFormat:@"%@",self.m_cObjAthletePtr.m_cAthleteId];
    
    if ((NSData *)nil != gObjAppDelegatePtr.m_cObjImageDatePtr) {
        NSString *m_cObjFolderPathPtr =  [gObjAppDelegatePtr createPhotoFolders:self.m_cObjAthletePtr.m_cAthleteId];
        imagePath = [m_cObjFolderPathPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.m_cObjAthletePtr.m_cAthleteId]];
        gObjAppDelegatePtr.m_cObjphotonamePtr = imagePath;
        
        if ((NSString *)nil != gObjAppDelegatePtr.m_cObjphotonamePtr) {
            self.m_cObjAthletePtr.m_cPhotoNamePtr =[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent];
            [self savePhoto:m_cObjFolderPathPtr];
        }
        else if( YES == [[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent] isEqualToString:@"Athlete--1.jpg"] )
        {
            self.m_cObjAthletePtr.m_cPhotoNamePtr = @"";
        
        }
        
        if ((NSString *)nil != self.m_cObjAthletePtr.m_cPhotoNamePtr && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
            [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:imagePath forKey:tempString];
        }
        
    }
    else{
        [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:tempString];
    }
    if (YES == gObjAppDelegatePtr.isNetworkAvailable && NO == gObjAppDelegatePtr.isOfflineData) {
        gObjAppDelegatePtr.IsAddedinOfflineMode = NO;
        gObjAppDelegatePtr.IsAthleteDetailsUploadedSuccessfully = YES;
        [gObjAppDelegatePtr.m_cDbHandler insertNewAthlete:self.m_cObjAthletePtr];
    }
    else if (YES == gObjAppDelegatePtr.isOfflineData)
    {
        gObjAppDelegatePtr.IsAddedinOfflineMode =NO;
        gObjAppDelegatePtr.IsAthleteDetailsUploadedSuccessfully = YES;
        BOOL lRetval = NO;
        int rowCount =[gObjAppDelegatePtr.m_cDbHandler searchForAthleteDetail:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
        if (rowCount > 0) {
            
            lRetval = [gObjAppDelegatePtr.m_cDbHandler updateAthleteID :self.m_cObjAthletePtr AthId:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
        }
        else
        {
            [gObjAppDelegatePtr.m_cDbHandler insertNewAthlete:self.m_cObjAthletePtr];
            
        }
    }
    else{
        gObjAppDelegatePtr.IsAddedinOfflineMode = YES;
        gObjAppDelegatePtr.IsAthleteDetailsUploadedSuccessfully = NO;
        if(gObjAppDelegatePtr.m_cObjImageDatePtr != (NSData *)nil)
        m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = YES;
        else
            m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO;
       [gObjAppDelegatePtr.m_cDbHandler insertNewAthlete:self.m_cObjAthletePtr];
    }

    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];

    if(YES == [gObjAppDelegatePtr isNetworkAvailable] && (NSData *)nil != gObjAppDelegatePtr.m_cObjImageDatePtr && gObjAppDelegatePtr.isOfflineData == NO)
    {
//        [self uploadImage :m_cObjAthletePtr];
          [gObjAppDelegatePtr uploadAthleteImage:m_cObjAthletePtr];
    }
    else if(NO == [gObjAppDelegatePtr isNetworkAvailable] && gObjAppDelegatePtr.IsAthleteDetailsUploadedSuccessfully == YES)
    {
        self.m_cObjAthletePtr.m_cIsAddedinOfflineMode = NO;
        if(gObjAppDelegatePtr.m_cObjImageDatePtr != (NSData *)nil)
        self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = YES;
        else
            self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO;
        [gObjAppDelegatePtr.m_cDbHandler updateAthleteFlagsForImage:self.m_cObjAthletePtr];
    }
}

-(void)handleUpdateAthlete
{
    gObjAppDelegatePtr.m_cAthleteId = self.m_cObjAthletePtr.m_cAthleteId;
    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    NSString    *imagePath = (NSString *)nil;
    NSString    *tempString = (NSString *)nil;
    tempString = [NSString stringWithFormat:@"%@",self.m_cObjAthletePtr.m_cAthleteId];
    
//    [self uploadImage :m_cObjAthletePtr];

    if ((NSData *)nil != gObjAppDelegatePtr.m_cObjImageDatePtr)
    {
        NSString *m_cObjFolderPathPtr =  [gObjAppDelegatePtr createPhotoFolders:self.m_cObjAthletePtr.m_cAthleteId];
        imagePath = [m_cObjFolderPathPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.m_cObjAthletePtr.m_cAthleteId]];
        gObjAppDelegatePtr.m_cObjphotonamePtr = imagePath;
        
        if ((NSString *)nil != gObjAppDelegatePtr.m_cObjphotonamePtr) {
            self.m_cObjAthletePtr.m_cPhotoNamePtr =[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent];
            [self savePhoto:m_cObjFolderPathPtr];
        }
        else if( YES == [[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent] isEqualToString:@"Athlete--1.jpg"] )
        {
            self.m_cObjAthletePtr.m_cPhotoNamePtr = @"";
        }
        
        if ((NSString *)nil != self.m_cObjAthletePtr.m_cPhotoNamePtr && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
            [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:imagePath forKey:tempString];
        }
        
    }
    else
    {
        [gObjAppDelegatePtr.m_cObjDictionaryPtr setObject:@"" forKey:tempString];
    }
    self.m_cObjAthletePtr.m_cIsAddedinOfflineMode = NO;
    self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = YES;
    IsUpdateSuccess=[gObjAppDelegatePtr.m_cDbHandler updateAthleteFlagsForImage:self.m_cObjAthletePtr];
//    if (IsUpdateSuccess==NO)
//    {
//        NSLog(@"sougata %d",IsUpdateSuccess);
//    }
//    NSLog(@"sougata %d",IsUpdateSuccess);
    if (YES == IsUpdateSuccess)
    {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
        
        //gObjAppDelegatePtr.IsUpdateForEthlete=YES;
    }
    else
    {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
    }
    if(YES == [gObjAppDelegatePtr isNetworkAvailable] && gObjAppDelegatePtr.isOfflineData == NO && (NSData *)nil != gObjAppDelegatePtr.m_cObjImageDatePtr)
        [gObjAppDelegatePtr uploadAthleteImage:self.m_cObjAthletePtr];
    else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
    {
        self.m_cObjAthletePtr.m_cIsAddedinOfflineMode = NO;
        if(gObjAppDelegatePtr.m_cObjImageDatePtr != (NSData *)nil)
        self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = YES;
        else
           self.m_cObjAthletePtr.m_cIsPhotoAddedInOfflineMode = NO; 
        [gObjAppDelegatePtr.m_cDbHandler updateNewAthlete:self.m_cObjAthletePtr];
    }

    
}
-(void)handleUpdateLog
{
//    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];//Srikant

    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    if (YES == ISUploadlogSuccess)
    {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
       // requestisFor = -1;//Srikant//sougata block this on 16 aug
    }
    else
    {
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionFailed];
    }
}
#if 0
-(void)handleLogin
{
    NSDate *lObjCurrentDate = [NSDate date];
    NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
    
	[lObjDateFormatterPtr setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [lObjDateFormatterPtr stringFromDate:lObjCurrentDate];
    
    [gObjAppDelegatePtr.m_cDbHandler insertLoginInfo:gObjAppDelegatePtr.m_cObjUserInfoPtr];
    SAFE_RELEASE(lObjDateFormatterPtr)
    
    if (YES == gObjAppDelegatePtr.m_cObjUserInfoPtr.isLoginSucceed)
    {
        gObjAppDelegatePtr.m_cIsValidationSucceed = YES;
        gObjAppDelegatePtr.m_cObjWindowPtr.rootViewController = gObjAppDelegatePtr.m_cObjTabBarControllerPtr;
        gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [NSDate date];
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading List of Athletes"];
        [self downloadRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr];
    }
    else
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    }
}
#endif

- (void)savePhoto:(NSString *)pObjPhotoUrlPtr
{
    if ((NSData *)nil !=gObjAppDelegatePtr.m_cObjImageDatePtr) {
        
        NSUInteger lImageSize = [gObjAppDelegatePtr.m_cObjImageDatePtr length];
        NSUInteger lImageSizeKb = lImageSize/1024;
        gObjAppDelegatePtr.imagesize = lImageSizeKb;
//        DSLog(@"Image size in KB is %d", lImageSizeKb);
        if ((NSString *)nil != gObjAppDelegatePtr.m_cObjphotonamePtr)
        [gObjAppDelegatePtr.m_cObjImageDatePtr writeToFile:gObjAppDelegatePtr.m_cObjphotonamePtr atomically:YES];
        
    }
}

#pragma mark - Decoder
-(NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

-(NSString *)base64forData:(NSData *)data
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
    if ([data length] == 0)
        return @"";
	
    char *characters = (char *)malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
	
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
	
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjWebDataPtr)
    SAFE_RELEASE(responseData)
    SAFE_RELEASE(m_cObjAthletePtr)
    SAFE_RELEASE(m_cObjAthleteListPtr)
    SAFE_RELEASE(m_cObjResponseArray)
    [super dealloc];
}


@end
