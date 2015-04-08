//
//  AppDelegate.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivityAlertView.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "SettingsScreenViewController.h"
#import "FavouritesViewController.h"
#import "AboutViewController.h"
#import "Macros.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "SplashImageViewController.h"
#import "AthleteLoggerViewController.h"
#import "AddAthleteViewController.h"

AppDelegate *gObjAppDelegatePtr;

@implementation AppDelegate

@synthesize m_cIsValidationSucceed;
@synthesize m_cObjTabBarControllerPtr;
@synthesize m_cObjWindowPtr,m_cObjViewControllerPtr;
@synthesize m_cObjSprintStartTimePtr,m_cObjSprintEndTimePtr,m_cObjZigZagStartTimePtr,m_cObjZigZagEndTimePtr,m_cDbHandler,m_cObjFavouriteAthleteListPtr,m_cObjAthleteListPtr;
@synthesize m_cObjUserInfoPtr;
@synthesize m_cObjDeviceIdPtr;
@synthesize m_cObjHttpHandlerPtr;
@synthesize m_cObjserverTransDelegatePtr;
@synthesize IsinFavourites;
@synthesize m_cAthleteId;
@synthesize m_cObjphotonamePtr;
@synthesize  m_cAthleteIdPtr,m_cObjLoginViewControllerPtr;
@synthesize ImagefileExists;
@synthesize m_cObjNumkeyPadString,m_cObjDictionaryPtr,m_cAutoIncrementAthleteId;
@synthesize isImageFileDownloading;
@synthesize isAlertViewShown;
@synthesize isForLogin;
@synthesize m_cObjImageDatePtr;
@synthesize m_cObjZigZagEndTimePtr2,m_cObjZigZagStartTimePtr2;
@synthesize m_cObjAthleteDataStructurePtr;
@synthesize IsAddedinOfflineMode;
@synthesize m_cSignInAttemptCount;
@synthesize m_cObjTempAthleteIdPtr;
@synthesize m_cUserSelServer;
@synthesize isConnectionTimeout;
@synthesize isOfflineData;
@synthesize isForAthleteDetailDownload;
@synthesize isForImageDownload;
@synthesize m_cObjImageHandlerDelegatePtr,isForImageUpload,IsAthleteDetailsUploadedSuccessfully,IsAboutView,IsPendingImage,m_cObjCombineIDArrayPtr,m_cObjCombineIdNameDictPtr,m_cObjCombineTestsArrayPtr,m_cObjSprintEndTimeDictPtr,m_cObjSprintStartTimeDictPtr,m_cObjLastSelectedCombineIdPtr,isDownloadForAllAthletes,responsestring,imagesize,lObjUrlResponsePtr,m_cObjOperationQueuePtr;
@synthesize m_cObjHomeViewController;
@synthesize m_cValue;
@synthesize m_cCMBNIDPtr;
@synthesize m_cObjCombineTitleStringPtr;
//@synthesize IsUpdateForEthlete;

