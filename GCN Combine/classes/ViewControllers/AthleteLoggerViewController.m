//
//  AthleteLoggerViewController.m
//  GCN Combine
//
//  Created by Debi Samantrai on 03/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AthleteLoggerViewController.h"
#import "Macros.h"
#import <QuartzCore/QuartzCore.h>
#import "AddAthleteTableViewCell.h"
#import "AddAthleteDetailsTableViewCell.h"
#import "AppDelegate.h"
#import "EditAthleteViewController.h"
#import "LogViewController.h"

@implementation AthleteLoggerViewController
@synthesize m_cObjAthleteDetailStructurePtr;
@synthesize m_cObjFolderPathPtr;
@synthesize m_cObjImagePtr;
@synthesize m_cObjAthleteLogPtr;
@synthesize isIDexists;
@synthesize isForLog;
@synthesize m_cObjImageBtnPtr;
@synthesize m_cObjImageNamePathPtr;
@synthesize m_cObjCombineListPtr,m_cObjPickerToolBarPtr,m_cObjPickerViewPtr;
@synthesize m_cObjCombineIdTextFieldPtr,m_cTestCount,m_cObjCombineIDsPtr;
@synthesize m_cObjAthleteLogArrayPtr,m_cObjCombineIdPtr,keyboardDoneButtonView,m_cObjCombineNamePtr;
@synthesize lObjAddFavButton,isIdexists,isOfflineData;

- (id)init
{
    self = [super init];
    if (self) {
        
        m_cTotalNoOfRows = 0;
        // Custom initialization
        
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
        self.navigationItem.title = @"Athlete Details";
       m_cObjToolBarPtr = (UIToolbar *)nil;
       
        IsFirstNameValidationSuccess = YES;
        IsLastNameValidationSuccess = YES;
        IsEmailValidationSuccess = YES;
        m_cObjAthleteDetailStructurePtr = (Athlete *)nil;
        IsPhotoDeleted = NO;
        
        Athlete *lObjAthleteDetailStructurePtr = (Athlete *)nil;
        lObjAthleteDetailStructurePtr = [[Athlete alloc]init];
        self.m_cObjAthleteDetailStructurePtr = lObjAthleteDetailStructurePtr;
        SAFE_RELEASE(lObjAthleteDetailStructurePtr)
        
        AthleteLog  *lObjAthleteLogPtr = (AthleteLog *)nil;
        lObjAthleteLogPtr = [[AthleteLog alloc] init];
        self.m_cObjAthleteLogPtr = lObjAthleteLogPtr;
        SAFE_RELEASE(lObjAthleteLogPtr)
        
        
        m_cObjOperationQueuePtr = (NSOperationQueue *)nil;
        
        isForLog = NO;
        isIdexists = NO;
        
        
        
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.navigationController.navigationBar.hidden=NO;
    UIBarButtonItem *lObjContactButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(onEditButtonPressed:)];
    self.navigationItem.rightBarButtonItem=lObjContactButton;

    
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
    m_cApplicationSize = self.view.frame;
   // CGRect              lScrollRect = CGRectZero;
   
   // lScrollRect = CGRectMake(CGRectGetMinY(self.view.frame), 64, CGRectGetWidth(self.view.frame), self.view.frame.size.height-64);
    
    CGRect              lScrollRect = CGRectZero;
    lScrollRect = CGRectMake(CGRectGetMinY(self.view.bounds), CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds));
    
    
    m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:lScrollRect];
    m_cObjScrollViewPtr.scrollEnabled = YES;
    m_cObjScrollViewPtr.delegate = self;
    m_cObjScrollViewPtr.backgroundColor=[UIColor clearColor];
