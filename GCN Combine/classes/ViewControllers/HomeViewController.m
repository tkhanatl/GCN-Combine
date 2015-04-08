//
//  HomeViewController.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "HomeViewController.h"
#import "Macros.h"
#import "AthleteDetailTableViewCell.h"
#import "AddAthleteViewController.h"
#import "AppDelegate.h"
#import "AthleteLoggerViewController.h"
#import "HttpHandler.h"
#import "LoginViewController.h"
#import "AboutViewController.h"


@implementation HomeViewController

@synthesize savedSearchTerm,savedScopeButtonIndex,searchWasActive,m_cObjfilteredListContent;
@synthesize m_cObjTablePtr;
@synthesize m_cObjToolBarPtr;
@synthesize m_cDownloadisForCombineIds,m_cDownloadisForCombineTests;
@synthesize m_cObjHomeCombineIdArrayPtr,m_cObjAthleteDetailStructurePtr,keyboardDoneButtonView,m_cObjHomeCombineIdPtr,m_cObjCombineIDsPtr,m_cObjCombineNamePtr,m_cObjPickerViewPtr,m_cObjCombineListPtr,m_cObjPickerToolBarPtr,/*m_cTestCount,*/m_cObjAtheleteCountLabelPtr,m_cObjHomeCombineListPtr,m_CobjCombineTitleLabelptr;



-(id)initWithTabBar
{
    if (self = [super init]) 
    {
        //self.tanavigationController.navigationBar.hidden=NO;
        self.m_cObjHomeCombineIdPtr = -1;
        UITabBarItem *lObjTabbarItem = (UITabBarItem *)nil;
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
       // self.tabBarController.navigationController.navigationBar.hidden = YES;
        lObjTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", @"") image:[UIImage imageNamed:NSLocalizedString(@"HomeLogo", @"")] tag:0];
        self.tabBarItem = lObjTabbarItem;
        //self.title = NSLocalizedString(@"Home", @"");
        SAFE_RELEASE(lObjTabbarItem)
        
       /// m_cObjSearchDisplayControllerPtr = (UISearchDisplayController *)nil;
        m_cObjSearchBarPtr = (UISearchBar *)nil;
        
        m_cObjToolBarPtr = (UIToolbar *)nil;
         m_cObjAtheleteCountLabelPtr=(UILabel *)nil;
        m_CobjCombineTitleLabelptr=(UILabel *)nil;
    
        self.hidesBottomBarWhenPushed = NO;
        
        
        m_cDownloadisForCombineIds = NO;
        m_cDownloadisForCombineTests = NO;
        
        m_cObjHomeCombineIdArrayPtr = (NSMutableArray *)nil;
    }
    return self;
}

-(void)serverTransactionSucceeded
{
    [self homeServerTransactionSucceeded];
  //gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
   }