-(id)init
{
    self = [super init];
    if (self)
    {
        m_cIsValidationSucceed = NO;
        m_cObjTabBarControllerPtr = (UITabBarController *)nil;
        m_cObjViewControllerPtr = (LoginViewController *)nil;
        m_cObjSprintStartTimePtr = (NSDate *)nil;
        m_cObjSprintEndTimePtr = (NSDate *)nil;
        m_cObjZigZagStartTimePtr = (NSDate *)nil;
        m_cObjZigZagEndTimePtr = (NSDate *)nil;
        m_cObjAthleteListPtr = (NSMutableArray *)nil;
        m_cObjFavouriteAthleteListPtr = (NSMutableArray *)nil;
        m_cObjUserInfoPtr = (UserInfo *)nil;
        m_cObjDeviceIdPtr = (NSString *)nil;
        m_cAthleteId = (NSString *)nil;
        m_cObjHttpHandlerPtr = (HttpHandler *)nil;
        IsinFavourites = NO;
        m_cAthleteIdPtr = (NSString *)nil;
        m_cObjLoginViewControllerPtr = (HomeViewController *)nil;
        m_cObjNumkeyPadString = (NSString *)nil;
        m_cObjDictionaryPtr = (NSMutableDictionary *)nil;
        m_cAutoIncrementAthleteId = 0;
        ImagefileExists = NO;
        isImageFileDownloading = NO;
        isAlertViewShown = NO;
        isForLogin = NO;
        m_cObjImageDatePtr = (NSData *)nil;
        m_cObjZigZagEndTimePtr2 = (NSDate *)nil;
        m_cObjZigZagStartTimePtr2= (NSDate *)nil;
        m_cObjAthleteDataStructurePtr = (Athlete *)nil;
        IsAddedinOfflineMode = NO;
        m_cSignInAttemptCount = 0;
        m_cObjTempAthleteIdPtr = (NSString *)nil;
        isConnectionTimeout = NO;
        isOfflineData = NO;
        isForAthleteDetailDownload = NO;
        isForImageDownload = NO;
        isForImageUpload = NO;
        m_cObjOperationQueuePtr = (NSOperationQueue *)nil;
        IsAthleteDetailsUploadedSuccessfully = NO;
        IsAboutView = NO;
        IsPendingImage = NO;
        lObjUrlResponsePtr = (NSHTTPURLResponse *)nil;


        m_cObjCombineIDArrayPtr = (NSMutableArray *)nil;
        m_cObjCombineIdNameDictPtr = (NSMutableDictionary *)nil;
        m_cObjCombineTestsArrayPtr = (NSMutableArray *)nil;
        
        m_cObjSprintEndTimeDictPtr = (NSMutableDictionary *)nil;
        m_cObjSprintStartTimeDictPtr = (NSMutableDictionary *)nil;
        isDownloadForAllAthletes = NO;
        
        
        

    }
    return self;
}
- (HomeViewController *)getHomeViewcontrollerScreen
{
    HomeViewController           *lObjHomeViewControllerPtr = (HomeViewController *)nil;
    
	if((HomeViewController *)nil == self.m_cObjHomeViewController)
	{
        lObjHomeViewControllerPtr = [[HomeViewController alloc] initWithTabBar];
		self.m_cObjHomeViewController = lObjHomeViewControllerPtr;
	}
	
	return self.m_cObjHomeViewController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    m_cValue = NO;

    
    //m_cObjCombineIDArrayPtr array for storing combine ids
    
    m_cObjCombineIDArrayPtr = [[NSMutableArray alloc]init];
    
    SplashImageViewController *lObjSplashImageViewController = (SplashImageViewController *)nil;
    gObjAppDelegatePtr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.m_cObjWindowPtr = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
    DBHandler *lObjDbHandlerPtr = [[DBHandler alloc]init];
    self.m_cDbHandler = lObjDbHandlerPtr;
    SAFE_RELEASE(lObjDbHandlerPtr)
    
    NSMutableArray *lObjAthleteArrayPtr = (NSMutableArray *)nil;
    NSMutableArray *lObjFavouriteArrayPtr = (NSMutableArray *)nil;
    
    lObjAthleteArrayPtr = [[m_cDbHandler getAllAthletes]retain];
    lObjFavouriteArrayPtr =[[m_cDbHandler getAllFavouriteAthletes]retain];
    self.m_cObjAthleteListPtr = lObjAthleteArrayPtr;
    self.m_cObjFavouriteAthleteListPtr = lObjFavouriteArrayPtr;
    
    SAFE_RELEASE(lObjAthleteArrayPtr)
    SAFE_RELEASE(lObjFavouriteArrayPtr)
      
    // Override point for customization after application launch.
    
    [self prepareTabBarItems];
    
    NSMutableDictionary *lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc] init];
    self.m_cObjDictionaryPtr = lObjDictionaryPtr;
    SAFE_RELEASE(lObjDictionaryPtr)         
    
    lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc] init];
    self.m_cObjCombineIdNameDictPtr = lObjDictionaryPtr;
    SAFE_RELEASE(lObjDictionaryPtr)
    
    lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc] init];
    self.m_cObjSprintStartTimeDictPtr = lObjDictionaryPtr;
    SAFE_RELEASE(lObjDictionaryPtr)
    
    lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc] init];
    self.m_cObjSprintEndTimeDictPtr = lObjDictionaryPtr;
    SAFE_RELEASE(lObjDictionaryPtr)
    
    
    lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc] init];
    self.m_cObjLastSelectedCombineIdPtr = lObjDictionaryPtr;
    SAFE_RELEASE(lObjDictionaryPtr) 
    
    
    NSMutableArray *lObjTestListArrayPtr = (NSMutableArray *)nil;
    lObjTestListArrayPtr = [[NSMutableArray alloc] init];
    self.m_cObjCombineTestsArrayPtr = lObjTestListArrayPtr;
    SAFE_RELEASE(lObjTestListArrayPtr)    
    
    
    //m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [NSDate date];
    
    NSDate *lObjCurrentDate = [NSDate date];
    NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
    
	[lObjDateFormatterPtr setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [lObjDateFormatterPtr stringFromDate:lObjCurrentDate];
    
    SAFE_RELEASE(lObjDateFormatterPtr)
    
    UserInfo *lObjUserInfoPtr = (UserInfo *)nil;
    lObjUserInfoPtr = [[UserInfo alloc]init];
    self.m_cObjUserInfoPtr = lObjUserInfoPtr;
    SAFE_RELEASE(lObjUserInfoPtr)

	HttpHandler *lObjHttpHandlerPtr = (HttpHandler *)nil;
    lObjHttpHandlerPtr = [[HttpHandler alloc]init];
    self.m_cObjHttpHandlerPtr = lObjHttpHandlerPtr;
    SAFE_RELEASE(lObjHttpHandlerPtr)
    
    //get the unique ID here
    char lMacAddressString[MAC_ADRS_LENGTH] = {0};
    [self getMacAddress:lMacAddressString];
    m_cObjDeviceIdPtr = [[NSString alloc] initWithCString:lMacAddressString encoding:NSUTF8StringEncoding];
    DSLog(@"mac id = %@", m_cObjDeviceIdPtr);
    
    lObjSplashImageViewController = [[SplashImageViewController alloc]init];
    [self.m_cObjWindowPtr setRootViewController:lObjSplashImageViewController];
    SAFE_RELEASE(lObjSplashImageViewController)
    [self.m_cObjWindowPtr makeKeyAndVisible];
    return YES;
}

