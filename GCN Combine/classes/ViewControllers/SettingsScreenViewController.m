 //
//  SettingsScreenViewController.m
//  GCN Combine
//
//  Created by DP Samant on 18/07/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import "SettingsScreenViewController.h"
#import "Macros.h"
#import "AppDelegate.h"
#import "HomeViewController.h"


@implementation SettingsScreenViewController
@synthesize isUploadtoServer,m_cObjActionSheetPtr,m_cObjLogArrayPtr,m_cObjAthleteImagesListPtr,m_cObjAtthleteListPtr,m_cObjAthletePtr,requestisFor,m_cObjAthleteLogPtr,m_cObjToolBarPtr,IsPickerDispaly,m_cObjPickerSelectionLablePtr,m_cObjCombineIdArrayPtr,m_cObjCombineListPtr,m_cObjCombineIDsPtr,m_cObjCombineIdPtr,m_cObjCombineNamePtr,m_cTestCount,keyboardDoneButtonView,m_cObjServerSelectiontextptr,m_CobjCombineSelectionTextPtr,isCombineDownloadFailedServer,m_cObjAnotherCombineNameString;
@synthesize m_cObjSettingsTableViewPtr = _m_cObjSettingsTableViewPtr;
@synthesize m_cIsForDeleteLocalInformation;
- (id)initWithTabBar
{
    self = [super init];
    if (self) 
    {
        m_cUploadCount = -1;
        m_cUploadLogCount=-1;
        UITabBarItem *lObjTabbarItem = (UITabBarItem *)nil;
        lObjTabbarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", @"") image:[UIImage imageNamed:NSLocalizedString(@"SettingsLogo", @"")] tag:0];
        self.tabBarItem = lObjTabbarItem;
         self.tabBarController.navigationController.navigationBar.hidden = YES;
        self.title = NSLocalizedString(@"Settings", @"");
        SAFE_RELEASE(lObjTabbarItem)

        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"screen320x480", @"")]];
        self.m_cObjSettingsTableViewPtr     =(UITableView *)nil;
       m_cObjPickerSelectionLablePtr=(UILabel *)nil;
        isUploadtoServer = NO;
        gObjAppDelegatePtr.IsAboutView = NO;
        m_cIsForDeleteLocalInformation=NO;
        isCombineDownloadFailedServer=NO;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)loadView
{
    [super loadView];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self CreateControl];
    

    NSLog(@"%@",gObjAppDelegatePtr.m_cObjCombineTitleStringPtr);
    gObjAppDelegatePtr.IsinFavourites = NO;
    gObjAppDelegatePtr.isAlertViewShown = NO;
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
   
    SAFE_RELEASE(lObjTempDictPtr)
    self.m_cObjCombineListPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allValues]] retain];
    m_cObjCombineIDsPtr = [[NSMutableArray arrayWithArray:[gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr allKeys]] retain];
    
    
    if (gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr.count > 0) {
        m_cObjAthleteLogArrayPtr = (NSMutableArray *)nil;
        
        if(gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.count > 0)
        {
            NSArray *lObjKeysPtr = gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr.allKeys;
            
            for (int i=0; i<lObjKeysPtr.count; i++) {
                
                m_cObjCombineIdPtr = [[gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr objectForKey:[lObjKeysPtr objectAtIndex:i]] integerValue];
                
                NSString *lObjcombineIdPtr = [NSString stringWithFormat:@"%d",m_cObjCombineIdPtr];
                
                m_cObjCombineNamePtr = [gObjAppDelegatePtr.m_cObjCombineIdNameDictPtr objectForKey:lObjcombineIdPtr];
#if 0                
                if (gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr.count > 0) {
                    [gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr removeAllObjects];
                }

                gObjAppDelegatePtr.m_cObjCombineTestsArrayPtr =[gObjAppDelegatePtr.m_cDbHandler getCombineTests :m_cObjCombineIdPtr CombineName:m_cObjCombineNamePtr];
#endif
       
                break;
            }
        }
        else if (-1 == m_cObjCombineIdPtr && (NSString *)nil == m_cObjCombineNamePtr && 0 < self.m_cObjCombineListPtr.count)
        {
            m_cObjCombineIdPtr = [[m_cObjCombineIDsPtr objectAtIndex:0] integerValue];
            m_cObjCombineNamePtr =[self.m_cObjCombineListPtr objectAtIndex:0];

            
            //To save the Last Sel Combine  into UserDefaults 11-3-13 - start
            NSUserDefaults *languagePrefs = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            [languagePrefs setObject:gObjAppDelegatePtr.m_cObjLastSelectedCombineIdPtr forKey:@"LastSelCombine"];
            [languagePrefs synchronize];
            //To save the Last Sel Combine  into UserDefaults 11-3-13 - end
        }
        
    }
    else
    {
               
    }
    //Narasimhaiah adding to get the Combine Ids 18-6-2013 end
    SAFE_RELEASE(lObjArrayPtr)
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr= self;
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    //[m_cObjTablePtr reloadData];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled =YES;
}
-(void)CreateControl
{
    //For Table View;
    CGRect              lRect = CGRectZero;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lRect = CGRectMake(0.0, 0.0, 320.0, 350.0);
    }
    else
    {
        lRect = CGRectMake(0.0, 0.0, 320.0, 250.0);
    }
    if (m_cObjPickerSelectionLablePtr == nil)
    {
        m_cObjPickerSelectionLablePtr = [[UILabel alloc]initWithFrame:CGRectMake(190,0, 150, 45)];
        [m_cObjPickerSelectionLablePtr setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:14.0]];
        [m_cObjPickerSelectionLablePtr setTextColor:[UIColor blackColor]];
        m_cObjPickerSelectionLablePtr.backgroundColor=[UIColor clearColor];
        m_cObjPickerSelectionLablePtr.text = [self languageDisplayNameForCode:gObjAppDelegatePtr.m_cUserSelServer];
        m_cObjPickerSelectionLablePtr.textAlignment=UITextAlignmentCenter;
    }

    
    UITableView *lObjTempTable =(UITableView *)nil;
    
    if (self.m_cObjSettingsTableViewPtr == (UITableView *)nil)
    {
        lObjTempTable = [[UITableView alloc] initWithFrame:lRect 
                                                     style:UITableViewStyleGrouped];
        self.m_cObjSettingsTableViewPtr = lObjTempTable;
        SAFE_RELEASE(lObjTempTable)
        self.m_cObjSettingsTableViewPtr.backgroundColor = [UIColor clearColor];
        self.m_cObjSettingsTableViewPtr.backgroundView = nil;
        self.m_cObjSettingsTableViewPtr.delegate = self;
        self.m_cObjSettingsTableViewPtr.dataSource = self;
        self.m_cObjSettingsTableViewPtr.scrollEnabled = NO;
        self.m_cObjSettingsTableViewPtr.allowsSelectionDuringEditing = YES;
        self.m_cObjSettingsTableViewPtr.alpha = 1.0;
        [self.view addSubview:self.m_cObjSettingsTableViewPtr];
    }
     [_m_cObjSettingsTableViewPtr reloadData];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)createServerSelectionPicker
{
     m_cObjPickerSelectionLablePtr.text=@"";
    m_cObjSupportingServersPtr = [[NSMutableArray alloc] initWithObjects:@"Production",@"Test", nil];
    UIPickerView *lObjTempPickerViewptr =(UIPickerView *)nil;
    if (m_cObjPickerViewPtr==(UIPickerView *)nil)
    {
        lObjTempPickerViewptr=[[UIPickerView alloc]init];
        m_cObjPickerViewPtr=lObjTempPickerViewptr;
        m_cObjPickerViewPtr = [[UIPickerView alloc] init];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
             m_cObjPickerViewPtr.frame = CGRectMake(0, self.view.frame.size.height-(self.tabBarController.tabBar.frame.size.height+110), 320, 110);
            NSLog(@"%f",self.tabBarController.tabBar.frame.size.height);
            m_cObjPickerViewPtr.backgroundColor=[UIColor whiteColor];
          
            
        }
        else
        {
             m_cObjPickerViewPtr.frame = CGRectMake(0, 480, 320, 80);
            
        }
       
        m_cObjPickerViewPtr.delegate = self;
        m_cObjPickerViewPtr.dataSource = self;
        m_cObjPickerViewPtr.showsSelectionIndicator = YES;
        
        [m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    }
    // create a UIPicker view as a custom keyboard view
    
    //Sougat
    m_cObjPickerSelectionLablePtr.text = [m_cObjSupportingServersPtr objectAtIndex:[m_cObjPickerViewPtr selectedRowInComponent:0]];//sougata added on 01/08/2013/for fixed the text of server selection label in server selection label.
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];//notice this is ON screen!
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0, -120, 320, 350);
    }
    else
    {
         self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0, -50, 320, 250);
    }
   
    
    [UIView commitAnimations];
    //By Default 0th Row Will Be Selected
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar *lObjTempkeyboardDoneButtonViewPtrptr =(UIToolbar *)nil;
    if (m_cObjkeyboardDoneButtonViewPtr==(UIToolbar *)nil)
    {
        lObjTempkeyboardDoneButtonViewPtrptr=[[UIToolbar alloc]init];
        m_cObjkeyboardDoneButtonViewPtr=lObjTempkeyboardDoneButtonViewPtrptr;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
             m_cObjkeyboardDoneButtonViewPtr.frame = CGRectMake(0, self.view.frame.size.height-(self.tabBarController.tabBar.frame.size.height+150), 320, 50);
        }
        else
        {
           m_cObjkeyboardDoneButtonViewPtr.frame = CGRectMake(0, 440, 320, 50);
        }
        m_cObjkeyboardDoneButtonViewPtr.barStyle = UIBarStyleBlack;
        m_cObjkeyboardDoneButtonViewPtr.translucent = YES;
        m_cObjkeyboardDoneButtonViewPtr.tintColor = nil;
        UIBarButtonItem  *doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(languagePickerDoneClicked:)] autorelease];
        UIBarButtonItem *flexspaceButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem  *lObjCancelbuttonPtr = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelButtonClicked)] autorelease];
        
        [m_cObjkeyboardDoneButtonViewPtr setItems:[NSArray arrayWithObjects:doneButton,flexspaceButton,lObjCancelbuttonPtr, nil]];
        //SAFE_RELEASE(lObjCancelbuttonPtr)
    }
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
       m_cObjPickerViewPtr.frame = CGRectMake(0, self.view.frame.size.height-(self.tabBarController.tabBar.frame.size.height+150), 320, 100);
       m_cObjkeyboardDoneButtonViewPtr.frame = CGRectMake(0, self.view.frame.size.height-(self.tabBarController.tabBar.frame.size.height+200), 320, 50);//notice this is ON screen!

    }
    else
    {
        [m_cObjPickerViewPtr setFrame:CGRectMake( 0.0, 220, 320.0f, 100.0)];
        [m_cObjkeyboardDoneButtonViewPtr setFrame:CGRectMake( 0,190, 320, 30.0)];//notice this is ON screen!
    }

       [UIView commitAnimations];
    
    [self.view addSubview:m_cObjkeyboardDoneButtonViewPtr];
    [self.view addSubview:m_cObjPickerViewPtr];
}
-(void)languagePickerDoneClicked:(id)sender
{
    //Srikant Agust 2 start
    m_cRowValue = 0;
    m_cPreviusCombineId=m_cRowValue;
    gObjAppDelegatePtr.m_cCMBNIDPtr = (NSString *)nil;
    //Srikant Agust 2 start
     m_cObjPickerSelectionLablePtr.text=@"";
    m_cObjPickerSelectionLablePtr.text = [m_cObjSupportingServersPtr objectAtIndex:[m_cObjPickerViewPtr selectedRowInComponent:0]];
    self.m_cObjServerSelectiontextptr=[NSString stringWithFormat:@"%@",m_cObjPickerSelectionLablePtr.text];//sougata added on 5/8/13
    
    //post the notification for language selection
    //all the receiver of this notification will update the control text in the respective language
    //save the selected language name (culture like en) in the userinfo]
    NSString *lSelServerCode = [self ServerCodeForDisplayName:m_cObjPickerSelectionLablePtr.text];
    
    NSUserDefaults *languagePrefs = [NSUserDefaults standardUserDefaults];
    // saving an NSString
    [languagePrefs setObject:lSelServerCode forKey:@"userSelServer"];
    [languagePrefs synchronize];
    
    gObjAppDelegatePtr.m_cUserSelServer = lSelServerCode;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:lSelServerCode forKey:@"userSelServer"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localizedServerChanged" object:self userInfo:userInfo];
   // m_cObjPickerViewPtr.frame = CGRectMake( 0.0, 300.0, 320.0f, 100.0);
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0.0, 0.0, 320.0, 350.0);
        [m_cObjPickerViewPtr setFrame:CGRectMake( 0.0, 700.0, 320.0f, 100.0)];
        m_cObjkeyboardDoneButtonViewPtr.frame =CGRectMake ( 0, 700, 320, 30.0);
    }
    else
    {
        self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0.0, 0.0, 320.0, 250.0);
        [m_cObjPickerViewPtr setFrame:CGRectMake( 0.0, 700, 320.0f, 100.0)];
        m_cObjkeyboardDoneButtonViewPtr.frame =CGRectMake ( 0, 700, 320, 30.0);

    }
    
    [UIView commitAnimations];
    BOOL lRetVal = NO;
    lRetVal = [gObjAppDelegatePtr.m_cDbHandler clearLocalDB];
    if (lRetVal) {
        [gObjAppDelegatePtr.m_cObjDictionaryPtr removeAllObjects];
        NSFileManager *lObjFileMangrPtr = [NSFileManager defaultManager];
        NSArray *lObjDocumentDirsListPtr = (NSArray *)nil;
        NSString *lObjDocumentDirPathPtr = (NSString *)nil;
        NSString *lObjRootFolderPathPtr = (NSString *)nil;
        
        lObjDocumentDirsListPtr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        lObjDocumentDirPathPtr = [lObjDocumentDirsListPtr objectAtIndex:0];
        
        lObjRootFolderPathPtr = [lObjDocumentDirPathPtr stringByAppendingPathComponent:@"Photo"];
        lRetVal = [lObjFileMangrPtr removeItemAtPath:lObjRootFolderPathPtr error:nil];
    }
    [HomeViewController  refreshHomeScreen];
    [_m_cObjSettingsTableViewPtr reloadData];
    SAFE_RELEASE(m_cObjCombinePickerViewPtr)
    
}
-(void)onCancelButtonClicked
{
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0.0, 0.0, 320.0, 350.0);
        [m_cObjPickerViewPtr setFrame:CGRectMake( 0.0, 700.0, 320.0f, 100.0)];
        m_cObjkeyboardDoneButtonViewPtr.frame =CGRectMake ( 0, 700, 320, 30.0);
    }
    else
    {
        self.m_cObjSettingsTableViewPtr.frame=CGRectMake(0.0, 0.0, 320.0, 250.0);
        [m_cObjPickerViewPtr setFrame:CGRectMake( 0.0, 700, 320.0f, 100.0)];
        m_cObjkeyboardDoneButtonViewPtr.frame =CGRectMake ( 0, 700, 320, 30.0);
        
    }

    [UIView commitAnimations];
    //sougata added on 5/8/2013
    if ( m_cObjPickerSelectionLablePtr!=nil)
    {
        if ([self.m_cObjServerSelectiontextptr isEqualToString:@"Production"] )
        {
            self.m_cObjPickerSelectionLablePtr.text = self.m_cObjServerSelectiontextptr;
            [m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
            
        }
        if ([self.m_cObjServerSelectiontextptr isEqualToString:@"Test"] )
        {
            self.m_cObjPickerSelectionLablePtr.text = self.m_cObjServerSelectiontextptr;
            [m_cObjPickerViewPtr selectRow:1 inComponent:0 animated:YES];
            
        }
        
    }
    //end
    
}
- (NSString *)ServerCodeForDisplayName:(NSString*)pLangDisName
{
    NSString *lLangCode = nil;
    
    if(YES == [pLangDisName isEqualToString:@"Production"])
    {
        lLangCode = @"Production";
    }
    else if(YES == [pLangDisName isEqualToString:@"Test"])
    {
        lLangCode = @"Test";
    }
    
    return lLangCode;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
//table view delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRow = -1;
    lRow=5;
    return lRow;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     NSInteger lSection = -1;
    lSection=1;
    return lSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    
    //Initialize Label
    if (indexPath.row==0)
    {

        cell.textLabel.text= @"Choose Combine";

        
        if(self.m_cObjCombineListPtr.count>0)
        {

           
            m_CobjCombineSelectionTextPtr=[NSString stringWithFormat:@"%@",[self.m_cObjCombineListPtr objectAtIndex:0]];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",gObjAppDelegatePtr.m_cObjCombineTitleStringPtr];
               //isCombineDownloadFailedServer=NO;
           
        }
        else
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@""];
        }

    }
    else if(indexPath.row==1)
    {

         cell.textLabel.text= @"Clear Local App Data";
    }
    else if(indexPath.row==2)
    {

         cell.textLabel.text= @"Reload Athlete Data";
    }
    else if(indexPath.row==3)
    {

        cell.textLabel.text= @"Sync Offline Data";
    }
    else if(indexPath.row==4)
    {

         cell.textLabel.text= @"Server Selection";
    [cell addSubview:m_cObjPickerSelectionLablePtr];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
    
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.row==0)
    {   //[self onCancelButtonClicked];
        [self.m_cObjCombineListPtr removeAllObjects];
        NSMutableDictionary     *lObjDictionaryPtr = (NSMutableDictionary *)nil;
        lObjDictionaryPtr = [[NSMutableDictionary alloc]init];
//       Srikant agust
        lObjDictionaryPtr = [gObjAppDelegatePtr.m_cDbHandler getCombineIdAndNames];
        self.m_cObjCombineListPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allValues]] retain];
        
        gObjAppDelegatePtr.m_cObjCombineIDArrayPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allKeys]] retain];

        m_cObjCombineIdArrayPtr = gObjAppDelegatePtr.m_cObjCombineIDArrayPtr;
        [m_cObjCombinePickerViewPtr reloadAllComponents];
        
        NSLog(@"%d",self.m_cObjCombineListPtr.count);
        if (self.m_cObjCombineListPtr.count > 0)
        {
          BOOL IsCreate =   [self showElemTypePicker];
         
            if (IsCreate == NO)
            {
                [m_cObjCombinePickerViewPtr selectRow:m_cPreviusCombineId inComponent:0 animated:YES];
                m_cRowValue=m_cPreviusCombineId;
            }
        }
        else
        {
            UIAlertView *lObjAlertForNoNetworkPtr =(UIAlertView *)nil;
            lObjAlertForNoNetworkPtr=[[UIAlertView alloc]initWithTitle:@"GCN Combine"
                                                               message:@"There is no existing Combine to choose."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil, nil];
            lObjAlertForNoNetworkPtr.tag = 996;
            [lObjAlertForNoNetworkPtr show];
            
        }
        
    }

    if (indexPath.row==1) 
        //sougata aadded this on 14 aug
        
    {
        
        if ([gObjAppDelegatePtr.m_cDbHandler CountRecordForTable:@"CombineTestID"] ||
            [gObjAppDelegatePtr.m_cDbHandler CountRecordForTable:@"Athlete"] || 
            [gObjAppDelegatePtr.m_cDbHandler CountRecordForTable:@"Tests"] ||
            [gObjAppDelegatePtr.m_cDbHandler CountRecordForTable:@"Log"] ) 
        {
            isUploadtoServer = NO;
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Are you sure you want to delete Local Information" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""),nil];
            [lObjAlertviewPtr show];
            lObjAlertviewPtr.delegate = self;
            
            
        }
        else
        {
            UIAlertView *lObjAlertForNoNetworkPtr =(UIAlertView *)nil;
                       lObjAlertForNoNetworkPtr=[[UIAlertView alloc]initWithTitle:@"GCN Combine"
                                                                           message:@"You have already deleted all information."
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Ok"
                                                                 otherButtonTitles:nil, nil];
                        lObjAlertForNoNetworkPtr.tag = 995;
                        [lObjAlertForNoNetworkPtr show];
            
            
           
            
        }

    }
    if (indexPath.row==2)
    {
        if (YES ==[gObjAppDelegatePtr isNetworkAvailable])
        {
        UIAlertView *lObjAlert =(UIAlertView *)nil;
        lObjAlert=[[UIAlertView alloc]initWithTitle:@"GCN Combine"
                                            message:@"Do you want to Reload Athlete Data"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Ok", nil];
        lObjAlert.tag = 999;
        [lObjAlert show];
        SAFE_RELEASE(lObjAlert)
        }
        else
        {
            UIAlertView *lObjAlertForNoNetworkPtr =(UIAlertView *)nil;
            lObjAlertForNoNetworkPtr=[[UIAlertView alloc]initWithTitle:@"GCN Combine"
                                                message:@"Netwok connection not available."
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
            lObjAlertForNoNetworkPtr.tag = 998;
            [lObjAlertForNoNetworkPtr show];
            
        }
    }

    if (indexPath.row==3) 
    {
       
        isUploadtoServer = YES;
        if (YES == [gObjAppDelegatePtr isNetworkAvailable]) 
        {
            gObjAppDelegatePtr.IsAboutView = YES;
            m_cIsAthletDataUpload = NO;
            m_cIsLogDataUpload = NO;
            m_cObjLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogsAddedinOfflineMode] retain];
            m_cObjAthleteImagesListPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthletePhotoAddedInOfflineMode] retain];
            m_cObjAtthleteListPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllAthletesAddedInOfflineMode] retain];
           
            if (m_cObjAtthleteListPtr.count > 0 ) 
            {
                [self uploadScandata];
                
            }
            if (m_cObjLogArrayPtr.count > 0)
            {
                [self uploadLogData];
            }