#if 1
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 750.0); // scrollview height for all tests
#else
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 920.0); // scrollview height for combine tests
#endif
    m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
       
   
    
    
    
    
    [self createImageControls];
    [self createElements];
    [self.view addSubview:m_cObjScrollViewPtr];
}
-(void)createElements
{
    UIBarButtonItem     *lObjBackBtnPtr = (UIBarButtonItem *)nil;
	CGRect				lObjRect = CGRectZero;
    CGRect              lRect = CGRectZero;
    
    
    lObjBackBtnPtr = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackButtonPressed:)];
    self.navigationItem.leftBarButtonItem = lObjBackBtnPtr;
    SAFE_RELEASE(lObjBackBtnPtr)
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lObjRect = CGRectMake(CGRectGetMaxX(self.m_cObjImageBtnPtr.frame)+2,  -25, CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(self.m_cObjImageBtnPtr.frame)-5, 165);
    }
    else
    {
         lObjRect = CGRectMake(CGRectGetMaxX(self.m_cObjImageBtnPtr.frame)+2, CGRectGetMinY(self.m_cObjImageBtnPtr.frame) - 10, CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(self.m_cObjImageBtnPtr.frame)-5, 150);
    }
    
    
    
    //
    m_cObjUpperEditTablePtr = [[UITableView alloc] initWithFrame:lObjRect style:UITableViewStyleGrouped];
	m_cObjUpperEditTablePtr.backgroundColor = [UIColor clearColor];
    m_cObjUpperEditTablePtr.backgroundView = nil;
	m_cObjUpperEditTablePtr.delegate = self;
	m_cObjUpperEditTablePtr.dataSource = self;
	m_cObjUpperEditTablePtr.autoresizesSubviews = YES;
	m_cObjUpperEditTablePtr.scrollEnabled = NO;
	m_cObjUpperEditTablePtr.allowsSelectionDuringEditing = YES;
    m_cObjUpperEditTablePtr.alpha = 1.0;
    m_cObjUpperEditTablePtr.tag = ADDATHLETEUPPERTABLE;
    [m_cObjScrollViewPtr addSubview:m_cObjUpperEditTablePtr];
    
    
    //Narasimhaiah adding the textfield to add the combine id selector 1-3-13 - start
    m_cApplicationSize = self.view.frame;
    lRect = m_cApplicationSize;
    
    lRect =	CGRectMake(SPACING * 4, CGRectGetMaxY(m_cObjUpperEditTablePtr.frame)+SPACING *2 , 290.0 , STANDARD_BUTTON_DIMENSION);
    
    
    NSMutableDictionary *lObjTempDict = (NSMutableDictionary *)nil;
    lObjTempDict = [[gObjAppDelegatePtr.m_cDbHandler getCombineIdAndNames] retain];
    gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr = lObjTempDict;
    SAFE_RELEASE(lObjTempDict)
    //    NSLog(@"Retain count %d",[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr retainCount]);
    m_cObjCombineListPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allValues]] retain];
    m_cObjCombineIDsPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allKeys]] retain];
    
    
    //    gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests:[m_cObjCombineIDsPtr objectAtIndex:0] :[m_cObjCombineListPtr objectAtIndex:0]];
    if (gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr.count > 0) {
        
        if(gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.count > 0)
        {
            NSArray *lObjKeysPtr = gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.allKeys;
            
            for (int i=0; i<lObjKeysPtr.count; i++) {
                if ([self.m_cObjAthleteDetailStructurePtr.m_cAthleteId isEqualToString:[lObjKeysPtr objectAtIndex:i]])
                {
                    isIdexists = YES;
                    m_cObjCombineIdPtr = [[gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr objectForKey:[lObjKeysPtr objectAtIndex:i]] integerValue];
                    m_cObjCombineNamePtr = [gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr objectForKey:[NSString stringWithFormat:@"%d",m_cObjCombineIdPtr]];
                    
#if 0  //Srikant
                    if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count > 0)
                    {
                        [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr removeAllObjects];
                    }
                    
                    gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests :[[m_cObjCombineIDsPtr objectAtIndex:i] integerValue] CombineName:[m_cObjCombineListPtr objectAtIndex:i]];
#endif
                    break;
                }
                else
                {
                    isIdexists = NO;
                }
            }
        }
        if (0 < m_cObjCombineListPtr.count && NO == isIdexists)
        {
#if 0//Srikant
            if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count > 0) {
                [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr removeAllObjects];
            }
            m_cObjCombineIdPtr = [[m_cObjCombineIDsPtr objectAtIndex:0] integerValue];
            m_cObjCombineNamePtr = [m_cObjCombineListPtr objectAtIndex:0];
            
            gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests :[[m_cObjCombineIDsPtr objectAtIndex:0] integerValue] CombineName:[m_cObjCombineListPtr objectAtIndex:0]];
#endif
        }
        
        m_cTestCount = gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count;
    }
    
    
    lRect = CGRectMake(10.0, CGRectGetMaxY(m_cObjUpperEditTablePtr.frame)+SPACING *2, 310.0,720.0);
    m_cObjLowerEditTablePtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];
	m_cObjLowerEditTablePtr.backgroundColor = [UIColor clearColor];
    m_cObjLowerEditTablePtr.backgroundView = nil;
	m_cObjLowerEditTablePtr.delegate = self;
	m_cObjLowerEditTablePtr.dataSource = self;
	m_cObjLowerEditTablePtr.autoresizesSubviews = YES;
	m_cObjLowerEditTablePtr.scrollEnabled = NO;
	m_cObjLowerEditTablePtr.allowsSelectionDuringEditing = YES;
    m_cObjLowerEditTablePtr.alpha = 1.0;
    
    
    //     m_cObjLowerEditTablePtr.tag = ADDATHLETELOWERTABLE_TESTSET2;//ADDATHLETELOWERTABLE;
    m_cObjLowerEditTablePtr.tag = ADDATHLETELOWERTABLE_TESTSET3;
    [m_cObjScrollViewPtr addSubview:m_cObjLowerEditTablePtr];
    
    if(m_cObjLowerEditTablePtr.tag == ADDATHLETELOWERTABLE)
    {
        UIBarButtonItem *lObjSaveBtnPtr = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveButtonPressed:)];
        self.navigationItem.rightBarButtonItem = lObjSaveBtnPtr;
        SAFE_RELEASE(lObjSaveBtnPtr)
    }
}