-(void)homeServerTransactionSucceeded
{
    [gObjAppDelegatePtr stopProgressHandler];

    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata unblock this on 8/8/13
    
    NSMutableArray *lObjArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllAthletes]retain];
    gObjAppDelegatePtr.m_cObjAthleteListPtr = lObjArrayPtr;
    
    //Narasimhaiah sorting the athlete array 12-3-13 - start
    NSString * FIRSTNAME = @"m_cObjFirstNamePtr";
    
    NSSortDescriptor *firstDescriptor =
    [[[NSSortDescriptor alloc]
      initWithKey:FIRSTNAME
      ascending:YES
      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    
    NSArray * descriptors =
    [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray * sortedArray =
    [gObjAppDelegatePtr.m_cObjAthleteListPtr sortedArrayUsingDescriptors:descriptors];
    [gObjAppDelegatePtr.m_cObjAthleteListPtr removeAllObjects];
    gObjAppDelegatePtr.m_cObjAthleteListPtr = [NSMutableArray arrayWithArray:sortedArray];
    //Narasimhaiah sorting the athlete array 12-3-13 - end
    
    
    SAFE_RELEASE(lObjArrayPtr)
    [m_cObjTablePtr reloadData];
  }
-(void)handleCombineListDownloadFailed
{
    UIAlertView *lObjAlertViewPtr;
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"GCN Combine"
                        message:@"Connection Failed."
                        delegate:nil
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil,
                        nil];
    [lObjAlertViewPtr show];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    SAFE_RELEASE(lObjAlertViewPtr)
}
-(void)handleCombineListDownloadSucceed
{
    NSMutableDictionary     *lObjDictionaryPtr = (NSMutableDictionary *)nil;
    lObjDictionaryPtr = [[NSMutableDictionary alloc]init];
    
    lObjDictionaryPtr = [gObjAppDelegatePtr.m_cDbHandler getCombineIdAndNames];
    gObjAppDelegatePtr.m_cObjCombineIDArrayPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allKeys]] retain];
    self.m_cObjHomeCombineListPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allValues]] retain];
    if (self.m_cObjHomeCombineListPtr.count>0) 
    {
        m_CobjCombineTitleLabelptr.text = [NSString stringWithFormat:@"%@", [self.m_cObjHomeCombineListPtr objectAtIndex:0]];
        gObjAppDelegatePtr.m_cObjCombineTitleStringPtr=[self.m_cObjHomeCombineListPtr objectAtIndex:0];
    }
    
    
 if (gObjAppDelegatePtr.m_cObjCombineIDArrayPtr.count > 0)
    {
        NSString *lObjCmbnId =(NSString *)nil;
        lObjCmbnId = [gObjAppDelegatePtr.m_cObjCombineIDArrayPtr objectAtIndex:0];
        self.m_cObjHomeCombineIdPtr = [lObjCmbnId integerValue];
        NSLog(@"%@",lObjCmbnId);
        m_cObjHomeCombineIdArrayPtr = gObjAppDelegatePtr.m_cObjCombineIDArrayPtr;
        gObjAppDelegatePtr.m_cCMBNIDPtr = [NSString stringWithFormat:@"%d",self.m_cObjHomeCombineIdPtr];
       // gObjAppDelegatePtr.m_cCMBNIDPtr=[self.m_cObjHomeCombineIdArrayPtr ];
    }
    [self downloadCombineTests];
}
-(void)downloadCombineTests
{
  
    if (m_cObjHomeCombineIdArrayPtr.count > 0)
    {
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Combine Tests"];
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
        {
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadCombineTests :[[m_cObjHomeCombineIdArrayPtr objectAtIndex:0] integerValue]];
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
        {
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;        }
    }
    else
    {
        
    }
}
-(void)handleCombineTestDownloadSucceed
{
    [m_cObjHomeCombineIdArrayPtr removeObjectAtIndex:0];
    if (gObjAppDelegatePtr.m_cObjCombineIDArrayPtr.count > 0) {
        //gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;//sougata unblock this on 8/8/13
        [self downloadCombineTests];
    }
    else
    {
        [gObjAppDelegatePtr stopProgressHandler];
        //gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;//sougata unblock this this on 8/8/13
        
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading List of Athletes"];
        
        
        if (YES == [gObjAppDelegatePtr isNetworkAvailable]) 
        {
            //[gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadCombineIds];
            gObjAppDelegatePtr.isDownloadForAllAthletes = YES;
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr];
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable]){
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        }

        
        
        
        
    }
}
-(void)handleCombineTestDownloadFailed
{
    [m_cObjHomeCombineIdArrayPtr removeObjectAtIndex:0];
    if (m_cObjHomeCombineIdArrayPtr.count > 0) {
       // gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        [self downloadCombineTests];
    }
    else{
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Combine Tests Download Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}

-(void)serverTransactionFailed
{
    UIAlertView *lObjAlertViewPtr;
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"GCN Combine"
                        message:@"Connection Failed."
                        delegate:nil
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil,
                        nil];
    [lObjAlertViewPtr show];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    SAFE_RELEASE(lObjAlertViewPtr)
}
#if 0
-(void)photoDownloadSucceed
{
    
}
-(void)photoDownloadFailed
{
    
}
#else
-(void)photoDownloadSucceed
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr = self;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadSucceed];
    
}
-(void)photoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr = self;
    [gObjAppDelegatePtr.m_cObjImageHandlerDelegatePtr InformPhotoDownloadFailed];
}
#endif
-(void)InformPhotoDownloadSucceed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
    gObjAppDelegatePtr.isForImageDownload = NO;
    
}
-(void)InformPhotoDownloadFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isForImageDownload = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
}
-(void)createlablesForCount
{
    UIView *lobjCustomTitleViewPtr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    lobjCustomTitleViewPtr.backgroundColor=[UIColor clearColor];
    UILabel *lobjTitlelabelptr = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, 230, 40)];
    lobjTitlelabelptr.backgroundColor = [UIColor clearColor];
    lobjTitlelabelptr.text = @"Home";
    lobjTitlelabelptr.textAlignment=UITextAlignmentCenter;
    lobjTitlelabelptr.textColor = [UIColor whiteColor];
    lobjTitlelabelptr.font = [UIFont boldSystemFontOfSize: 20.0f];
    [lobjCustomTitleViewPtr addSubview:lobjTitlelabelptr];
    m_cObjAtheleteCountLabelPtr = [[UILabel alloc] initWithFrame:CGRectMake(0,15, 230,20)];