#if 0
            if (m_cIsAthletDataUpload == NO && m_cIsLogDataUpload == NO)
            {

                    UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
                    lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"There is no Data to upload to server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [lObjAlertviewPtr show];
                    SAFE_RELEASE(lObjAlertviewPtr)
            }
#endif
        }
        else if (NO == [gObjAppDelegatePtr isNetworkAvailable])
        {
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Network connection not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
        }
   }
      
     if(indexPath.row==4)
    {
        if (YES ==[gObjAppDelegatePtr isNetworkAvailable])
        {
            [self createServerSelectionPicker];
            self.m_cObjServerSelectiontextptr = gObjAppDelegatePtr.m_cUserSelServer;
        }
        else
        {
            UIAlertView *lObjAlertForNoNetworkPtr =(UIAlertView *)nil;
            lObjAlertForNoNetworkPtr=[[UIAlertView alloc]initWithTitle:@"GCN Combine"
                                                               message:@"Netwok connection not available."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil, nil];
            lObjAlertForNoNetworkPtr.tag = 997;
            [lObjAlertForNoNetworkPtr show];
            
        }

        
        
        
        
           }
}
-(void)uploadScandata
{
    [self uploadAthleteData];
}
-(void)uploadAthleteData
{
    gObjAppDelegatePtr.isOfflineData = YES;
    if (m_cUploadCount <= 0)
    {
        [m_cObjAtthleteListPtr removeAllObjects];
        m_cObjAtthleteListPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllAthletesAddedInOfflineMode] retain];
        if (m_cObjAtthleteListPtr.count > 0)
        {
            m_cUploadCount=m_cObjAtthleteListPtr.count;
        }
    }
    if (m_cUploadCount > 0) 
    {   
        NSLog(@"%d",m_cUploadCount);

        m_cIsAthletDataUpload = YES;
        [gObjAppDelegatePtr displayProgressHandler:@"Uploading Athlete Information to server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        NSPredicate *lObjPredicatePtr = (NSPredicate *)nil;
        lObjPredicatePtr = [NSPredicate predicateWithFormat:@"m_cAthleteId CONTAINS[cd] %@",@"ABCSFTXYZ_"];
        NSArray *lObjArrayPtr = [m_cObjAtthleteListPtr filteredArrayUsingPredicate:lObjPredicatePtr];
        NSError *error;
        
        if (lObjArrayPtr.count > 0)
        {
            m_cObjAthletePtr = [[lObjArrayPtr objectAtIndex:0] retain];
            
            //update Docs folder image name and path - 4-3-14 - start
            NSFileManager   *fileManager = [NSFileManager defaultManager];
            NSString        *lObjImageNamePathPtr = (NSString *)nil;
            BOOL            fileExists   = NO;
            
            if ((NSString *)nil != self.m_cObjAthletePtr.m_cPhotoNamePtr &&
                ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && 
                ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "])
            {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthletePtr.m_cAthleteId 
                                                               AthImageName:self.m_cObjAthletePtr.m_cPhotoNamePtr];
                
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                
                if (NO == fileExists && (NSString *)nil != 
                    self.m_cObjAthletePtr.m_cPhotoNamePtr && 
                    ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && 
                    ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) 
                {
                    lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:self.m_cObjAthletePtr.m_cPhotoNamePtr];
                    fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
                }
            }
            if (YES == fileExists) {
                gObjAppDelegatePtr.m_cObjImageDatePtr =  [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
                [fileManager removeItemAtPath:lObjImageNamePathPtr error:&error];
            }
            //update Docs folder image name and path - 4-3-14 - end
            else
            {
               m_cUploadCount--;
               m_cObjAthletePtr = [[m_cObjAtthleteListPtr objectAtIndex:m_cUploadCount] retain];
               gObjAppDelegatePtr.m_cObjTempAthleteIdPtr = m_cObjAthletePtr.m_cAthleteId;
               requestisFor = Upload;
               gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
              [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest :m_cObjAthletePtr isNewAthlete:YES];
            }
        }
        else
        {
                NSLog(@"%d",m_cUploadCount);
                m_cUploadCount--;
                m_cObjAthletePtr = [[m_cObjAtthleteListPtr objectAtIndex:m_cUploadCount] retain];
                gObjAppDelegatePtr.m_cObjTempAthleteIdPtr = m_cObjAthletePtr.m_cAthleteId;
                requestisFor = updateAthlet;
                
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest :m_cObjAthletePtr  isNewAthlete:NO];
            NSLog(@"%d",m_cUploadCount);
            NSLog(@"%d",m_cObjAtthleteListPtr.count);
        }
    }
}
-(void)uploadLogData
{
    //sougata added this on 16 aug
    if (m_cUploadLogCount <= 0)
    {
        [m_cObjLogArrayPtr removeAllObjects];
        m_cObjLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogsAddedinOfflineMode] retain];
        if (m_cObjLogArrayPtr.count > 0)
        {
            m_cUploadLogCount=m_cObjLogArrayPtr.count;
        }
    }
    //end