#pragma mark - Mac Address
- (void)getMacAddress:(char*)pObjMacAddressPtr
{
    int lRetVal = 0;
    struct ifaddrs *lAddress;
    struct ifaddrs *lCursor;
    const struct sockaddr_dl *lDlAddr;
   const unsigned char *lBase;
    
   lRetVal = getifaddrs(&lAddress) == 0;
    if (lRetVal) {
        lCursor = lAddress;
        while (lCursor != 0) {
            if ( (lCursor->ifa_addr->sa_family == AF_LINK)
                           && (((const struct sockaddr_dl *) lCursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp("en0", lCursor->ifa_name)==0 ) {
                lDlAddr = (const struct sockaddr_dl *) lCursor->ifa_addr;
                lBase = (const unsigned char*) &lDlAddr->sdl_data[lDlAddr->sdl_nlen];
                strcpy(pObjMacAddressPtr, "");
               for (int i = 0; i < lDlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(pObjMacAddressPtr, ":");
                       }
                    char partialAddr[3] = {0};
                   sprintf(partialAddr, "%02X", lBase[i]);
                   strcat(pObjMacAddressPtr, partialAddr);
                  }
                }
            lCursor = lCursor->ifa_next;
            }
        freeifaddrs(lAddress);
        }
}
-(void)prepareTabBarItems
{
    m_cObjHomeViewController                =   (HomeViewController *)nil;

    SettingsScreenViewController       *lObjSettingsScreenViewController                =   (SettingsScreenViewController *)nil;
    AboutViewController       *lObjAboutViewController                =   (AboutViewController *)nil;
    
    NSMutableArray           *lObjViewControllersArrayPtr           =   (NSMutableArray *)nil;
    lObjViewControllersArrayPtr     = [[NSMutableArray alloc] init];

    [self addViewToNavController:[gObjAppDelegatePtr getHomeViewcontrollerScreen] :lObjViewControllersArrayPtr];
    SAFE_RELEASE(m_cObjHomeViewController)

    
    lObjSettingsScreenViewController  = [[SettingsScreenViewController alloc] initWithTabBar];
    [self addViewToNavController:lObjSettingsScreenViewController :lObjViewControllersArrayPtr];
    SAFE_RELEASE(lObjSettingsScreenViewController)
    
    lObjAboutViewController  = [[AboutViewController alloc] initWithTabBar];
    [self addViewToNavController:lObjAboutViewController :lObjViewControllersArrayPtr];    SAFE_RELEASE(lObjSettingsScreenViewController)


    
    UITabBarController *lObjTabBarCntrlr = [[UITabBarController alloc] init];
    self.m_cObjTabBarControllerPtr = lObjTabBarCntrlr;
    SAFE_RELEASE(lObjTabBarCntrlr)
    self.m_cObjTabBarControllerPtr.delegate = self;
    self.m_cObjTabBarControllerPtr.viewControllers = lObjViewControllersArrayPtr;
    
    self.m_cObjTabBarControllerPtr.moreNavigationController.navigationBarHidden = NO;
    self.m_cObjTabBarControllerPtr.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    SAFE_RELEASE(lObjViewControllersArrayPtr)
}

-(void)displayLoginPage
{
    LoginViewController *lObjViewContrlr = [[LoginViewController alloc] init];
    self.m_cObjViewControllerPtr  = lObjViewContrlr;
    SAFE_RELEASE(lObjViewContrlr)
    UINavigationController *lObjNavigationContrlrPtr = [[UINavigationController alloc] initWithRootViewController:m_cObjViewControllerPtr];
    lObjNavigationContrlrPtr.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.m_cObjWindowPtr setRootViewController:lObjNavigationContrlrPtr];
    SAFE_RELEASE(lObjNavigationContrlrPtr)
    
}