//    m_cObjAtheleteCountLabelPtr = [[UILabel alloc] initWithFrame:CGRectMake(45,28, 200,20)];
    m_cObjAtheleteCountLabelPtr.text = nil;
    m_cObjAtheleteCountLabelPtr.textAlignment=UITextAlignmentCenter;
    m_cObjAtheleteCountLabelPtr.textColor = [UIColor whiteColor];
    m_cObjAtheleteCountLabelPtr.backgroundColor =[UIColor clearColor];
    m_cObjAtheleteCountLabelPtr.font =[UIFont boldSystemFontOfSize:10];
    [lobjCustomTitleViewPtr addSubview:m_cObjAtheleteCountLabelPtr];
    //sougata added on 8/8/13
    m_CobjCombineTitleLabelptr = [[UILabel alloc] initWithFrame:CGRectMake(0,25, 230,20)];
    m_CobjCombineTitleLabelptr.backgroundColor = [UIColor clearColor];
    m_CobjCombineTitleLabelptr.text = nil;
    m_CobjCombineTitleLabelptr.textAlignment=UITextAlignmentCenter;
    m_CobjCombineTitleLabelptr.textColor = [UIColor whiteColor];
    m_CobjCombineTitleLabelptr.font = [UIFont boldSystemFontOfSize: 13.0f];
    [lobjCustomTitleViewPtr addSubview:m_CobjCombineTitleLabelptr];
    //endßß
    self.navigationItem.titleView = lobjCustomTitleViewPtr;
    SAFE_RELEASE(lobjTitlelabelptr)
    [lobjCustomTitleViewPtr release];
}
//-(void)inform
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createlablesForCount];
           
    
    m_cObjfilteredListContent = [[NSMutableArray alloc] init];
    UIBarButtonItem *lObjLogoutButtonPtr = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(onLogOutButtonPressed:)];
    //self.navigationItem.leftBarButtonItem=lObjLogoutButtonPtr;
    SAFE_RELEASE(lObjLogoutButtonPtr)
    

    
//    [self createRefreshButton];
    [self createSearchDisplayController];
    [self createElements];
    if (self.savedSearchTerm)
        {
            [self.searchDisplayController setActive:self.searchWasActive];
            [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
            [self.searchDisplayController.searchBar setText:savedSearchTerm];
            
            self.savedSearchTerm = nil;
            
            
            [m_cObjTablePtr reloadData];
            m_cObjTablePtr.scrollEnabled = YES;
        }
	// Do any additional setup after loading the view.
    [m_cObjTablePtr reloadData];
}
-(void)loadView
{
    [super loadView];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self createlablesForCount];
    
    gObjAppDelegatePtr.IsinFavourites = NO;
    gObjAppDelegatePtr.isAlertViewShown = NO;
    NSMutableArray *lObjArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllAthletes]retain];
    gObjAppDelegatePtr.m_cObjAthleteListPtr = lObjArrayPtr;//Mark
    

    NSString * FIRSTNAME = @"m_cObjFirstNamePtr";
    NSSortDescriptor *firstDescriptor =
    [[[NSSortDescriptor alloc]
      initWithKey:FIRSTNAME
      ascending:YES
      selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];

    NSArray * descriptors =
    [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray * sortedArray =
    [gObjAppDelegatePtr.m_cObjAthleteListPtr sortedArrayUsingDescriptors:descriptors];
    [gObjAppDelegatePtr.m_cObjAthleteListPtr removeAllObjects];
    gObjAppDelegatePtr.m_cObjAthleteListPtr = [NSMutableArray arrayWithArray:sortedArray];
    //Narasimhaiah sorting the athlete array 12-3-13 - end

    //Narasimhaiah adding to get the Combine Ids 18-6-2013 start    
    //Fetching Combine Id for the Athlete to Userdefaults 11-3-13 - start
    NSMutableDictionary *savedEventDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *fluentDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSelCombine"];
    
    [savedEventDictionary addEntriesFromDictionary:fluentDictionary];
    gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr = savedEventDictionary;
    SAFE_RELEASE(savedEventDictionary)
    //Fetching Combine Id for the Athlete to Userdefaults 11-3-13 - end
    
    
    NSMutableDictionary *lObjTempDictPtr = (NSMutableDictionary *)nil;
    lObjTempDictPtr = [[gObjAppDelegatePtr.m_cDbHandler getCombineIdAndNames] retain];
    gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr = lObjTempDictPtr;
    //    NSLog(@"Retain count %d",[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr retainCount]);
    SAFE_RELEASE(lObjTempDictPtr)
    m_cObjCombineListPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allValues]] retain];
    m_cObjCombineIDsPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allKeys]] retain];
    
    
    if (gObjAppDelegatePtr.m_cObjCombineTitleStringPtr!=nil) 
    {
        m_CobjCombineTitleLabelptr.text = [NSString stringWithFormat:@"%@", gObjAppDelegatePtr.m_cObjCombineTitleStringPtr];
    }
    else if(self.m_cObjCombineListPtr.count>0)
    {
    m_CobjCombineTitleLabelptr.text = [NSString stringWithFormat:@"%@", [self.m_cObjCombineListPtr objectAtIndex:0]];
    }
    
  if (gObjAppDelegatePtr.m_cCMBNIDPtr != nil)
    {
        self.m_cObjHomeCombineIdPtr= [gObjAppDelegatePtr.m_cCMBNIDPtr integerValue];
        
        
    }
    else
    {
//Srikant Agust 2 start
        NSMutableDictionary     *lObjDictionaryPtr = (NSMutableDictionary *)nil;
        lObjDictionaryPtr = [[NSMutableDictionary alloc]init];
        
        lObjDictionaryPtr = [gObjAppDelegatePtr.m_cDbHandler getCombineIdAndNames];
        gObjAppDelegatePtr.m_cObjCombineIDArrayPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allKeys]] retain];
        
        if (gObjAppDelegatePtr.m_cObjCombineIDArrayPtr.count > 0)
        {
            NSString *lObjCmbnId =(NSString *)nil;
            lObjCmbnId = [gObjAppDelegatePtr.m_cObjCombineIDArrayPtr objectAtIndex:0];
            self.m_cObjHomeCombineIdPtr = [lObjCmbnId integerValue];
            NSLog(@"%@",lObjCmbnId);
            m_cObjHomeCombineIdArrayPtr = gObjAppDelegatePtr.m_cObjCombineIDArrayPtr;
            gObjAppDelegatePtr.m_cCMBNIDPtr = lObjCmbnId;
        }