//sougata block this on 16 aug
    //requestisFor = Uploadlog;
   // m_cObjLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogsAddedinOfflineMode] retain];
    //end
    
      if (m_cUploadLogCount > 0) //sougata added this condition for more then one log on 16 aug
    {
        m_cIsLogDataUpload = YES;
        [gObjAppDelegatePtr displayProgressHandler:@"Uploading Log Information to server"];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        m_cUploadLogCount--;//sougata added this on 16 aug
        m_cObjAthleteLogPtr = [[m_cObjLogArrayPtr objectAtIndex:m_cUploadLogCount] retain];
        requestisFor = Uploadlog;
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :m_cObjAthleteLogPtr Tests:nil];
        
    }

}
-(void)uploadOnlyPendingImage
{
    
    requestisFor = UploadPendingImage;
    m_cObjAthleteImagesListPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthletePhotoAddedInOfflineMode] retain];
    if (m_cObjAthleteImagesListPtr.count > 0) {
               [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        
        
        //update Docs folder image name and path - 4-3-14 - start
        NSFileManager   *fileManager = [NSFileManager defaultManager];
        NSString        *lObjImageNamePathPtr = (NSString *)nil;
        BOOL            fileExists   = NO;
        
        if ((NSString *)nil != self.m_cObjAthletePtr.m_cPhotoNamePtr && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]){
            lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :self.m_cObjAthletePtr.m_cAthleteId AthImageName:self.m_cObjAthletePtr.m_cPhotoNamePtr];
            fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            if (NO == fileExists && (NSString *)nil != self.m_cObjAthletePtr.m_cPhotoNamePtr && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@""] && ![self.m_cObjAthletePtr.m_cPhotoNamePtr isEqualToString:@" "]) {
                lObjImageNamePathPtr = [gObjAppDelegatePtr getPhotoFolders :nil AthImageName:self.m_cObjAthletePtr.m_cPhotoNamePtr];
                fileExists = [fileManager fileExistsAtPath:lObjImageNamePathPtr];
            }
        }
        if (YES == fileExists) {
            gObjAppDelegatePtr.m_cObjImageDatePtr =  [NSData dataWithContentsOfFile:lObjImageNamePathPtr];
            // [fileManager removeItemAtPath:lObjImageNamePathPtr error:&error];
        }
        //update Docs folder image name and path - 4-3-14 - end
        m_cObjAthletePtr = [[m_cObjAthleteImagesListPtr objectAtIndex:0] retain];
        gObjAppDelegatePtr.IsPendingImage = YES;
        [gObjAppDelegatePtr uploadAthleteImage:m_cObjAthletePtr];
    }
    else
    {
        UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
        lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"There is no Data to upload to server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        lObjAlertviewPtr.tag=994;
        [lObjAlertviewPtr show];
        SAFE_RELEASE(lObjAlertviewPtr)
    }
}
-(void)serverTransactionSucceeded
{
    m_cIsForDeleteLocalInformation=NO;
    if (requestisFor != Upload ||  requestisFor != updateAthlet)
    {
        [[gObjAppDelegatePtr getHomeViewcontrollerScreen] homeServerTransactionSucceeded];    
           }
   if (requestisFor == Upload || 
             requestisFor == updateAthlet || requestisFor == Download)
    
    {
        
        
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
         m_cObjLogArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAthleteLogsAddedinOfflineMode] retain];
        if (requestisFor == Upload) 
        {
            
            m_cObjAthletePtr.m_cAthleteId = gObjAppDelegatePtr.m_cAthleteId;
            [gObjAppDelegatePtr.m_cDbHandler updateLogTableAthleteID :m_cObjAthletePtr AthId:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
            requestisFor=-1;// sougata added this on 16 aug.
            
            if(m_cObjAthleteImagesListPtr.count > 0)
            {
                [self uploadOnlyPendingImage];
                 requestisFor=-1;// sougata added this on 16 aug.
            }
            if (m_cUploadCount > 0 ) 
            {
                //self performSelector:@selector(uploadAthleteData) withObject:nil afterDelay:<#(NSTimeInterval)#>
                [self uploadAthleteData];
                
            }
           
            if (m_cObjLogArrayPtr.count > 0) 
            {
                [self uploadLogData];
            }
            
            else
           {
                 [m_cObjAtthleteListPtr removeAllObjects];
#if 0
              
                UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
                lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                              message:@"Update to server is successful" 
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                [lObjAlertviewPtr show];
                SAFE_RELEASE(lObjAlertviewPtr)
#endif
            }

            //end
        }
    

        if (requestisFor == updateAthlet )
        {
            BOOL lRetVal = NO;
            //[gObjAppDelegatePtr stopProgressHandler];//sougata added this
            m_cObjAthletePtr.m_cAthleteId = gObjAppDelegatePtr.m_cAthleteId;
            lRetVal = [gObjAppDelegatePtr.m_cDbHandler updateAthleteID :m_cObjAthletePtr  AthId:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
            if (lRetVal)
            {
                [gObjAppDelegatePtr.m_cDbHandler updateLogTableAthleteID :m_cObjAthletePtr AthId:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
                requestisFor=-1;// sougata added this on 14 aug.
            }

            if(m_cObjAthleteImagesListPtr.count > 0)
            {
                [self uploadOnlyPendingImage];
                requestisFor=-1;// sougata added this on 16 aug.
            }
            if (m_cUploadCount > 0 ) 
            {
                [self uploadAthleteData];
                
            }
            else
            {
                 [m_cObjAtthleteListPtr removeAllObjects];
#if 0
              
                UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
                lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                                              message:@"Update to server is successful" 
                                                              delegate:nil cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil];
                [lObjAlertviewPtr show];
                SAFE_RELEASE(lObjAlertviewPtr)
#endif
            }
        }
        if (requestisFor == Download)
        {
            
            requestisFor=-1;
           
            
            [gObjAppDelegatePtr.m_cObjTabBarControllerPtr setSelectedIndex:0];
            
            NSMutableArray *lObjArrayPtr = [[gObjAppDelegatePtr.m_cDbHandler getAllAthletes]retain];
            gObjAppDelegatePtr.m_cObjAthleteListPtr = lObjArrayPtr;
            NSInteger lCount=-1;
            lCount=gObjAppDelegatePtr.m_cObjAthleteListPtr.count;
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            if ( lCount== 0) 
            {
                lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                    
                                                              message:@"No athlete"
                                                             delegate:nil cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
            }
            else
            {
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" 
                                
                                                          message:@"Downloaded successfully" 
                                                         delegate:nil cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
            }
            //end
            lObjAlertviewPtr.tag=994;
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)

                m_cPreviusCombineId = m_cRowValue;
                

             [self combinenameChange];
        }
  }

        
  
    if (requestisFor == Uploadlog)
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        
        
        [gObjAppDelegatePtr.m_cDbHandler updateLogTableOfflineModeValue:m_cObjAthleteLogPtr.m_cObjAthleteIdPtr :m_cObjAthleteLogPtr.m_cObjTestId];
        requestisFor=-1;// sougata added this on 16 aug.
        if(m_cObjAthleteImagesListPtr.count > 0)
        {
            [self uploadOnlyPendingImage];
        }
        if (m_cUploadLogCount > 0 ) 
        {
            [self uploadLogData];
        }
        else
        {
#if 0
            [m_cObjLogArrayPtr removeAllObjects];
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Update to server is successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
#endif
        }

        
                    
        
    }
  if(requestisFor == UploadPendingImage)
    {
        [gObjAppDelegatePtr stopProgressHandler];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [m_cObjAthleteImagesListPtr removeObjectAtIndex:0];
        if (m_cObjAthleteImagesListPtr.count > 0)
            [self uploadOnlyPendingImage];
        //sougata added this on 16 aug
        else
        {
#if 0
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Update to server is successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
#endif
        }
        //end
    }
}

