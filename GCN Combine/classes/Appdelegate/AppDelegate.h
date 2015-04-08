//
//  AppDelegate.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "DBHandler.h"
#import "Athlete.h"
#import "HttpHandler.h"
#import "ServerTransactionDelegate.h"
#import "ActivityAlertView.h"
#import "HomeViewController.h"
#import "AthleteLog.h"
#import "ImageHandlerDelegate.h"
#import "SettingsScreenViewController.h"

@protocol ServerTransactionDelegate;
@protocol ImageHandlerDelegate;


@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,ServerTransactionDelegate,ImageHandlerDelegate>
{
    BOOL                    m_cIsValidationSucceed;
    UITabBarController      *m_cObjTabBarControllerPtr;
    LoginViewController     *m_cObjViewControllerPtr;
    NSDate                  *m_cObjSprintStartTimePtr;
    NSDate                  *m_cObjSprintEndTimePtr;
    NSDate                  *m_cObjZigZagStartTimePtr;
    NSDate                  *m_cObjZigZagEndTimePtr;
    NSMutableArray          *m_cObjAthleteListPtr;
    NSMutableArray          *m_cObjFavouriteAthleteListPtr;
    DBHandler               *m_cDbHandler;
    NSString                *m_cAthleteId;
    HttpHandler             *m_cObjHttpHandlerPtr;
    UserInfo                *m_cObjUserInfoPtr;
    NSString                *m_cObjDeviceIdPtr;
    id<ServerTransactionDelegate>  m_cObjserverTransDelegatePtr;
    BOOL                    IsinFavourites;
    NSString                *m_cObjphotonamePtr;
    NSString                *m_cAthleteIdPtr;
    ActivityAlertView       *m_cObjCustomAlertViewPtr;
    HomeViewController     *m_cObjLoginViewControllerPtr;
    NSString                *m_cObjNumkeyPadString;
    NSMutableDictionary     *m_cObjDictionaryPtr;
    NSInteger                m_cAutoIncrementAthleteId;
    BOOL                        ImagefileExists;
    BOOL                        isImageFileDownloading;
    BOOL                        isAlertViewShown;
    BOOL                        isForLogin;
    NSData                      *m_cObjImageDatePtr;
    NSDate                 *m_cObjZigZagStartTimePtr2;
    NSDate                 *m_cObjZigZagEndTimePtr2;
    Athlete                 *m_cObjAthleteDataStructurePtr;
    BOOL                    IsAddedinOfflineMode;
    NSInteger               m_cSignInAttemptCount;
    NSString                *m_cObjTempAthleteIdPtr;

    NSString                        *m_cUserSelServer;
    BOOL                    isConnectionTimeout;
    BOOL                    isOfflineData;
    BOOL                    isForAthleteDetailDownload;
    BOOL                    isForImageDownload;
    BOOL                    isForImageUpload;
    NSOperationQueue        *m_cObjOperationQueuePtr;
    NSMutableArray          *m_cObjCombineIDArrayPtr;
    NSMutableDictionary     *m_cObjCombineIdNameDictPtr;
    id<ImageHandlerDelegate>    m_cObjImageHandlerDelegatePtr;
    NSMutableArray          *m_cObjCombineTestsArrayPtr;
    
    
    NSMutableDictionary     *m_cObjSprintStartTimeDictPtr;
    NSMutableDictionary     *m_cObjSprintEndTimeDictPtr;
    NSMutableDictionary     *m_cObjLastSelectedCombineIdPtr;
    
    
    BOOL                    IsPendingImage;
    BOOL                    IsAboutView;
    BOOL                    IsAthleteDetailsUploadedSuccessfully;
    BOOL                    isDownloadForAllAthletes;
    NSString                *responsestring;
    NSInteger               imagesize;
    NSHTTPURLResponse *lObjUrlResponsePtr;
    ActivityAlertView               *m_cObjAIPtr;
    HomeViewController       *m_cObjHomeViewController;
    BOOL                        m_cValue;
    NSString                *m_cCMBNIDPtr;
    NSString                *m_cObjCombineTitleStringPtr;
    //BOOL                    IsUpdateForEthlete;//sougata added this. on 14 aug

}
@property(nonatomic,copy)NSString        *m_cObjCombineTitleStringPtr;
@property(nonatomic,assign)BOOL                        m_cValue;
@property(nonatomic,copy)NSString                *m_cCMBNIDPtr;
@property(nonatomic,retain) HomeViewController       *m_cObjHomeViewController ;
@property (nonatomic,retain)    NSHTTPURLResponse *lObjUrlResponsePtr;
@property (nonatomic,retain)    NSMutableArray          *m_cObjCombineTestsArrayPtr;
@property (nonatomic,retain)    NSMutableDictionary     *m_cObjCombineIdNameDictPtr;
@property (nonatomic,retain)    NSMutableArray          *m_cObjCombineIDArrayPtr;
@property (nonatomic,assign)id<ImageHandlerDelegate>    m_cObjImageHandlerDelegatePtr;

@property (nonatomic)    BOOL                    isForImageDownload;
@property (nonatomic)    BOOL                    isForAthleteDetailDownload;
@property (nonatomic)    BOOL                    isOfflineData;
//@property (nonatomic)    BOOL                    IsUpdateForEthlete;