//Srikant Agust 2 End
    }
    
    if (gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr.count > 0)
    {
        m_cObjAthleteLogArrayPtr = (NSMutableArray *)nil;
        
        if(gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.count > 0)
        {
            NSArray *lObjKeysPtr = gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.allKeys;
            
            for (int i=0; i<lObjKeysPtr.count; i++)
            {
                
                self.m_cObjHomeCombineIdPtr = [[gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr objectForKey:[lObjKeysPtr objectAtIndex:i]] integerValue];
                
                NSString *lObjcombineIdPtr = [NSString stringWithFormat:@"%d",self.m_cObjHomeCombineIdPtr];
                
                m_cObjCombineNamePtr = [gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr objectForKey:lObjcombineIdPtr];
                
                if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count <= 0)
                {
                gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests :self.m_cObjHomeCombineIdPtr CombineName:m_cObjCombineNamePtr];
                //m_cTestCount = gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count;//Srikant July 31
                }
                //[m_cObjLowerEditTablePtr reloadData];
                break;
            }
        }
        else if (-1 == self.m_cObjHomeCombineIdPtr &&
                 (NSString *)nil == m_cObjCombineNamePtr &&
                 0 < m_cObjCombineListPtr.count)
        {
            self.m_cObjHomeCombineIdPtr = [[m_cObjCombineIDsPtr objectAtIndex:0] integerValue];
            m_cObjCombineNamePtr =[m_cObjCombineListPtr objectAtIndex:0];
            //[gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr setObject:[NSString stringWithFormat:@"%d",m_cObjCombineIdPtr] forKey:self.m_cObjAthleteDetailStructurePtr.m_cAthleteId];
            
            //To save the Last Sel Combine  into UserDefaults 11-3-13 - start
            NSUserDefaults *languagePrefs = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            [languagePrefs setObject:gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr forKey:@"LastSelCombine"];
            [languagePrefs synchronize];
            //To save the Last Sel Combine  into UserDefaults 11-3-13 - end
        }
        
//        m_cObjAthleteLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogs :self.m_cObjAthleteDetailStructurePtr.m_cAthleteId CombineId :m_cObjCombineIdPtr]retain];
        
//        [self showElemTypePicker];
        
        
        for (int i=0; i<m_cObjCombineListPtr.count; i++) {
            if ([m_cObjCombineNamePtr isEqualToString:[m_cObjCombineListPtr objectAtIndex:i]]) {
                [m_cObjPickerViewPtr selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
    else
    {
        
    }
    //Narasimhaiah adding to get the Combine Ids 18-6-2013 end
    
    
    SAFE_RELEASE(lObjArrayPtr)
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr= self;
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    [m_cObjTablePtr reloadData];
}

//Narasimhaiah adding the textfield to add the combine id selector 1-3-13 - start
#if 0
- (void)showElemTypePicker
{
    // create a UIPicker view as a custom keyboard view
    m_cObjPickerViewPtr = [[UIPickerView alloc] init];
    m_cObjPickerViewPtr.frame = CGRectMake(0.0, 205.0, 320.0, 70.0);

    m_cObjPickerViewPtr.delegate = self;
    m_cObjPickerViewPtr.dataSource = self;
    m_cObjPickerViewPtr.showsSelectionIndicator = YES;
    m_cObjPickerViewPtr.hidden = YES;
    //m_cObjCombineIdTextFieldPtr.inputView = m_cObjPickerViewPtr;
    //By Default 0th Row Will Be Selected
    [m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:m_cObjPickerViewPtr];
    
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.frame = CGRectMake(0.0, 165.0, 320.0, 40.0);
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    keyboardDoneButtonView.hidden = YES;
    

//    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    [self.view addSubview:keyboardDoneButtonView];
    
    // Plug the keyboardDoneButtonView into the text field...
    //    m_cObjCombineIdTextFieldPtr.inputAccessoryView = keyboardDoneButtonView;   
    
}
#endif
-(void)onLogOutButtonPressed:(id)sender
{
    //[self.view endEditing:YES];
   // BOOL  lloginSure=NO;
    
    UIAlertView *lObjAlertViewPtr;
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"GCN LOG OUT"
                        message:@"Are you sure you want to log out."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:@"Cancel",
                        nil];
    [lObjAlertViewPtr show];

   }
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       if (buttonIndex == 0)
       {
//       LoginViewController *lObjLoginViewControllerPtr=[[LoginViewController alloc]init];
//           [self.navigationController pushViewController:lObjLoginViewControllerPtr animated:NO];
//           SAFE_RELEASE(lObjLoginViewControllerPtr)
           [gObjAppDelegatePtr displayLoginPage];
       }
        
     if(buttonIndex==1)
     {
         [alertView dismissWithClickedButtonIndex:1 animated:YES]; 
     }

}
#if 0
-(void)pickerDoneClicked:(id)sender
{
    keyboardDoneButtonView.hidden = YES;
    m_cObjPickerViewPtr.hidden = YES;
}
#pragma mark -
#pragma mark Picker view data source