-(void)serverTransactionFailed
{
     [gObjAppDelegatePtr stopProgressHandler];
    
    //end
    if (requestisFor == Download)
    {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Download failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        lObjAlertViewPtr.tag=994;
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
        requestisFor=-1;//sougata added this on 14 aug
        
        [_m_cObjSettingsTableViewPtr reloadData];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
       // m_cObjUpdateRowValue=m_cRowValue;
        m_cRowValue = m_cPreviusCombineId;
        [self combinenameChange];
       // isCombineDownloadFailedServer=YES;
    }
     if (requestisFor == Upload || requestisFor == updateAthlet)
    {
       
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Upload Athlete Info failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
        requestisFor=-1;//sougata added this on 14 aug
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        
    }
    else if (requestisFor == Uploadlog)
    {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Upload Log Info failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    }
    else if (requestisFor == UploadPendingImage)
    {
            }
   // isCombineDownloadFailedServer=NO;
    
}
-(void)serverConnectionDidFailWithError
{
    [gObjAppDelegatePtr stopProgressHandler];//sougata added this on 16 aug
    if (requestisFor == Login)
    {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine"
                                    message:@"Upload Login Info failed"
                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
    else if (requestisFor == Upload || requestisFor == updateAthlet)
    {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Upload Athlete Info failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
    else if (requestisFor == Uploadlog)
    {
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Upload Log Info failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }    
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
    self.m_cObjCombineListPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allValues]] retain];
    gObjAppDelegatePtr.m_cObjCombineIDArrayPtr = [[NSMutableArray arrayWithArray:[lObjDictionaryPtr allKeys]] retain];
    if (self.m_cObjCombineListPtr .count>0)
    {
        gObjAppDelegatePtr.m_cObjCombineTitleStringPtr=[self.m_cObjCombineListPtr  objectAtIndex:0];
        NSString *lObjCmbnId =(NSString *)nil;
        lObjCmbnId = [gObjAppDelegatePtr.m_cObjCombineIDArrayPtr objectAtIndex:0];
        gObjAppDelegatePtr.m_cCMBNIDPtr = lObjCmbnId;
    }
    m_cObjCombineIdArrayPtr = gObjAppDelegatePtr.m_cObjCombineIDArrayPtr;
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;///do1
    [m_cObjCombinePickerViewPtr reloadAllComponents];