-(void)createImageControls
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        m_cObjImageBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        m_cObjImageBtnPtr.frame = CGRectMake(10, 10, 80, 80);
        [m_cObjScrollViewPtr addSubview:self.m_cObjImageBtnPtr];
    }
    else
    {
        m_cObjImageBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.m_cObjImageBtnPtr.backgroundColor = [UIColor clearColor];
        m_cObjImageBtnPtr.layer.cornerRadius = 4.0;
        m_cObjImageBtnPtr.layer.borderColor=[[UIColor blackColor]CGColor];
        m_cObjImageBtnPtr.layer.borderWidth=2.0;
        m_cObjImageBtnPtr.frame = CGRectMake(5, 10 ,90, 90);
        [m_cObjImageBtnPtr addTarget:self action:@selector(onPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        m_cObjImageBtnPtr.userInteractionEnabled = NO;
        [m_cObjScrollViewPtr addSubview:self.m_cObjImageBtnPtr];
    }
    

   
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isIDexists = NO;
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
    
    //Srikant july 31 start
    NSLog(@"m_cObjCombineIdPtr = %d\n",m_cObjCombineIdPtr);
    gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr = (NSMutableArray *)nil;
    gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests :m_cObjCombineIdPtr CombineName:nil];
    m_cTestCount = gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count;

    //Srikant july 31 End

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
   // [self createTopToolBar];//Srikant july 31
    
      NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
    
    if (athleteIdsPtr.count > 0) {
        for (int i=0; i<athleteIdsPtr.count; i++) {
            if ([self.m_cObjAthleteDetailStructurePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {

                isIDexists = YES;
                self.m_cObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                break;
            }
        }
    }
     
   
    [self setAthletePhoto];
    
    
    [m_cObjUpperEditTablePtr reloadData];
    [m_cObjLowerEditTablePtr reloadData];
    [self adjustScrollView];
}

-(void)doPhotoAnimation
{
    if (YES == [gObjAppDelegatePtr isNetworkAvailable])
    {
        [self.m_cObjImageBtnPtr setImage:[UIImage imageNamed:@"AthleteImageLogScrn.png"] forState:UIControlStateNormal];
        if (NO == isIDexists)
        {
            self.m_cObjImageBtnPtr.imageView.animationImages = [self getAnimatedPlaceHolderImages];
            self.m_cObjImageBtnPtr.imageView.animationDuration = 1.0;
            [self.m_cObjImageBtnPtr.imageView startAnimating];
        }
    }
}
-(void)photoDownloadSucceed
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [m_cObjOperationQueuePtr cancelAllOperations];
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr = self;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadSucceed];
    
}
-(void)photoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [m_cObjOperationQueuePtr cancelAllOperations];
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr = self;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadFailed];
}

-(void)InformPhotoDownloadSucceed
{
     if ([self.m_cObjImageBtnPtr.imageView isAnimating]) {
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        [self.m_cObjImageBtnPtr.imageView.layer removeAllAnimations];
     }
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      [m_cObjOperationQueuePtr cancelAllOperations];
      gObjAppDelegatePtr.isImageFileDownloading = NO;
      gObjAppDelegatePtr.isForImageDownload = NO;
    
    NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
    
    if (athleteIdsPtr.count > 0) {
        for (int i=0; i<athleteIdsPtr.count; i++) {
            if ([self.m_cObjAthleteDetailStructurePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                isIDexists = YES;
                self.m_cObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                break;
            }
        }
    }
    
    [self setAthletePhoto];
    
}
-(void)InformPhotoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [m_cObjOperationQueuePtr cancelAllOperations];
    [self setAthletePhoto];
    gObjAppDelegatePtr.isForImageDownload = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;

}
- (void)handleAthletDetailDownloadSucceed
{
    self.m_cObjAthleteDetailStructurePtr = gObjAppDelegatePtr.m_cObjAthleteDataStructurePtr;
    if ((NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "] && NO == isIDexists) {
        [self setAthletePhototo];
    }
    //Narasimhaiah downloading Athlete Image And Check For Image change 26-2-13 - start
    if (NO ==gObjAppDelegatePtr.isForImageDownload)
    {
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
        {
            if ((UIImage *)nil == m_cObjImagePtr)
            {
                self.m_cObjImageBtnPtr.imageView.animationImages = [self getAnimatedPlaceHolderImages];
                self.m_cObjImageBtnPtr.imageView.animationDuration = 1.0;
                [self.m_cObjImageBtnPtr.imageView startAnimating];
            }
        }
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
            [self performSelectorInBackground:@selector(doStupidAnimation) withObject:nil];
    }
    //Narasimhaiah downloading Athlete Image And Check For Image change 26-2-13 - end
    
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [m_cObjUpperEditTablePtr reloadData];
    [m_cObjLowerEditTablePtr reloadData];
    [self adjustScrollView];

}
-(void)handleAthletDetailDownloadFailed
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    
//    //Store the AThlete details into server - start
//    if([self.m_cObjAthleteDetailStructurePtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0 && YES ==[gObjAppDelegatePtr isNetworkAvailable])
//    {
//            isOfflineData = YES;
//            gObjAppDelegatePtr.m_cObjTempAthleteIdPtr =self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
//            self.m_cObjAthleteDetailStructurePtr.m_cIsAddedinOfflineMode = YES;
//            gObjAppDelegatePtr.isOfflineData = YES;
//            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest:self.m_cObjAthleteDetailStructurePtr :YES];
//
//    }
//    else{
//        isOfflineData = NO;
//        self.m_cObjAthleteDetailStructurePtr.m_cIsAddedinOfflineMode = NO;
//        gObjAppDelegatePtr.isOfflineData = NO;
//    }
//    //Store the AThlete details into server - end
    
    
    
    [m_cObjUpperEditTablePtr reloadData];
    [m_cObjLowerEditTablePtr reloadData];
    [self adjustScrollView];

}