- (NSInteger)pickerView:(UIPickerView *)pickerview numberOfRowsInComponent:(NSInteger)component
{
	NSInteger	lNumRows = 0;
    
	if((NSMutableArray *)nil != m_cObjCombineListPtr)
		lNumRows = m_cObjCombineListPtr.count;
	return lNumRows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerview
{
	return 1;
}

#pragma mark -
#pragma mark Picker view delegate


- (NSString *)pickerView:(UIPickerView *)pickerview titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString	*lObjTitlePtr = (NSString *)nil;
    
	if((NSMutableArray *)nil != m_cObjCombineListPtr)
		lObjTitlePtr = [m_cObjCombineListPtr objectAtIndex:row];
	return lObjTitlePtr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerview widthForComponent:(NSInteger)component
{
	CGFloat	lComponentWidth = 0.0;
    
	if(0 == component)
		lComponentWidth = 280.0;
	return lComponentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerview rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}
#endif
//Narasimhaiah adding the textfield to add the combine id selector 1-3-13 - end
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.searchDisplayController setActive:NO animated:NO];
    // save the state of the search UI so that it can be restored if the view is re-created
   self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
#if 0
-(void)createRefreshButton
{
    m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, 44)];
    m_cObjToolBarPtr.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem * refreshButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshHomeScreen)];
	refreshButton.style=UIBarButtonItemStylePlain;
    
    NSArray *lObjToolBarItemsptr = [[NSArray alloc] initWithObjects:refreshButton, nil];
    [self.m_cObjToolBarPtr setItems:lObjToolBarItemsptr];
   
    
    [self.view addSubview:self.m_cObjToolBarPtr];
    SAFE_RELEASE(refreshButton)
    SAFE_RELEASE(lObjToolBarItemsptr)
    
    
}
#endif
-(void)choosecombine
{
    m_cObjPickerViewPtr.hidden = NO;
    keyboardDoneButtonView.hidden = NO;
}
+(void)refreshHomeScreen
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
//    [gObjAppDelegatePtr displayProgressHandler:@"Downloading List of Athletes"];
//    gObjAppDelegatePtr.isDownloadForAllAthletes = YES;
//    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr];
    
    [gObjAppDelegatePtr displayProgressHandler:@"Downloading Combine List"];
    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadCombineIds];
    
}
-(void)createSearchDisplayController
{
#if 0
    m_cObjSearchBarPtr = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0 ,self.navigationController.navigationBar.frame.size.height , self.view.bounds.size.width, 44)];
#else
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
         m_cObjSearchBarPtr = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0 ,self.navigationController.navigationBar.frame.size.height+20 , self.view.bounds.size.width, 44)];
    }
    else
    {
        m_cObjSearchBarPtr = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0 ,0.0, self.view.bounds.size.width, 44)];
         NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
        
    }
    
#endif
	m_cObjSearchBarPtr.showsCancelButton = NO;
	m_cObjSearchBarPtr.placeholder = @"Search";
	m_cObjSearchBarPtr.delegate = self;
    m_cObjSearchBarPtr.barStyle = UIBarStyleBlackOpaque;
	
   
//    m_cObjSearchDisplayControllerPtr =[[UISearchDisplayController alloc]initWithSearchBar:m_cObjSearchBarPtr contentsController:self];
    
    
//    m_cObjSearchDisplayControllerPtr.delegate =self;
//    m_cObjSearchDisplayControllerPtr.searchResultsDelegate = self;
//    m_cObjSearchDisplayControllerPtr.searchResultsDataSource =self;
    [self.view addSubview:m_cObjSearchBarPtr];
}