//Narasimhaiah adding for athlete Image Download 25-2-13 - start
-(void)downloadAthleteImage:(Athlete *)pObjAthletePtr
{
//    self.m_cObjAthleteDataStructurePtr = pObjAthletePtr;
    m_cObjserverTransDelegatePtr = self;
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
    if (YES ==[gObjAppDelegatePtr isNetworkAvailable]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        m_cObjOperationQueuePtr = (NSOperationQueue *)nil;
//        if ((NSOperationQueue *)nil != m_cObjOperationQueuePtr)
        m_cObjOperationQueuePtr = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *lObjInvocationPtr = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(perfromInDownloadQueue:) object:pObjAthletePtr];
        [m_cObjOperationQueuePtr addOperation:lObjInvocationPtr];
        SAFE_RELEASE(lObjInvocationPtr)
    }
    else{
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
-(void)perfromInDownloadQueue:(Athlete *)pObjAthletePtr
{
    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteImage :pObjAthletePtr.m_cAthleteId AthImageName:pObjAthletePtr.m_cPhotoNamePtr];
}
-(void)photoDownloadSucceed
{
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [m_cObjOperationQueuePtr cancelAllOperations];
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadSucceed];

}
-(void)photoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [m_cObjOperationQueuePtr cancelAllOperations];
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadFailed];    
}