@property (nonatomic)    BOOL                    isConnectionTimeout;
@property (nonatomic,copy)NSString                        *m_cUserSelServer;
@property (nonatomic,copy)    NSString                *m_cObjTempAthleteIdPtr;
@property (nonatomic,assign)    NSInteger               m_cSignInAttemptCount;
@property (nonatomic)    BOOL                       IsAddedinOfflineMode;
@property (nonatomic,retain)    Athlete             *m_cObjAthleteDataStructurePtr;
@property (nonatomic,retain)    NSData              *m_cObjImageDatePtr;
@property (nonatomic)    BOOL                        isForLogin;
@property (nonatomic)    BOOL                        isAlertViewShown;
@property (nonatomic)    BOOL                        isImageFileDownloading;
@property (nonatomic,copy)    NSString                *m_cObjNumkeyPadString;
@property (nonatomic)        BOOL                ImagefileExists;
@property (nonatomic,copy)    NSString                *m_cObjphotonamePtr;
@property (nonatomic,assign) id<ServerTransactionDelegate>  m_cObjserverTransDelegatePtr;
@property (nonatomic,copy) NSString           *m_cAthleteId;
@property (nonatomic , retain) UIWindow              *m_cObjWindowPtr;
@property (nonatomic)         BOOL                  m_cIsValidationSucceed;
@property (nonatomic,retain)  UITabBarController    *m_cObjTabBarControllerPtr;
@property (nonatomic , retain) LoginViewController   *m_cObjViewControllerPtr;
@property (nonatomic,retain) NSDate                 *m_cObjSprintStartTimePtr;
@property (nonatomic,retain) NSDate                 *m_cObjSprintEndTimePtr;
@property (nonatomic,retain) NSDate                 *m_cObjZigZagStartTimePtr;
@property (nonatomic,retain) NSDate                 *m_cObjZigZagEndTimePtr;
@property (nonatomic,retain) NSDate                 *m_cObjZigZagStartTimePtr2;
@property (nonatomic,retain) NSDate                 *m_cObjZigZagEndTimePtr2;
@property (nonatomic,retain) NSMutableArray          *m_cObjAthleteListPtr;
@property (nonatomic,retain) NSMutableArray          *m_cObjFavouriteAthleteListPtr;
@property (nonatomic,retain) DBHandler               *m_cDbHandler;
@property (nonatomic,retain) HttpHandler            *m_cObjHttpHandlerPtr;
@property (nonatomic,retain)NSString              *m_cObjDeviceIdPtr;
@property (nonatomic,retain) UserInfo               *m_cObjUserInfoPtr;
@property (nonatomic)     BOOL                    IsinFavourites;
@property (nonatomic,copy)  NSString               *m_cAthleteIdPtr;
@property (nonatomic,retain) HomeViewController     *m_cObjLoginViewControllerPtr;
@property (nonatomic,retain) NSMutableDictionary     *m_cObjDictionaryPtr;
@property (nonatomic,assign) NSInteger                m_cAutoIncrementAthleteId;

@property (nonatomic,retain) NSMutableDictionary          *m_cObjSprintStartTimeDictPtr;
@property (nonatomic,retain) NSMutableDictionary          *m_cObjSprintEndTimeDictPtr;
@property (nonatomic,retain) NSMutableDictionary          *m_cObjLastSelectedCombineIdPtr;
@property (nonatomic)    BOOL                    IsPendingImage;
@property (nonatomic)    BOOL                    IsAboutView;
@property (nonatomic)    BOOL                    IsAthleteDetailsUploadedSuccessfully;
@property (nonatomic)    BOOL                    isForImageUpload;
@property (nonatomic)    BOOL                    isDownloadForAllAthletes;
@property (nonatomic,copy)    NSString                *responsestring;
@property (nonatomic,assign)    NSInteger               imagesize;

@property (nonatomic,assign) NSOperationQueue        *m_cObjOperationQueuePtr;
- (NSString *)createPhotoFolders:(NSString *)pObjAthleteId;
- (void)showAlertMsg:(NSString *)pObjMsgPtr Tag:(NSInteger)pTag delegate:(id)pObjDelegatePtr;
-(void)prepareTabBarItems;
-(void)displayLoginPage;
-(void)addViewToNavController:(UIViewController *)pObjRootViewControllerPtr
                             :(NSMutableArray *)pObjControllersArrayPtr;
- (NSString *)getPhotoFolders :(NSString *)pObjAthleteId AthImageName:(NSString *)pObjAthleteImageNamePtr;
- (void)displayProgressHandler:(NSString *)pObjMsgptr;
- (void)stopProgressHandler;

- (BOOL)isNetworkAvailable;

- (void)getMacAddress:(char*)pObjMacAddressPtr;
-(void)downloadAthleteImage:(Athlete *)pObjAthletePtr;
-(void)perfromInDownloadQueue:(Athlete *)pObjAthletePtr;
-(void)uploadAthleteImage:(Athlete *)pObjAthletePtr;
-(void)perfromInUploadQueue:(Athlete *)pObjAthletePtr;
- (HomeViewController *)getHomeViewcontrollerScreen;

@end