-(void)createElements
{
    
    UIBarButtonItem		*lObjAddButtonPtr = (UIBarButtonItem *)nil;
	CGRect				lObjRect = CGRectZero;
    CGFloat              lHeight = {0.0};
    lObjAddButtonPtr = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonPressed:) ];
    self.navigationItem.rightBarButtonItem = lObjAddButtonPtr;
    
   
    SAFE_RELEASE(lObjAddButtonPtr)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
         lHeight = self.navigationController.navigationBar.frame.size.height + m_cObjSearchBarPtr.frame.size.height+20;
        lObjRect = CGRectMake(CGRectGetMinX(self.view.frame),lHeight,CGRectGetWidth(self.view.frame),self.view.frame.size.height-(self.tabBarController.tabBar.frame.size.height+lHeight));
          NSLog(@"%f",self.tabBarController.tabBar.frame.size.height);
          NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
          NSLog(@"%f",self.view.frame.size.height);

    }
    else
    {
        
       lObjRect = CGRectMake(CGRectGetMinX(self.view.frame),lHeight+m_cObjSearchBarPtr.frame.size.height,CGRectGetWidth(self.view.frame),self.view.frame.size.height-(m_cObjSearchBarPtr.frame.size.height+self.tabBarController.tabBar.frame.size.height+self.navigationController.navigationBar.frame.size.height));
        NSLog(@"%f",self.tabBarController.tabBar.frame.size.height);
        NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
        NSLog(@"%f",self.view.frame.size.height);
        

    }
    m_cObjTablePtr = [[UITableView alloc] initWithFrame:lObjRect style:UITableViewStylePlain];
	m_cObjTablePtr.backgroundColor = [UIColor whiteColor];
	m_cObjTablePtr.delegate = self;
	m_cObjTablePtr.dataSource = self;
	m_cObjTablePtr.autoresizesSubviews = YES;
	m_cObjTablePtr.scrollEnabled = YES;
	m_cObjTablePtr.allowsSelectionDuringEditing = YES;
    m_cObjTablePtr.alpha = 1.0;
    [self.view addSubview:m_cObjTablePtr];
    
    if (m_cObjNoDataLablePtr == (UILabel *)nil)
    {
        m_cObjNoDataLablePtr = [[UILabel alloc]init];
        m_cObjNoDataLablePtr.text = NSLocalizedString(@"NO_DATA", @"");
        m_cObjNoDataLablePtr.textAlignment = UITextAlignmentCenter;
    }
    
    //SAFE_RELEASE(lObjScrollViewPtr)
    
}
#pragma mark - Searchbar Delegate Start

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    self.navigationController.navigationBar.hidden=NO;
    //m_cObjTablePtr.contentSize = CGSizeMake(320, m_cObjMenuCategoryPtr.m_cObjMenuItemsList.count * 50 + 250);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = @"";
    m_cIsSearch = NO;
    m_cObjTablePtr.backgroundView = nil;
    searchBar.showsCancelButton = NO;
    [m_cObjSearchBarPtr resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"m_cObjItemName contains[cd] %@",searchBar.text];
        
        NSArray *results = [self filterContentForSearchText:searchBar.text];
        if([results count] > 0)
        {
            m_cObjsearchResults = [results mutableCopy];
        }
        else
        {
            m_cObjsearchResults = nil;
        }
    
    
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [m_cObjTablePtr reloadData];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        m_cIsSearch = NO;
        m_cObjTablePtr.backgroundView = nil;
    }
    else
    {
        m_cIsSearch = YES;
        
            NSArray *results = [self filterContentForSearchText:searchText];
            
            if([results count] > 0)
            {
                m_cObjsearchResults = [results mutableCopy];
            }
            else
            {
                m_cObjsearchResults = nil;
            }
        
    }
    [m_cObjTablePtr reloadData];
}
- (NSMutableArray *)filterContentForSearchText:(NSString*)searchText
{
    /*
     Update the filtered array based on the search text and scope.
     */
    
    [self.m_cObjfilteredListContent removeAllObjects]; // First clear the filtered array.
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (Athlete *athlete in gObjAppDelegatePtr.m_cObjAthleteListPtr)
    {
        NSString *lObjAthletePhoneNumberPtr = (NSString *)nil;
        NSString *lObjAthletePhoneNumber = (NSString *)nil;
        NSString *lObjAthleteFirstName = (NSString *)nil;
        NSComparisonResult result1 = -1L;
        NSComparisonResult result2 = -1L;
        
        if ((NSString *)nil !=athlete.m_cObjPhoneNumberPtr && ![athlete.m_cObjPhoneNumberPtr isEqualToString:@""] && ![athlete.m_cObjPhoneNumberPtr isEqualToString:@" "]) {
            lObjAthletePhoneNumberPtr = athlete.m_cObjPhoneNumberPtr;
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
            NSArray *phoneArray = (NSArray *)nil;
            phoneArray = [lObjAthletePhoneNumberPtr componentsSeparatedByCharactersInSet:set];
            lObjAthletePhoneNumber =[phoneArray componentsJoinedByString:@""];
            if ((NSString *)nil != lObjAthletePhoneNumber) {
                result2 = [lObjAthletePhoneNumber compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            }
            
        }
        if ((NSString *)nil !=athlete.m_cObjFirstNamePtr && ![athlete.m_cObjFirstNamePtr isEqualToString:@""] && ![athlete.m_cObjFirstNamePtr isEqualToString:@" "]) {
            
            lObjAthleteFirstName = athlete.m_cObjFirstNamePtr;
            if ((NSString *)nil != lObjAthleteFirstName) {
                result1 = [lObjAthleteFirstName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            }
        }
        
        
        
        if (result1 == NSOrderedSame || result2 == NSOrderedSame)
        {
            [self.m_cObjfilteredListContent addObject:athlete];
        }
        
    }
    return self.m_cObjfilteredListContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onAddButtonPressed : (id)sender
{
    AddAthleteViewController *lObjAddAthleteViewControllerPtr = (AddAthleteViewController *)nil;
    lObjAddAthleteViewControllerPtr = [[AddAthleteViewController alloc]init];
    [self.navigationController pushViewController:lObjAddAthleteViewControllerPtr animated:YES];
    SAFE_RELEASE(lObjAddAthleteViewControllerPtr)
}

#pragma mark tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    m_cObjAtheleteCountLabelPtr.text = [NSString stringWithFormat:@"No of Athletes  %d",[gObjAppDelegatePtr.m_cObjAthleteListPtr count]];
    int lRetun = 0;
    if (YES == m_cIsSearch)
    {
        lRetun =  [m_cObjsearchResults count];
        
        if (lRetun > 0)
            m_cObjTablePtr.backgroundView = nil;
        else
            m_cObjTablePtr.backgroundView = m_cObjNoDataLablePtr;
    }
    else
    {
        lRetun =  [gObjAppDelegatePtr.m_cObjAthleteListPtr count];
    }
    return lRetun;


}
#pragma mark tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString      *lObjCellIdentifierPtr = @"AthleteDetailCell";
        NSString *lObjStrPtr = (NSString *)nil;
        AthleteDetailTableViewCell   *lObjCellPtr = (AthleteDetailTableViewCell *)nil;
        Athlete *lObjAthletePtr = (Athlete *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr]; 
        if((AthleteDetailTableViewCell *)nil == lObjCellPtr)
            {
               lObjCellPtr = [[[AthleteDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:lObjCellIdentifierPtr] autorelease];
                }
        
        
        if (m_cIsSearch == YES)
        {
            lObjAthletePtr = (Athlete *)[m_cObjsearchResults objectAtIndex:indexPath.row];
//            lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            
            
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - start
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isIDexists = NO;
            NSString *lObjImageNamePathPtr = (NSString *)nil;
            
            NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
            
            if (athleteIdsPtr.count > 0) {
                for (int i=0; i<athleteIdsPtr.count; i++) {
                    if ([lObjAthletePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                        isIDexists = YES;
                        lObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                    }
                }
            }
            
            NSString *lObjImageNamePtr = (NSString *)nil;
            BOOL fileExists = NO;
            
            if (YES == isIDexists) {
                lObjImageNamePtr = lObjImageNamePathPtr;
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePtr];
                
                if (NO == fileExists && (NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }
            }
            else{
                if ((NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:lObjAthletePtr.m_cAthleteId AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }
            }
            
            if (NO == fileExists && (NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
            
            if (YES == fileExists) {
                NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageWithData:lObjImageDataPtr];
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
            }
            else
            {
                //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageNamed:@"AthleteImage.png"] forState:UIControlStateNormal];
                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
            }
            //Narasimhaiah adding to set photo to athlete record 25-2-13 - end
        
            
            
        NSString *lObjStrPtr = [NSString stringWithFormat:@"%@%@%@", GET_STR(lObjAthletePtr.m_cObjFirstNamePtr),GET_SPACE(lObjAthletePtr.m_cObjFirstNamePtr), GET_STR(lObjAthletePtr.m_cObjLastNamePtr)];

           lObjCellPtr.m_cAthleteNamePtr.text = lObjStrPtr;
        }
        else
            {
                lObjAthletePtr = (Athlete *)[gObjAppDelegatePtr.m_cObjAthleteListPtr objectAtIndex:indexPath.row];
                
                lObjStrPtr = [NSString stringWithFormat:@"%@%@%@", GET_STR(lObjAthletePtr.m_cObjFirstNamePtr),GET_SPACE(lObjAthletePtr.m_cObjFirstNamePtr), GET_STR(lObjAthletePtr.m_cObjLastNamePtr)];
                
                
                
                //Narasimhaiah adding to set photo to athlete record 25-2-13 - start
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL isIDexists = NO;
                NSString *lObjImageNamePathPtr = (NSString *)nil;

                NSArray *athleteIdsPtr =gObjAppDelegatePtr.m_cObjDictionaryPtr.allKeys;
                
                if (athleteIdsPtr.count > 0) {
                    for (int i=0; i<athleteIdsPtr.count; i++)
                    {
                        if ([lObjAthletePtr.m_cAthleteId isEqualToString:[athleteIdsPtr objectAtIndex:i]]) {
                            isIDexists = YES;
                            lObjImageNamePathPtr = [gObjAppDelegatePtr.m_cObjDictionaryPtr objectForKey:[athleteIdsPtr objectAtIndex:i]];
                        }
                    }
                }
                
                NSString *lObjImageNamePtr = (NSString *)nil;
                BOOL fileExists = NO;
                
                if (YES == isIDexists)
                {
                    lObjImageNamePtr = lObjImageNamePathPtr;
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePtr];
                    
                    if (NO == fileExists &&
                        (NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr &&
                        ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] &&
                        ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "])
                    {
                        lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                        //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                        fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                    }
                }
                else{
                    if ((NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
                        lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:lObjAthletePtr.m_cAthleteId AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                        //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                        fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                    }
                }
                
                if (NO == fileExists &&
                    (NSString *)nil != lObjAthletePtr.m_cPhotoNamePtr &&
                    ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] &&
                    ![lObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "])
                {
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders:nil AthImageName:lObjAthletePtr.m_cPhotoNamePtr];
                    //lObjImageNamePathPtr = [lObjPhotoFolderPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"/Athlete-%@.png",self.m_cObjAthleteDetailStructurePtr.m_cAthleteId]];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }

                
                if (YES == fileExists)
                {
                    NSData *lObjImageDataPtr = [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
                    lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageWithData:lObjImageDataPtr];
                    //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageWithData:lObjImageDataPtr] forState:UIControlStateNormal];
                }
                else
                {
                    //[lObjCellPtr.m_cAthleteImageViewPtr.image setImage:[UIImage imageNamed:@"AthleteImage.png"] forState:UIControlStateNormal];
                    lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
                }
                //Narasimhaiah adding to set photo to athlete record 25-2-13 - end
                 
//                lObjCellPtr.m_cAthleteImageViewPtr.image = [UIImage imageNamed:@"AthleteImage.png"];
                lObjCellPtr.m_cAthleteNamePtr.text = lObjStrPtr;
            } 
                
        
        lObjCellPtr.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (YES == m_cIsSearch)
    {
        AthleteLoggerViewController *lObjAthleteLoggerViewController = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewController = [[AthleteLoggerViewController alloc]init];
            lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr = [m_cObjsearchResults objectAtIndex:indexPath.row];
//            gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
 
            [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
            gObjAppDelegatePtr.IsinFavourites = lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete;

            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr];
            lObjAthleteLoggerViewController.m_cObjCombineIdPtr = self.m_cObjHomeCombineIdPtr;
           
        
        [self.navigationController pushViewController:lObjAthleteLoggerViewController animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewController)
       

    }
    else{
        AthleteLoggerViewController *lObjAthleteLoggerViewController = (AthleteLoggerViewController *)nil;
        
        
        lObjAthleteLoggerViewController = [[AthleteLoggerViewController alloc]init];
        
        
            lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr = [gObjAppDelegatePtr.m_cObjAthleteListPtr objectAtIndex:indexPath.row];
      
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;

 
        gObjAppDelegatePtr.IsinFavourites = lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr];

        lObjAthleteLoggerViewController.m_cObjCombineIdPtr = self.m_cObjHomeCombineIdPtr;
        
        [self.navigationController pushViewController:lObjAthleteLoggerViewController animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewController)
        
        NSLog(@"m_cObjHomeCombineIdPtr = %d\n",self.m_cObjHomeCombineIdPtr);
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (YES == m_cIsSearch)
    {
        AthleteLoggerViewController *lObjAthleteLoggerViewController = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewController = [[AthleteLoggerViewController alloc]init];

        lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr = [m_cObjsearchResults objectAtIndex:indexPath.row];
//        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
 
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;

        
        gObjAppDelegatePtr.IsinFavourites = lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr];

         lObjAthleteLoggerViewController.m_cObjCombineIdPtr = self.m_cObjHomeCombineIdPtr;

        [self.navigationController pushViewController:lObjAthleteLoggerViewController animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewController)
        
    }
    else
    {
        AthleteLoggerViewController *lObjAthleteLoggerViewController = (AthleteLoggerViewController *)nil;
        lObjAthleteLoggerViewController = [[AthleteLoggerViewController alloc]init];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr = [gObjAppDelegatePtr.m_cObjAthleteListPtr objectAtIndex:indexPath.row];
//        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Athlete Detail from server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
 
        gObjAppDelegatePtr.IsinFavourites = lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr.isFavouriteAthlete;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadAthleteInformation:lObjAthleteLoggerViewController.m_cObjAthleteDetailStructurePtr];

        lObjAthleteLoggerViewController.m_cObjCombineIdPtr = self.m_cObjHomeCombineIdPtr;
            
        [self.navigationController pushViewController:lObjAthleteLoggerViewController animated:YES];
        SAFE_RELEASE(lObjAthleteLoggerViewController)
    }
}
#if 0
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
   // Return YES to cause the search result table view to be reloaded.
    return YES;
}
#endif

-(void)onAboutButtonPressed : (id)sender
{
    AboutViewController *lObjAboutViewCtlrPtr = (AboutViewController *)nil;
    lObjAboutViewCtlrPtr = [[AboutViewController alloc]init];
    [self presentModalViewController:lObjAboutViewCtlrPtr animated:YES];
    SAFE_RELEASE(lObjAboutViewCtlrPtr)
    
}


-(void)dealloc
{
    SAFE_RELEASE(m_cObjAthleteDetailStructurePtr)
    SAFE_RELEASE(keyboardDoneButtonView)
    SAFE_RELEASE(m_cObjAthleteLogArrayPtr)
    SAFE_RELEASE(m_cObjCombineIDsPtr)
    SAFE_RELEASE(m_cObjCombineListPtr)
    SAFE_RELEASE(m_cObjPickerToolBarPtr)
    SAFE_RELEASE(m_cObjPickerViewPtr)
    SAFE_RELEASE(m_cObjToolBarPtr)
   // SAFE_RELEASE(m_cObjSearchDisplayControllerPtr)
    SAFE_RELEASE(m_cObjSearchBarPtr)
    SAFE_RELEASE(m_cObjTablePtr)
    SAFE_RELEASE(m_cObjfilteredListContent)
    SAFE_RELEASE(m_cObjAtheleteCountLabelPtr)
    [super dealloc];
}

@end