-(void)uploadAthleteImage:(Athlete *)pObjAthletePtr
{
    if (NO == gObjAppDelegatePtr.IsAboutView)
    {
        m_cObjserverTransDelegatePtr = self;
    }

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        m_cObjOperationQueuePtr = (NSOperationQueue *)nil;
//        if ((NSOperationQueue *)nil != m_cObjOperationQueuePtr)
            m_cObjOperationQueuePtr = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *lObjInvocationPtr = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(perfromInUploadQueue:) object:pObjAthletePtr];
        [m_cObjOperationQueuePtr addOperation:lObjInvocationPtr];
        [m_cObjOperationQueuePtr setMaxConcurrentOperationCount:2];
        SAFE_RELEASE(lObjInvocationPtr)
}

-(void)perfromInUploadQueue:(Athlete *)pObjAthletePtr
{
    if(YES == [gObjAppDelegatePtr isNetworkAvailable])
    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadImage:pObjAthletePtr];
}
//Narasimhaiah adding for athlete Image Download 25-2-13 - end



#pragma mark - Audio & Video Folder Creation Method
- (NSString *)createPhotoFolders:(NSString *)pObjAthleteId
{
    NSFileManager   *lObjFileMangrPtr = (NSFileManager *)nil;
    NSArray         *lObjDocumentDirsListPtr = (NSArray *)nil;
    NSString        *lObjDocumentDirPathPtr = (NSString *)nil;
    NSString        *lObjRootFolderPathPtr = (NSString *)nil;
//    NSString        *lObjTransFolderPathPtr = (NSString *)nil;
   
    
    lObjFileMangrPtr = [NSFileManager defaultManager];
    lObjDocumentDirsListPtr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    lObjDocumentDirPathPtr = [lObjDocumentDirsListPtr objectAtIndex:0];
    
    lObjRootFolderPathPtr = [lObjDocumentDirPathPtr stringByAppendingPathComponent:@"Photo"];
//    lObjTransFolderPathPtr = [NSString stringWithFormat:@"%@/%@" ,lObjRootFolderPathPtr,pObjAthleteId];
    
        
    if(NO == [lObjFileMangrPtr fileExistsAtPath:lObjRootFolderPathPtr])
        [lObjFileMangrPtr createDirectoryAtPath:lObjRootFolderPathPtr withIntermediateDirectories:YES attributes:nil error:nil];
    
    return lObjRootFolderPathPtr;
}
- (NSString *)getPhotoFolders :(NSString *)pObjAthleteId AthImageName:(NSString *)pObjAthleteImageNamePtr
{
    NSFileManager   *lObjFileMangrPtr = (NSFileManager *)nil;
    NSArray         *lObjDocumentDirsListPtr = (NSArray *)nil;
    NSString        *lObjDocumentDirPathPtr = (NSString *)nil;
    NSString        *lObjRootFolderPathPtr = (NSString *)nil;
    NSString        *lObjTransFolderPathPtr = (NSString *)nil;
    
    
    lObjFileMangrPtr = [NSFileManager defaultManager];
    lObjDocumentDirsListPtr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    lObjDocumentDirPathPtr = [lObjDocumentDirsListPtr objectAtIndex:0];
    
    lObjRootFolderPathPtr = [lObjDocumentDirPathPtr stringByAppendingPathComponent:@"Photo"];
    
    //get the Date time Short Style
    if ((NSString *)nil != pObjAthleteId) {
        lObjTransFolderPathPtr = [NSString stringWithFormat:@"%@/%@.jpg" ,lObjRootFolderPathPtr,pObjAthleteId];
    }
    else
    {
        lObjTransFolderPathPtr = [NSString stringWithFormat:@"%@/%@" ,lObjRootFolderPathPtr,pObjAthleteImageNamePtr];
    }
    return lObjTransFolderPathPtr;
}

-(void)serverTransactionSucceeded
{
    if(YES == isForImageDownload)
    {
        
        
    }
    else
    {
        self.m_cObjWindowPtr.userInteractionEnabled = YES;
        [self stopProgressHandler];
    }
}