-(void)getImageDatatoUpload
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *lObjImageNamePathPtr =(NSString *)nil;
    BOOL fileExists =NO;
    
    if (YES == isIDexists) {
        lObjImageNamePathPtr = self.m_cObjImageNamePathPtr;
        fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        
        if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil  AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        }
    }
    else{
        
        if ((NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthleteDetailStructurePtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
            
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            
            if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil  AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
                
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
        }
    }
    
    if (YES == fileExists) {
        
        NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
        self.m_cObjImagePtr = [UIImage imageWithData:lObjImageDataPtr];
        gObjAppDelegatePtr.m_cObjImageDatePtr = lObjImageDataPtr;
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        [self.m_cObjImageBtnPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
    }

}

-(void)setAthletePhototo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *lObjImageNamePathPtr =(NSString *)nil;
    BOOL fileExists =NO;
    
    if (YES == isIDexists) {
        lObjImageNamePathPtr = self.m_cObjImageNamePathPtr;
        fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        
        if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil  AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        }
    }
    else{

        if ((NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthleteDetailStructurePtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
 
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            
            if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
 
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
        }
    }
    
    if (YES == fileExists) {
        NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
        self.m_cObjImagePtr = [UIImage imageWithData:lObjImageDataPtr];
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        [self.m_cObjImageBtnPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
    }
    else
    {
        m_cObjImagePtr = (UIImage *)nil;
        
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
        {

            [self.m_cObjImageBtnPtr setImage:[UIImage imageNamed:@"AthleteImageLogScrn.png"] forState:UIControlStateNormal];
            
            if (NO == isIDexists)
            {
                    gObjAppDelegatePtr.isForImageDownload = YES;
                    self.m_cObjImageBtnPtr.imageView.animationImages = [self getAnimatedPlaceHolderImages];
                    self.m_cObjImageBtnPtr.imageView.animationDuration = 1.0;
                    [self.m_cObjImageBtnPtr.imageView startAnimating];
                    [self performSelectorInBackground:@selector(doStupidAnimation) withObject:nil];
            }
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
        {
            m_cObjImagePtr = (UIImage *)nil;

            [self.m_cObjImageBtnPtr setImage:[UIImage imageNamed:@"AthleteImageLogScrn.png"] forState:UIControlStateNormal];

            if (NO == gObjAppDelegatePtr.isAlertViewShown)
            {
                gObjAppDelegatePtr.isAlertViewShown = YES;
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"No Network Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
                [gObjAppDelegatePtr stopProgressHandler];
                [lObjAlertViewPtr show];
                SAFE_RELEASE(lObjAlertViewPtr)
            }
        }
    }
    IsPhotoDeleted = NO;
}
- (void)doStupidAnimation
{
    gObjAppDelegatePtr.isImageFileDownloading = YES;
    [self callImageDownload];
 
}
 
-(void)callImageDownload
{
   if (YES ==[gObjAppDelegatePtr isNetworkAvailable]) {
       
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
        gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr = self;
        
           gObjAppDelegatePtr.isForImageDownload = YES;
           [gObjAppDelegatePtr downloadAthleteImage:self.m_cObjAthleteDetailStructurePtr];
       
    
    }
    else{
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
 
-(NSArray *)getAnimatedPlaceHolderImages
{
    NSArray *lImages = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"loadingSpinner1.png"],
                        [UIImage imageNamed:@"loadingSpinner2.png"],
                        [UIImage imageNamed:@"loadingSpinner3.png"],
                        [UIImage imageNamed:@"loadingSpinner4.png"],
                        [UIImage imageNamed:@"loadingSpinner5.png"],
                        [UIImage imageNamed:@"loadingSpinner6.png"],
                        [UIImage imageNamed:@"loadingSpinner7.png"],
                        [UIImage imageNamed:@"loadingSpinner8.png"],
                        [UIImage imageNamed:@"loadingSpinner9.png"],
                        [UIImage imageNamed:@"loadingSpinner10.png"],
                        [UIImage imageNamed:@"loadingSpinner11.png"],
                        [UIImage imageNamed:@"loadingSpinner12.png"],
                        nil];
    return lImages;
}
-(void)setAthletePhoto
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *lObjImageNamePathPtr = (NSString *)nil;
    BOOL fileExists = NO;
    
    if (YES == isIDexists) {
        lObjImageNamePathPtr = self.m_cObjImageNamePathPtr;
        
        
        fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
           
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
        }
    }
    else{
      if ((NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthleteDetailStructurePtr.m_cAthleteId AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
        
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
              if (NO == fileExists && (NSString *)nil != self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                  lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:self.m_cObjAthleteDetailStructurePtr.m_cPhotoNamePtr];
                
                  fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
              }
            }
    }
    if (YES == fileExists) {
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
        self.m_cObjImagePtr = [UIImage imageWithData:lObjImageDataPtr];
//        NSLog(@"Image data %@",lObjImageDataPtr);
        [self.m_cObjImageBtnPtr setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
    }
    else
    {
        m_cObjImagePtr = (UIImage *)nil;
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        [self.m_cObjImageBtnPtr.imageView stopAnimating];

        
        [self.m_cObjImageBtnPtr setImage:[UIImage imageNamed:@"AthleteImageLogScrn.png"] forState:UIControlStateNormal];
    }
    IsPhotoDeleted = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    isForLog = NO;
    gObjAppDelegatePtr.isForAthleteDetailDownload = NO;    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
 
    m_cObjNumberKeypadDecimalPointPtr = (NumberKeypadDecimalPoint *)nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}



-(void)onEditButtonPressed: (id)sender
{
    EditAthleteViewController *lObjEditAthleteViewController = (EditAthleteViewController *)nil;
    lObjEditAthleteViewController = [[EditAthleteViewController alloc]init];
    lObjEditAthleteViewController.m_cObjAthleteDetailsDataPtr = self.m_cObjAthleteDetailStructurePtr;
    [self.navigationController pushViewController:lObjEditAthleteViewController animated:YES];
    SAFE_RELEASE(lObjEditAthleteViewController)

}
-(void)onAddOrRemoveFromFacButtonPressed :(id)sender
{
    UIAlertView *lObjAlertView = (UIAlertView *)nil;

    if ([lObjAddFavButton.title isEqualToString:@"Add To Favorite"]) {
        BOOL lRetval = NO;
        self.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete = 1;
        gObjAppDelegatePtr.IsinFavourites = 1;
        lRetval = [gObjAppDelegatePtr.m_cDbHandler insertToFavourites:self.m_cObjAthleteDetailStructurePtr];
        if (lRetval)
        {
            [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr addObject:self.m_cObjAthleteDetailStructurePtr];
            lObjAlertView = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"The Athlete has been added successfully to the Favorite list"
                                delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
                                lObjAlertView.tag = 502;
                                [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
        }
        else
        {
            lObjAlertView = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"The Athlete could not be added to the Favorite list"
                                delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
                            lObjAlertView.tag = 503;
                            [lObjAlertView show];
            SAFE_RELEASE(lObjAlertView)
            
        }
    }
    else if ([lObjAddFavButton.title isEqualToString:@"Remove From Favorite"])
    {
        BOOL lRetval = NO;
        self.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete = 0;
        gObjAppDelegatePtr.IsinFavourites = 0;
        lRetval = [gObjAppDelegatePtr.m_cDbHandler removeFromFavourites:self.m_cObjAthleteDetailStructurePtr];
        if (lRetval) {
            [gObjAppDelegatePtr.m_cObjFavouriteAthleteListPtr removeObject:self.m_cObjAthleteDetailStructurePtr];
            lObjAlertView = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"The Athlete has been removed successfully from the Favorite list"
                                delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
                                lObjAlertView.tag = 504;
                                [lObjAlertView show];
                        SAFE_RELEASE(lObjAlertView)
        }
        else{
            lObjAlertView = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"The Athlete could not be removed from the Favorite list"
                                delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
                                lObjAlertView.tag = 505;
                                [lObjAlertView show];
                        SAFE_RELEASE(lObjAlertView)
        }
    }
}
-(void)serverTransactionFailed
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    if (YES ==gObjAppDelegatePtr.isForAthleteDetailDownload) {
        [gObjAppDelegatePtr stopProgressHandler];
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr handleAthletDetailDownloadFailed];
    }
    
    if(YES == isForLog)
    {
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"The Athlete's Details could not be successfully updated"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        lObjAlertViewPtr.tag = 501;
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
    if (NO == gObjAppDelegatePtr.isImageFileDownloading && NO == isForLog) {

        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Athlete Data is Empty"
                            delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        lObjAlertViewPtr.tag = 501;
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.m_cObjImageBtnPtr.imageView stopAnimating];
        gObjAppDelegatePtr.isAlertViewShown = YES;
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
-(void)serverTransactionSucceeded
{
    

        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.isImageFileDownloading = NO;
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Data stored for sync"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        lObjAlertViewPtr.tag = 500;
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        SAFE_RELEASE(lObjAlertViewPtr)

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 500 || alertView.tag == 501)
        [self onBackButtonPressed:nil];
    if (alertView.tag == 502) {
        lObjAddFavButton.title = @"Remove From Favorite";
    }
    else if (alertView.tag == 504){
        lObjAddFavButton.title = @"Add To Favorite";
    }
}


-(void)onBackButtonPressed : (id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRow = -1;
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        lRow =  3;
        m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        if (section==0)
        {
            lRow = 8;
        }
        else
        {
            lRow = 5;
        }
        m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET2)
    {
        if (section == 0)
        {
            lRow = 6;
        }
        else
        {
            lRow = 5;
        }
        m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;

    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET3)
    {
        if (section == 0) 
        {
            lRow =m_cTestCount;
        }
        else
        {
            lRow = 5;
        }
        m_cTotalNoOfRows  = m_cTotalNoOfRows +lRow;

    }
    return lRow;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger lSection = -1;
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        lSection =  1;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        lSection = 2;
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET2)
    {
        lSection = 2;
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET3)
    {
        lSection = 2;
    }
    return lSection;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==ADDATHLETELOWERTABLE_TESTSET3)
    {
        if (section==0) 
        {
            
            if (m_cTestCount>0) 
            {
                if (gObjAppDelegatePtr.m_cObjCombineTitleStringPtr!=nil) 
                {
                    return [NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cObjCombineTitleStringPtr];
                }
                else
                {
                 return [NSString stringWithFormat:@"%@",@""];
                }
            }
                
            //return [NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cObjCombineTitleStringPtr];
        }
         
    }
    return @"";
  
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //DLog(@"Custom Header Section Title being set");
    if (tableView.tag==ADDATHLETELOWERTABLE_TESTSET3)
    {
      if (section==0) 
      {
#if 0
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];  
    
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
        label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
       [headerView addSubview:label];
       return headerView;
#endif
          
          UILabel *customLabel = [[UILabel alloc] init];
          customLabel.backgroundColor=[UIColor clearColor];
          customLabel.text = [self tableView:tableView titleForHeaderInSection:section];
          customLabel.textColor=[UIColor whiteColor];
          return customLabel;
          
      }
        return  nil;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteUpperDetailCell";
        AddAthleteTableViewCell		*lObjCustomCellPtr = (AddAthleteTableViewCell *)nil;
        
        lObjCustomCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];	
        if((AddAthleteTableViewCell *)nil == lObjCustomCellPtr)
        {
            lObjCustomCellPtr = [[[AddAthleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        switch (indexPath.row)
        {
            case 0:
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"First Name";
                lObjCustomCellPtr.userInteractionEnabled = NO;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjFirstNamePtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETEFIRSTNAMETAG;
                
                break;
            case 1:
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"Last Name";
                lObjCustomCellPtr.userInteractionEnabled = NO;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjLastNamePtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETELASTNAMETAG;
                break;
            case 2:
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"NickName";
                lObjCustomCellPtr.userInteractionEnabled = NO;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjNickNamePtr;
                lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETENICKNAMETAG;
                
                break;
            default:
                break;
        }
        lObjCustomCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return lObjCustomCellPtr;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];	
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        
        lObjCellPtr.m_cObjAthleteTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        switch (indexPath.section)
        {
            case 0:
                switch (indexPath.row)
            {
                case 0:
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Vertical Jump";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALTAG;
                    
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                    
                case 1:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Max Push Ups";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Enter Count";
                    lObjCellPtr.userInteractionEnabled = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPUSHUPTAG;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                    break;
                    
                    
                    
                case 2:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Zig Zag Drill";
                   
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                case 3:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Drill";
                   
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                case 4:
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Setting Accuracy";
                   
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                case 5:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Passing Accuracy";
                                       
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    
                    break;
                    
                case 6:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Serve Accuracy";
                                    
                    
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                    
                case 7:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Court Sprints";
                    
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                    
                default:
                break;
            }

                break;
            case 1:
                switch (indexPath.row)
            {
                    case 0:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Sport";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Sports List";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSportsPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPORTSTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                   
                        break;
                    case 1:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"School";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Name";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESCHOOLTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                    case 2:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Team";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Team Name";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjTeamNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETETEAMTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                    case 3:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Position";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Position";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjPositionPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPOSITIONTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                   
                    break;
                    case 4:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Year";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Year";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolYearPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEYEARTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                    default:
                        break;
                }
        }
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE_TESTSET2)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        
        lObjCellPtr.m_cObjAthleteTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        switch (indexPath.section)
        {
            case 0:
                switch (indexPath.row)
            {
                case 0:
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Standing Vertical";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALTAG;
                 
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                    
                case 1:

                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Approach Jump";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALTAG;
                 
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;

                case 2:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Broad Jump";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALTAG;
                    
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
              
                case 3:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Serve Speed";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                    
                case 4:
                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
//                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Passing Accuracy";
                                       lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    
                    break;
                case 5:
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
//                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:12];
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Setting Accuracy";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    break;
                default:
                    break;
            }
                
                break;
            case 1:
                switch (indexPath.row)
            {
                case 0:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Sport";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Sports List";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSportsPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPORTSTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 1:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"School";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Name";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESCHOOLTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 2:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Team";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Team Name";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjTeamNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETETEAMTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 3:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Position";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Position";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjPositionPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPOSITIONTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 4:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Year";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Year";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolYearPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEYEARTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                default:
                    break;
            }
        }
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE_TESTSET3)
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        Tests               *lObjTestDataPtr        =   (Tests *)nil;
        AthleteLog          *lObJAthleteLogPtr      =   (AthleteLog *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        
        lObjCellPtr.m_cObjAthleteTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        switch (indexPath.section)
        {

            case 0:
            {
                NSLog(@"%d",gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count);
                
   
                m_cObjAthleteLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogs :self.m_cObjAthleteDetailStructurePtr.m_cAthleteId CombineId :m_cObjCombineIdPtr]retain];//Srikant

                
                NSLog(@"%d",m_cObjCombineIdPtr);

                 NSLog(@"%d",m_cObjAthleteLogArrayPtr.count);

                
                    lObjTestDataPtr     =  [[gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr objectAtIndex:indexPath.row] retain];
                    for (AthleteLog *tempAthlete in m_cObjAthleteLogArrayPtr)
                    {
                        if(tempAthlete.m_cObjTestId == lObjTestDataPtr.m_cObjTestId && tempAthlete.m_cObjCombineId == lObjTestDataPtr.m_cObjCombineId)
                        {
                            lObJAthleteLogPtr   =  tempAthlete;
                            break;
                        }
                    }
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = [lObjTestDataPtr.m_cObjTestNamePtr lowercaseString];
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALTAG;
                    
                    if ((NSString *)nil != lObjTestDataPtr.m_cObjTestResultsPtr)
                        lObjCellPtr.m_cObjAthleteTextFieldPtr.text = lObJAthleteLogPtr.m_cObjTestResultPtr;
                    else if(lObJAthleteLogPtr.m_cObjTestId == lObjTestDataPtr.m_cObjTestId && (NSString *)nil != lObJAthleteLogPtr.m_cObjTestResultPtr && (NSString *)nil == lObjTestDataPtr.m_cObjTestResultsPtr)
                         lObjCellPtr.m_cObjAthleteTextFieldPtr.text = lObJAthleteLogPtr.m_cObjTestResultPtr;
                    else
                        lObjCellPtr.m_cObjAthleteTextFieldPtr.text = @"";
                        
                    lObjCellPtr.userInteractionEnabled = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"";
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.textAlignment = UITextAlignmentCenter;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.userInteractionEnabled = NO;
                    SAFE_RELEASE(lObjTestDataPtr)
            }
                break;
            case 1:
                switch (indexPath.row)
            {
                case 0:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Sport";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Sports List";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = NO;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryNone;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSportsPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPORTSTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 1:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"School";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Name";
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = NO;
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryNone;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESCHOOLTAG;
                 lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 2:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Team";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Team Name";
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryNone;
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = NO;                    
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjTeamNamePtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETETEAMTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 3:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Position";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Position";
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryNone;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = NO;                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjPositionPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEPOSITIONTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                case 4:
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Year";
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"School Year";
                    lObjCellPtr.accessoryType = UITableViewCellAccessoryNone;
                    lObjCellPtr.m_cObjLineViewPtr.hidden = NO;                    
                    lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.text = self.m_cObjAthleteDetailStructurePtr.m_cObjSchoolYearPtr;
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEYEARTAG;
                    lObjCellPtr.userInteractionEnabled = NO;
                    
                    break;
                default:
                    break;
            }
        }
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ADDATHLETELOWERTABLE && indexPath.section == 0)
    {
        LogViewController *lObjLogAddViewControllerPtr = (LogViewController *)nil;
        
        lObjLogAddViewControllerPtr = [[LogViewController alloc]init];
        
        lObjLogAddViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogAddViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
        
        lObjLogAddViewControllerPtr.m_cObjTestDataPtr = [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr objectAtIndex:indexPath.row];
        
        [self.view endEditing:YES];
        [self.navigationController pushViewController:lObjLogAddViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjLogAddViewControllerPtr)
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET2 && indexPath.section == 0)
    {
        LogViewController *lObjLogAddViewControllerPtr = (LogViewController *)nil;
        lObjLogAddViewControllerPtr = [[LogViewController alloc]init];
        
        lObjLogAddViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogAddViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
        
        [self.view endEditing:YES];
        [self.navigationController pushViewController:lObjLogAddViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjLogAddViewControllerPtr)
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET3 && indexPath.section == 0)
    {
        LogViewController   *lObjLogViewControllerPtr = (LogViewController *)nil;
        lObjLogViewControllerPtr = [[LogViewController alloc] init];
        lObjLogViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
        lObjLogViewControllerPtr.m_cObjAthleteDetailsDataPtr = self.m_cObjAthleteDetailStructurePtr;
        lObjLogViewControllerPtr.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        
        if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count > 0)
        {
            lObjLogViewControllerPtr.m_cObjTestDataPtr = [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr objectAtIndex:indexPath.row];
            lObjLogViewControllerPtr.m_cObjAthletelogPtr.m_cObjCombineId = lObjLogViewControllerPtr.m_cObjTestDataPtr.m_cObjCombineId;
            
            NSInteger testattempts = -1;
            testattempts = [lObjLogViewControllerPtr.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
            if (testattempts > 0) {
                [self.view endEditing:YES];
                [self.navigationController pushViewController:lObjLogViewControllerPtr animated:YES];
                SAFE_RELEASE(lObjLogViewControllerPtr)
            }
            else
            {
                UIAlertView *lObJAlertViewPtr = (UIAlertView *)nil;
                lObJAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Test Attempts is zero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [lObJAlertViewPtr show];
                SAFE_RELEASE(lObJAlertViewPtr)
            }
        }
        SAFE_RELEASE(lObjLogViewControllerPtr)
        
        
    }

    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ADDATHLETELOWERTABLE && indexPath.section == 0)
    {
        LogViewController *lObjLogAddViewControllerPtr = (LogViewController *)nil;
         
        lObjLogAddViewControllerPtr = [[LogViewController alloc]init];
 
        lObjLogAddViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogAddViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
       
        lObjLogAddViewControllerPtr.m_cObjTestDataPtr = [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr objectAtIndex:indexPath.row];
        
        [self.view endEditing:YES];
        [self.navigationController pushViewController:lObjLogAddViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjLogAddViewControllerPtr)
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET2 && indexPath.section == 0)
    {
        LogViewController *lObjLogAddViewControllerPtr = (LogViewController *)nil;
        lObjLogAddViewControllerPtr = [[LogViewController alloc]init];
        
        lObjLogAddViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogAddViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
        
        [self.view endEditing:YES];
        [self.navigationController pushViewController:lObjLogAddViewControllerPtr animated:YES];
        SAFE_RELEASE(lObjLogAddViewControllerPtr)
    }
    else if (tableView.tag == ADDATHLETELOWERTABLE_TESTSET3 && indexPath.section == 0)
    {
        LogViewController   *lObjLogViewControllerPtr = (LogViewController *)nil;
        lObjLogViewControllerPtr = [[LogViewController alloc] init];
        lObjLogViewControllerPtr.m_cAthleteId = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        lObjLogViewControllerPtr.m_cObjAthletelogPtr = self.m_cObjAthleteLogPtr;
        lObjLogViewControllerPtr.m_cObjAthleteDetailsDataPtr = self.m_cObjAthleteDetailStructurePtr;
        lObjLogViewControllerPtr.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cObjAthleteDetailStructurePtr.m_cAthleteId;
        
        if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count > 0)
        {
            lObjLogViewControllerPtr.m_cObjTestDataPtr = [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr objectAtIndex:indexPath.row];
            lObjLogViewControllerPtr.m_cObjAthletelogPtr.m_cObjCombineId = lObjLogViewControllerPtr.m_cObjTestDataPtr.m_cObjCombineId;
            
            NSInteger testattempts = -1;
            testattempts = [lObjLogViewControllerPtr.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
            if (testattempts > 0) {
                [self.view endEditing:YES];
                [self.navigationController pushViewController:lObjLogViewControllerPtr animated:YES];
                SAFE_RELEASE(lObjLogViewControllerPtr)
            }
            else
            {
                UIAlertView *lObJAlertViewPtr = (UIAlertView *)nil;
                lObJAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Test Attempts is zero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [lObJAlertViewPtr show];
                SAFE_RELEASE(lObJAlertViewPtr)
            }
        }
        SAFE_RELEASE(lObjLogViewControllerPtr)
       
       
    }
   
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_cObjActiveTextFieldPtr = textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == ATHLETEPUSHUPTAG || textField.tag == ATHLETEPASSINGACCURACYTAG || textField.tag == ATHLETESERVEACCURACYTAG)
   {
        [m_cObjNumberKeypadDecimalPointPtr removeButtonFromKeyboard];
        [textField resignFirstResponder];
   }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == ATHLETEPUSHUPTAG || textField.tag == ATHLETEPASSINGACCURACYTAG || textField.tag == ATHLETESERVEACCURACYTAG)
    {
        [self performSelector:@selector(showCustomDoneButton:) withObject:textField afterDelay:0.2f];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


-(void)showCustomDoneButton:(UITextField *)textField
{
    gObjAppDelegatePtr.m_cObjNumkeyPadString= @"DONE";

    if (textField.tag == ATHLETEPUSHUPTAG || textField.tag == ATHLETEPASSINGACCURACYTAG || textField.tag == ATHLETESERVEACCURACYTAG)

    { 
        if ((NumberKeypadDecimalPoint *)nil == m_cObjNumberKeypadDecimalPointPtr) 
        { 
            m_cObjNumberKeypadDecimalPointPtr = [NumberKeypadDecimalPoint keypadForTextField:textField];
        }
        else 
        {
            m_cObjNumberKeypadDecimalPointPtr.currentTextField = textField;
            [m_cObjNumberKeypadDecimalPointPtr addButtonToKeyboard:m_cObjNumberKeypadDecimalPointPtr.decimalPointButton];
        }
        m_cObjNumberKeypadDecimalPointPtr.delegate = self;
        
	}
}

-(void)keyBoardCustomDoneButtonClicked:(UITextField *)textField
{
  
 if(textField.tag == ATHLETEPUSHUPTAG || textField.tag == ATHLETEPASSINGACCURACYTAG || textField.tag == ATHLETESERVEACCURACYTAG)
    {
        [textField resignFirstResponder];
    }
}


- (void)keyBoardWillShow:(NSNotification *)pObjNotificationPtr
{
    if(m_cObjActiveTextFieldPtr.tag == COMBINETEXTFIELDTAG)
    {
        CGFloat lOffset = 100.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerEditTablePtr.contentInset = contentInsets;
        m_cObjLowerEditTablePtr.scrollIndicatorInsets = contentInsets;
        
        
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];

    }
    if(m_cObjActiveTextFieldPtr.tag == ATHLETEPUSHUPTAG)
    {
        CGFloat lOffset = 150.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerEditTablePtr.contentInset = contentInsets;
        m_cObjLowerEditTablePtr.scrollIndicatorInsets = contentInsets;
        
        
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
    }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETEPASSINGACCURACYTAG)
    {
        CGFloat lOffset = 300.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerEditTablePtr.contentInset = contentInsets;
        m_cObjLowerEditTablePtr.scrollIndicatorInsets = contentInsets;
        
        
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
    }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETESERVEACCURACYTAG)
    {
        CGFloat lOffset = 350.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerEditTablePtr.contentInset = contentInsets;
        m_cObjLowerEditTablePtr.scrollIndicatorInsets = contentInsets;
        
        
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
    }
}
- (void)keyBoardWillHide : (NSNotification *)pObjNotificationPtr
{
    if (m_cObjActiveTextFieldPtr.tag == ATHLETEPUSHUPTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEPASSINGACCURACYTAG || m_cObjActiveTextFieldPtr.tag == ATHLETESERVEACCURACYTAG || m_cObjActiveTextFieldPtr.tag == COMBINETEXTFIELDTAG)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        m_cObjLowerEditTablePtr.contentInset = UIEdgeInsetsZero;
        m_cObjLowerEditTablePtr.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
}
-(void)adjustScrollView
{
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0,((m_cTotalNoOfRows+4) * 40)+35);
    m_cTotalNoOfRows = 0;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjPickerViewPtr)
    SAFE_RELEASE(m_cObjCombineIDsPtr)
    SAFE_RELEASE(lObjAddFavButton)
    SAFE_RELEASE(keyboardDoneButtonView)
    SAFE_RELEASE(m_cObjCombineListPtr)
    SAFE_RELEASE(m_cObjOperationQueuePtr)
    SAFE_RELEASE(m_cObjAthleteLogPtr)
    SAFE_RELEASE(m_cObjToolBarPtr)
    SAFE_RELEASE(m_cObjScrollViewPtr)
    SAFE_RELEASE(m_cObjLowerEditTablePtr)
    SAFE_RELEASE(m_cObjUpperEditTablePtr)
    SAFE_RELEASE(m_cObjAthleteDetailStructurePtr)
    SAFE_RELEASE(m_cObjAthleteLogArrayPtr)
    SAFE_RELEASE(m_cObjImagePtr)
    
    [super dealloc];
}

@end