//    SAFE_RELEASE(lObjDictionaryPtr)
    [self downloadCombineTests];
    [_m_cObjSettingsTableViewPtr reloadData];
}
-(void)downloadCombineTests
{
    
    if (m_cObjCombineIdArrayPtr.count > 0)
    {
        [gObjAppDelegatePtr displayProgressHandler:@"Downloading Combine Tests"];
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
        {
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadCombineTests :[[m_cObjCombineIdArrayPtr objectAtIndex:0] integerValue]];
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
        {
            [gObjAppDelegatePtr stopProgressHandler];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        }
    }
}

-(void)handleCombineTestDownloadSucceed
{
    [m_cObjCombineIdArrayPtr removeObjectAtIndex:0];
    if (gObjAppDelegatePtr.m_cObjCombineIDArrayPtr.count > 0) {
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        [self downloadCombineTests];
    }
    else
    {
        [gObjAppDelegatePtr stopProgressHandler];
        //gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        
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
    [m_cObjCombineIdArrayPtr removeObjectAtIndex:0];
    if (m_cObjCombineIdArrayPtr.count > 0)
    {
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
        [self downloadCombineTests];
    }
    else
    {
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Combine Tests Download Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
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
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    gObjAppDelegatePtr.isForImageDownload = NO;
    gObjAppDelegatePtr.isImageFileDownloading = NO;
}

- (BOOL)showElemTypePicker
{
    BOOL lRetVal = NO;
 
    if (m_cObjCombinePickerViewPtr == nil)
    {
        lRetVal = YES;
        CGFloat lHeight= self.tabBarController.tabBar.frame.size.height+150;
//        m_cRowValue=0;
        // create a UIPicker view as a custom keyboard view
        m_cObjCombinePickerViewPtr = [[UIPickerView alloc] init];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            m_cObjCombinePickerViewPtr.frame = CGRectMake(0.0, self.view.frame.size.height-lHeight, 320.0, 150.0);
            NSLog(@"%f",self.tabBarController.tabBar.frame.size.height);
            NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
            NSLog(@"%f",self.view.frame.size.height);
            
        }
        else
        {
            
             m_cObjCombinePickerViewPtr.frame = CGRectMake(0.0, 205.0, 320.0, 70.0);
            
        }
       
       
        m_cObjCombinePickerViewPtr.delegate = self;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
             m_cObjCombinePickerViewPtr.backgroundColor=[UIColor whiteColor];
        }
       
        m_cObjCombinePickerViewPtr.dataSource = self;
        m_cObjCombinePickerViewPtr.showsSelectionIndicator = YES;

        [m_cObjCombinePickerViewPtr selectRow:0 inComponent:0 animated:YES];
        [self.view addSubview:m_cObjCombinePickerViewPtr];
        
        // Prepare done button
        keyboardDoneButtonView = [[UIToolbar alloc] init];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            keyboardDoneButtonView.frame = CGRectMake(0.0, self.view.frame.size.height-(lHeight+50), 320.0, 50.0);
        }
        else
        {
            keyboardDoneButtonView.frame = CGRectMake(0.0, 155, 320.0, 50.0);
            
        }
        
        keyboardDoneButtonView.barStyle = UIBarStyleBlack;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
//        keyboardDoneButtonView.hidden = YES;
        
        UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)] autorelease];
        UIBarButtonItem    *lObjCanCelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelCombinePickerButtonClicked)] autorelease];
        UIBarButtonItem *flexspaceButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton,flexspaceButton,lObjCanCelButton, nil]];
        [self.view addSubview:keyboardDoneButtonView];
    }
    else
    {
        keyboardDoneButtonView.hidden = NO;
        m_cObjCombinePickerViewPtr.hidden = NO;
    }
    return lRetVal;
}
-(void)combinenameChange
{
    m_CobjCombineSelectionTextPtr=(NSString *)nil;
    if (m_CobjCombineSelectionTextPtr==(NSString *)nil) 
    {
        m_CobjCombineSelectionTextPtr=[NSString stringWithFormat:@"%@",[self.m_cObjCombineListPtr objectAtIndex:m_cRowValue]];
        gObjAppDelegatePtr.m_cObjCombineTitleStringPtr=[NSString stringWithFormat:@"%@",m_CobjCombineSelectionTextPtr];
        
        
    }
    if (gObjAppDelegatePtr.m_cObjCombineIDArrayPtr.count > 0)
    {
        
        gObjAppDelegatePtr.m_cCMBNIDPtr = [m_cObjCombineIdArrayPtr objectAtIndex:m_cRowValue];
        NSLog(@"%@", gObjAppDelegatePtr.m_cCMBNIDPtr);
        
    }
    [_m_cObjSettingsTableViewPtr reloadData];

}
-(void)pickerDoneClicked:(id)sender
{
    keyboardDoneButtonView.hidden = YES;
    m_cObjCombinePickerViewPtr.hidden = YES;
     [self.m_cObjCombineIDsPtr removeAllObjects];
    

         [self combinenameChange];
        if (YES == [gObjAppDelegatePtr isNetworkAvailable])
        {
           
            [gObjAppDelegatePtr displayProgressHandler:@"Downloading List of Athletes"];
            requestisFor = Download;
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr];
             
        }
        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
        {
            UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
            lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Netwok connection not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [lObjAlertviewPtr show];
            SAFE_RELEASE(lObjAlertviewPtr)
    }
   

}
-(void)onCancelCombinePickerButtonClicked
{
    keyboardDoneButtonView.hidden = YES;
    m_cObjCombinePickerViewPtr.hidden = YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 996 || alertView.tag == 997 || alertView.tag == 998 || alertView.tag == 995) 
    {
        if (buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    if (alertView.tag == 994) 
   {
        if (buttonIndex == 0)
        {
           [_m_cObjSettingsTableViewPtr reloadData];
        }
    }

    if (alertView.tag == 999)
    {
        if (buttonIndex == 1)
        {
            m_cRowValue = 0;
            m_cPreviusCombineId=m_cRowValue;
            BOOL lRetVal = NO;
            NSArray *lObjDocumentDirsListPtr = (NSArray *)nil;
            NSString *lObjDocumentDirPathPtr = (NSString *)nil;
            NSString *lObjRootFolderPathPtr = (NSString *)nil;
            lRetVal = [gObjAppDelegatePtr.m_cDbHandler clearLocalDB];
            if (lRetVal)
            {
                [gObjAppDelegatePtr.m_cObjDictionaryPtr removeAllObjects];
                NSFileManager *lObjFileMangrPtr = [NSFileManager defaultManager];
                lObjDocumentDirsListPtr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                lObjDocumentDirPathPtr = [lObjDocumentDirsListPtr objectAtIndex:0];
                
                lObjRootFolderPathPtr = [lObjDocumentDirPathPtr stringByAppendingPathComponent:@"Photo"];
                lRetVal = [lObjFileMangrPtr removeItemAtPath:lObjRootFolderPathPtr error:nil];
            }
            gObjAppDelegatePtr.m_cCMBNIDPtr =(NSString *)nil;
            [HomeViewController  refreshHomeScreen];
            m_cRowValue = 0;
            gObjAppDelegatePtr.m_cCMBNIDPtr = (NSString *)nil;
            //SAFE_RELEASE(m_cObjCombinePickerViewPtr)
        }
    }
    else
    {
    if (NO == isUploadtoServer)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            BOOL lRetVal = NO;
            
            NSArray *lObjDocumentDirsListPtr = (NSArray *)nil;
            NSString *lObjDocumentDirPathPtr = (NSString *)nil;
            NSString *lObjRootFolderPathPtr = (NSString *)nil;
            lRetVal = [gObjAppDelegatePtr.m_cDbHandler clearLocalDB];
            m_cIsForDeleteLocalInformation=YES;
            
            if (lRetVal)
            {
                [gObjAppDelegatePtr.m_cObjDictionaryPtr removeAllObjects];
                NSFileManager *lObjFileMangrPtr = [NSFileManager defaultManager];
                lObjDocumentDirsListPtr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                lObjDocumentDirPathPtr = [lObjDocumentDirsListPtr objectAtIndex:0];
                
                lObjRootFolderPathPtr = [lObjDocumentDirPathPtr stringByAppendingPathComponent:@"Photo"];
                lRetVal = [lObjFileMangrPtr removeItemAtPath:lObjRootFolderPathPtr error:nil];
            }
            
            if (lRetVal)
            {
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Deleted Local Information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [lObjAlertViewPtr show];
                SAFE_RELEASE(lObjAlertViewPtr)
            }
            [self.m_cObjCombineListPtr removeAllObjects];
             [_m_cObjSettingsTableViewPtr reloadData];
            //gObjAppDelegatePtr.m_cObjCombineTitleStringPtr=nil;
        }
    }
    else if (YES  == isUploadtoServer)
    {
        if (requestisFor == Login)
        {
            if (m_cObjAtthleteListPtr.count > 0)
                [self uploadAthleteData];
            else  if(m_cObjLogArrayPtr.count > 0)
                [self uploadLogData];
        }
        else if (requestisFor == Upload || requestisFor == updateAthlet)
        {
            if (m_cObjAtthleteListPtr.count > 0)
            {
                
                [m_cObjAtthleteListPtr removeObjectAtIndex:0];
                [gObjAppDelegatePtr.m_cDbHandler deleteAthleteAddedInOfflinemode:gObjAppDelegatePtr.m_cObjTempAthleteIdPtr];
                [self uploadAthleteData];
                
            }
        }
        else if (requestisFor == Uploadlog)
        {
            if (m_cObjLogArrayPtr.count > 0)
            {
                [gObjAppDelegatePtr stopProgressHandler];
                gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
                UIAlertView *lObjAlertviewPtr = (UIAlertView *)nil;
                lObjAlertviewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Upload to server Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [lObjAlertviewPtr show];
                SAFE_RELEASE(lObjAlertviewPtr)
                
                
            }
        }
    }
    }
}
- (NSString *)languageDisplayNameForCode:(NSString*)pLangCode
{
    NSString *lLangDisName = nil;
    
    if(YES == [pLangCode isEqualToString:@"Production"])
    {
        lLangDisName = @"Production";
    }
    else if(YES == [pLangCode isEqualToString:@"Test"])
    {
        lLangDisName = @"Test";
    }
    
    return lLangDisName;
}
//picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==m_cObjCombinePickerViewPtr)
    {
        return 1;
    }
    else
    {
      return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==m_cObjCombinePickerViewPtr) 
    {
        return [self.m_cObjCombineListPtr count];
    }
    else
    {
      return [m_cObjSupportingServersPtr count];
    }
}
- (void)pickerView:(UIPickerView *)pickerview
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (pickerview==m_cObjCombinePickerViewPtr)
    {

        m_cRowValue = row;
         
        
        
    }
    
    else
    {
       // m_cObjPickerSelectionLablePtr.text=@"";
        m_cObjPickerSelectionLablePtr.text = (NSString *)[m_cObjSupportingServersPtr objectAtIndex:row];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerview titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerview==m_cObjCombinePickerViewPtr)
    {
        
        NSString	*lObjTitlePtr = (NSString *)nil;
       
        if((NSMutableArray *)nil != self.m_cObjCombineListPtr)
            lObjTitlePtr = [self.m_cObjCombineListPtr objectAtIndex:row];
        return lObjTitlePtr;
    }
    else
    {
      m_cObjPickerSelectionLablePtr.text=@"";
	  NSString	*lObjTitlePtr = (NSString *)nil;
      lObjTitlePtr = (NSString *)[m_cObjSupportingServersPtr objectAtIndex:row];
	  return      lObjTitlePtr;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerview rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}
-(void)dealloc
{
    [super dealloc];
    SAFE_RELEASE(m_cObjSupportingServersPtr)
    SAFE_RELEASE(m_cObjAthletePtr)
    SAFE_RELEASE(m_cObjAthleteLogPtr)
    SAFE_RELEASE(m_cObjLogArrayPtr)
    SAFE_RELEASE(m_cObjAtthleteListPtr)
    SAFE_RELEASE(m_cObjActionSheetPtr)
    SAFE_RELEASE(m_cObjToolBarPtr)
    SAFE_RELEASE(m_cObjAthleteImagesListPtr)
    SAFE_RELEASE(_m_cObjSettingsTableViewPtr)
    SAFE_RELEASE(m_cObjCombinePickerViewPtr)
    SAFE_RELEASE(m_cObjkeyboardDoneButtonViewPtr)
    SAFE_RELEASE(m_cObjPickerSelectionLablePtr)
    SAFE_RELEASE(m_CobjCombineSelectionTextPtr)
   
   
}







- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