-(void)serverTransactionFailed
{
    if (YES == isForImageDownload) {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
        self.m_cObjWindowPtr.userInteractionEnabled = YES;
        [self stopProgressHandler];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    else{
        self.m_cObjWindowPtr.userInteractionEnabled = YES;
        [self stopProgressHandler];
    }
}

//- (void)photoUploadFailed
//{
//    
//}
//
//- (void)photoUploadSucceed
//{
//    
//}

#pragma mark - Network Availablity
- (BOOL)isNetworkAvailable
{
    
#if 0
    struct sockaddr_in			lZeroAddress = {0};
	SCNetworkReachabilityRef	lDefaultRouteReachabilityPtr = (SCNetworkReachabilityRef)nil;
    SCNetworkReachabilityFlags	lFlags = 0;
	BOOL						lDidRetrieveFlags = NO,
    lIsReachable = NO,
    lNeedsConnection = NO,
    lRetVal = NO;
    
    bzero(&lZeroAddress, sizeof(lZeroAddress));
    
    lZeroAddress.sin_len = sizeof(lZeroAddress);
    lZeroAddress.sin_family = AF_INET;
    
    //Recover reachability flags
    lDefaultRouteReachabilityPtr = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&lZeroAddress);
    
	if((SCNetworkReachabilityRef)nil != lDefaultRouteReachabilityPtr)
	{
		lDidRetrieveFlags = SCNetworkReachabilityGetFlags(lDefaultRouteReachabilityPtr, &lFlags);
        
		SAFE_CFRELEASE(lDefaultRouteReachabilityPtr)
	}
    
    if(YES == lDidRetrieveFlags)
    {
		lIsReachable = (kSCNetworkFlagsReachable == (lFlags & kSCNetworkFlagsReachable));
		lNeedsConnection = (kSCNetworkFlagsConnectionRequired == (lFlags & kSCNetworkFlagsConnectionRequired));
        
		lRetVal = (YES == lIsReachable && NO == lNeedsConnection);
    }
	return lRetVal;
    
#endif
    
    struct sockaddr_in			lZeroAddress = {0};
	SCNetworkReachabilityRef	lDefaultRouteReachabilityPtr = (SCNetworkReachabilityRef)nil;
    SCNetworkReachabilityFlags	lFlags = 0;
	BOOL						lDidRetrieveFlags = NO,
    lIsReachable = NO,
    lNeedsConnection = NO,
    lRetVal = NO;
    
    bzero(&lZeroAddress, sizeof(lZeroAddress));
    
    lZeroAddress.sin_len = sizeof(lZeroAddress);
    lZeroAddress.sin_family = AF_INET;
    
    //Recover reachability flags
    lDefaultRouteReachabilityPtr = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&lZeroAddress);
    
	if((SCNetworkReachabilityRef)nil != lDefaultRouteReachabilityPtr)
	{
		lDidRetrieveFlags = SCNetworkReachabilityGetFlags(lDefaultRouteReachabilityPtr, &lFlags);
        
        CFRelease(lDefaultRouteReachabilityPtr);
        lDefaultRouteReachabilityPtr = nil;
	}
    
    if(YES == lDidRetrieveFlags)
    {
		lIsReachable = (kSCNetworkFlagsReachable == (lFlags & kSCNetworkFlagsReachable));
		lNeedsConnection = (kSCNetworkFlagsConnectionRequired == (lFlags & kSCNetworkFlagsConnectionRequired));
        
		lRetVal = (YES == lIsReachable && NO == lNeedsConnection);
    }
	return lRetVal;

    
    
    
    
}

- (void)addViewToNavController:(UIViewController *)pObjRootViewControllerPtr
							  :(NSMutableArray *)pObjControllersArrayPtr
{
	UINavigationController	*lObjNavigationControllerPtr = (UINavigationController *)nil;
    
	//Create the nav controller and add the root view controller as its first view
	lObjNavigationControllerPtr = [[UINavigationController alloc] initWithRootViewController:
								   pObjRootViewControllerPtr];
	lObjNavigationControllerPtr.navigationBar.barStyle = UIBarStyleBlackOpaque;
	lObjNavigationControllerPtr.navigationBarHidden = NO;
    
	//Add the new nav controller (with the root view controller inside it) to the array of controllers
	[pObjControllersArrayPtr addObject:lObjNavigationControllerPtr];
    
    SAFE_RELEASE(lObjNavigationControllerPtr)
}

#pragma mark - AlertMsg
- (void)showAlertMsg:(NSString *)pObjMsgPtr Tag:(NSInteger)pTag delegate:(id)pObjDelegatePtr
{
    UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
    
    lObjAlertViewPtr = [[UIAlertView alloc]initWithTitle:
                        @"Athlete Logger" message:pObjMsgPtr
                                                delegate:pObjDelegatePtr
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil, nil];
    lObjAlertViewPtr.tag = pTag;
    [lObjAlertViewPtr show];
    SAFE_RELEASE(lObjAlertViewPtr)
}

- (void)displayProgressHandler:(NSString *)pObjMsgptr
{
    if (m_cObjLoginViewControllerPtr == (HomeViewController *)nil)
    {
        m_cObjLoginViewControllerPtr = [[HomeViewController alloc]initWithTabBar];
    }
    if((ActivityAlertView *)nil == m_cObjCustomAlertViewPtr)
    {
        CGRect lRect = {0};
        lRect = CGRectMake(0.0, 0.0, SPACING*35, SPACING*24);
        m_cObjCustomAlertViewPtr = [[ActivityAlertView alloc]initWithFrame:lRect];             
    }        
        [self.m_cObjWindowPtr addSubview:m_cObjCustomAlertViewPtr];
        m_cObjCustomAlertViewPtr.center = CGPointMake(320.0/2.0, 460.0/2.0);
        [m_cObjCustomAlertViewPtr startActivityIndicator:pObjMsgptr];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;//sougata addedd this on 8/8/13
    //SAFE_RELEASE(m_cObjLoginViewControllerPtr)//Srikant
}

- (void)stopProgressHandler
{
    if((ActivityAlertView *)nil != m_cObjCustomAlertViewPtr)  
    {
    [m_cObjCustomAlertViewPtr close];
        [m_cObjCustomAlertViewPtr removeFromSuperview];    
        SAFE_RELEASE(m_cObjCustomAlertViewPtr)
    }
}
- (void)showCustomActitvityIndicatorView
{
    
        if((ActivityAlertView *)nil == m_cObjAIPtr)
        {
          
                m_cObjAIPtr = [[ActivityAlertView alloc]initWithFrame:self.m_cObjWindowPtr.bounds];
                [self.m_cObjWindowPtr addSubview:m_cObjAIPtr];
                [self.m_cObjWindowPtr bringSubviewToFront:m_cObjAIPtr];
            }
        
}
- (void)stopCustomActivityIndicatorAnimation
{
   
        if((ActivityAlertView *)nil != m_cObjAIPtr)
        {
            [m_cObjAIPtr removeFromSuperview];
            SAFE_RELEASE(m_cObjAIPtr);
        }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
    SAFE_RELEASE(m_cObjLoginViewControllerPtr)

    SAFE_RELEASE(m_cObjLastSelectedCombineIdPtr)
    SAFE_RELEASE(m_cObjCombineTestsArrayPtr)
    SAFE_RELEASE(m_cObjCombineIdNameDictPtr)
    SAFE_RELEASE(m_cObjCombineIDArrayPtr)
    SAFE_RELEASE(m_cObjOperationQueuePtr)
    SAFE_RELEASE(m_cObjAthleteDataStructurePtr)
    SAFE_RELEASE(m_cObjUserInfoPtr)
    SAFE_RELEASE(m_cObjHttpHandlerPtr)
    SAFE_RELEASE(m_cDbHandler)
    SAFE_RELEASE(m_cObjWindowPtr)
    SAFE_RELEASE(m_cObjViewControllerPtr)
    SAFE_RELEASE(m_cObjTabBarControllerPtr)
    SAFE_RELEASE(m_cObjDeviceIdPtr)
    SAFE_RELEASE(m_cObjDictionaryPtr)

    [super dealloc];
}


@end
