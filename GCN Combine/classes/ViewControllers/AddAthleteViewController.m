//
//  AddAthleteViewController.m
//  GCN Combine
//
//  Created by Debi Samantrai on 30/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AddAthleteViewController.h"
#import "Macros.h"
#import <QuartzCore/QuartzCore.h>
#import "AddAthleteTableViewCell.h"
#import "AddAthleteDetailsTableViewCell.h"
#import "AppDelegate.h"
#import "HttpHandler.h"

@implementation AddAthleteViewController
@synthesize m_cObjAthleteDetailsPtr;
@synthesize m_cObjURlPtr;
@synthesize m_cObjFolderPathPtr,m_cObjPickerViewPtr,m_cObjPickerToolBarPtr,m_cObjSportsListPtr,m_cObjSportNamePtr,m_cObjSegementCtrlPtr,m_cObjDOBPickerPtr,m_cObjDateArrayPtr,m_cObjYearArrayPtr,m_cObjMonthArrayPtr,m_cObjGenderPickerViewPtr,m_cGenderArrayPtr;
@synthesize m_cObjDayPtr,m_cObjMonthPtr,m_cObjYearPtr;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        m_cTotalNoOfRows=0;
        self.navigationController.navigationBar.hidden=NO;
        self.navigationItem.title = @"Add Athlete";
        self.hidesBottomBarWhenPushed =YES;
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
       m_cImagePickerControllerPtr = (UIImagePickerController *)nil;
       IsFirstNameValidationSuccess = YES;
        IsLastNameValidationSuccess = YES;
        IsEmailValidationSuccess = YES;
        m_cObjDayPtr = (NSString *)nil;
        m_cObjMonthPtr = (NSString *)nil;
        m_cObjYearPtr = (NSString *)nil;
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        IsTextView = NO;
 
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
    
    m_cApplicationSize = self.view.frame;
    CGRect              lScrollRect = CGRectZero;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lScrollRect = CGRectMake(CGRectGetMinY(self.view.bounds), 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64);
        NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
    }
    else
    {
        lScrollRect = CGRectMake(CGRectGetMinY(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    }
    m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:lScrollRect];
    m_cObjScrollViewPtr.scrollEnabled = YES;
    m_cObjScrollViewPtr.delegate = self;
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 550.0);
    m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
    [self.view addSubview:m_cObjScrollViewPtr];
        
    Athlete *lObjAthleteDetailsPtr = [[Athlete alloc]init];
    self.m_cObjAthleteDetailsPtr = lObjAthleteDetailsPtr;
    SAFE_RELEASE(lObjAthleteDetailsPtr)
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self createImageControls];
    [self createElements];
    [self createPickerControls];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)createElements
{
    UIBarButtonItem		*lObjSaveButtonPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjBackBtnPtr = (UIBarButtonItem *)nil;
	CGRect				lObjRect = CGRectZero;
    CGRect              lRect = CGRectZero;
      
    
	// create a Back button with custom title
	lObjSaveButtonPtr = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveButtonPressed:) ]; 
	self.navigationItem.rightBarButtonItem = lObjSaveButtonPtr;
    SAFE_RELEASE(lObjSaveButtonPtr)
    
    
    lObjBackBtnPtr = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackButtonPressed:)];
    self.navigationItem.leftBarButtonItem = lObjBackBtnPtr;
    SAFE_RELEASE(lObjBackBtnPtr)
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         lObjRect = CGRectMake(CGRectGetMaxX(m_cTakeImageButtonPtr.frame)+2, -75,CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(m_cTakeImageButtonPtr.frame)-5, 165);
    }
    else
    {
    lObjRect = CGRectMake(CGRectGetMaxX(m_cTakeImageButtonPtr.frame)+2, CGRectGetMinY(m_cTakeImageButtonPtr.frame) - 10,CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(m_cTakeImageButtonPtr.frame)-5, 160);
    }
    m_cObjUpperTableViewPtr = [[UITableView alloc] initWithFrame:lObjRect style:UITableViewStyleGrouped];
	m_cObjUpperTableViewPtr.backgroundColor = [UIColor clearColor];
    m_cObjUpperTableViewPtr.backgroundView = nil;
	m_cObjUpperTableViewPtr.delegate = self;
	m_cObjUpperTableViewPtr.dataSource = self;
	m_cObjUpperTableViewPtr.autoresizesSubviews = YES;
	m_cObjUpperTableViewPtr.scrollEnabled = NO;
	m_cObjUpperTableViewPtr.allowsSelectionDuringEditing = YES;
    m_cObjUpperTableViewPtr.alpha = 1.0;
    m_cObjUpperTableViewPtr.tag = ADDATHLETEUPPERTABLE;
    [m_cObjScrollViewPtr addSubview:m_cObjUpperTableViewPtr];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        lRect = CGRectMake(10.0, CGRectGetMaxY(m_cObjUpperTableViewPtr.frame)+10, 310.0, 480.0);
    }
    else
    {
       lRect = CGRectMake(10.0, 160.0, 310.0, 350.0);
    }
    
    m_cObjLowerTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];	
	m_cObjLowerTableViewPtr.backgroundColor = [UIColor clearColor];
    m_cObjLowerTableViewPtr.backgroundView = nil;
	m_cObjLowerTableViewPtr.delegate = self;
	m_cObjLowerTableViewPtr.dataSource = self;
	m_cObjLowerTableViewPtr.autoresizesSubviews = YES;
	m_cObjLowerTableViewPtr.scrollEnabled = NO;
	m_cObjLowerTableViewPtr.allowsSelectionDuringEditing = YES;
    m_cObjLowerTableViewPtr.alpha = 1.0;
    m_cObjLowerTableViewPtr.tag = ADDATHLETELOWERTABLE;
    [m_cObjScrollViewPtr addSubview:m_cObjLowerTableViewPtr];

}

-(void)createImageControls
{
    m_cTakeImageButtonPtr = [UIButton buttonWithType:UIButtonTypeCustom];
	m_cTakeImageButtonPtr.backgroundColor = [UIColor clearColor];
    m_cTakeImageButtonPtr.layer.cornerRadius = 4.0;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
         m_cTakeImageButtonPtr.frame = CGRectMake(10.0, -40,90, 91);
    }
    else
    {
        m_cTakeImageButtonPtr.frame = CGRectMake(10.0, 20,90, 91);
    }
    
    [m_cTakeImageButtonPtr addTarget:self action:@selector(onPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_cTakeImageButtonPtr setBackgroundImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
    [m_cObjScrollViewPtr addSubview:m_cTakeImageButtonPtr];
    
}

-(void)createPickerControls
{
    //UIPickerView        *lObjTempPickerPtr = (UIPickerView *)nil;
    UIBarButtonItem     *lObjDoneBtnPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjFlexBtnPtr = (UIBarButtonItem *)nil;
    UIBarButtonItem     *lObjSegBtnPtr = (UIBarButtonItem *)nil;
    
    
    //lObjTempPickerPtr = [[UIPickerView alloc] init];
    if (!self.m_cObjPickerViewPtr)
    {
       self.m_cObjPickerViewPtr = [[UIPickerView alloc] init];
    }
    
    //SAFE_RELEASE(lObjTempPickerPtr)
    [self.m_cObjPickerViewPtr sizeToFit];
    self.m_cObjPickerViewPtr.delegate = self;
    self.m_cObjPickerViewPtr.dataSource = self;
    self.m_cObjPickerViewPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjPickerViewPtr.showsSelectionIndicator = YES;
    self.m_cObjPickerViewPtr.tag = ATHLETEADDPICKERTAG;
    [self.m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    
    m_cObjPickerToolBarPtr = [[UIToolbar alloc] init];
    m_cObjPickerToolBarPtr.barStyle = UIBarStyleBlack;
    m_cObjPickerToolBarPtr.translucent = YES;
    m_cObjPickerToolBarPtr.tintColor = nil;
    [m_cObjPickerToolBarPtr sizeToFit];
    
    m_cObjSegementCtrlPtr = [[UISegmentedControl alloc]initWithItems:
                             [NSArray arrayWithObjects:@"Previous",@"Next", nil]];
    m_cObjSegementCtrlPtr.segmentedControlStyle = UISegmentedControlStyleBar;
    m_cObjSegementCtrlPtr.selectedSegmentIndex = -1;
    m_cObjSegementCtrlPtr.momentary = YES;
    [m_cObjSegementCtrlPtr addTarget:self action:@selector(onSegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
    
     lObjSegBtnPtr = [[UIBarButtonItem alloc]initWithCustomView:m_cObjSegementCtrlPtr];
    
    lObjDoneBtnPtr = [[UIBarButtonItem alloc] initWithTitle:
                        @"Done"style:UIBarButtonItemStyleBordered target:self                                                      action:@selector(onPickerDoneBtnClicked:)];
    
    lObjFlexBtnPtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:  
                      UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [m_cObjPickerToolBarPtr setItems:[NSArray arrayWithObjects:lObjSegBtnPtr,lObjFlexBtnPtr,lObjDoneBtnPtr, nil]];
    SAFE_RELEASE(lObjDoneBtnPtr)
    SAFE_RELEASE(lObjFlexBtnPtr)
    SAFE_RELEASE(lObjSegBtnPtr)
    
//    lObjTempPickerPtr = [[UIPickerView alloc]init];
    if (!self.m_cObjDOBPickerPtr)
    {
        self.m_cObjDOBPickerPtr = [[UIPickerView alloc]init];
    }
//    SAFE_RELEASE(lObjTempPickerPtr)
    
    [self.m_cObjDOBPickerPtr sizeToFit];
    self.m_cObjDOBPickerPtr.delegate = self;
    self.m_cObjDOBPickerPtr.dataSource = self;
    self.m_cObjDOBPickerPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjDOBPickerPtr.showsSelectionIndicator = YES;
    self.m_cObjDOBPickerPtr.tag = ATHLETEADDDOBPICKERTAG;
    

    

    //lObjTempPickerPtr = [[UIPickerView alloc]init];
    if (!self.m_cObjGenderPickerViewPtr)
    {
         self.m_cObjGenderPickerViewPtr = [[UIPickerView alloc]init];
    }
   
   //SAFE_RELEASE(lObjTempPickerPtr)
    
    [self.m_cObjGenderPickerViewPtr sizeToFit];
    self.m_cObjGenderPickerViewPtr.delegate = self;
    self.m_cObjGenderPickerViewPtr.dataSource = self;
    self.m_cObjGenderPickerViewPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjGenderPickerViewPtr.showsSelectionIndicator = YES;
    self.m_cObjGenderPickerViewPtr.tag = ATHLETE_GENDER_PICKERVIEW_TAG;
}
-(void)adjustScrollView
{
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0,((m_cTotalNoOfRows+4) * 52)+35);
    m_cTotalNoOfRows = 0;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //set the Image data into folder 9-1-13
    gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
    gObjAppDelegatePtr.IsAthleteDetailsUploadedSuccessfully = NO;
   
    //Register For Keyboard Notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
    
}

-(void)serverTransactionSucceeded
{
    NSString    *lObjMsgString = (NSString *)nil;
   if([gObjAppDelegatePtr isNetworkAvailable])
    {
        lObjMsgString = @"The Athlete has been successfully added";
    }
    else
    {
        lObjMsgString = @"Data stored for sync";
    }
  gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
   UIAlertView *lObjAlertViewPtr;
//    if ((UIImage *)nil != m_cObjImagePtr) 
//    {
//        [self saveIntoDocs];
//    }
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"Athlete Logger"
                        message:lObjMsgString
                        delegate:self
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil,
                        nil];
    lObjAlertViewPtr.tag = 400;
    [lObjAlertViewPtr show];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    SAFE_RELEASE(lObjAlertViewPtr)

}
-(void)serverTransactionFailed
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    if (YES == gObjAppDelegatePtr.isConnectionTimeout) {
        gObjAppDelegatePtr.isConnectionTimeout = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        m_cObjAthleteDetailsPtr.m_cIsAddedinOfflineMode = YES;
        
        //narasimhaiah added to get the current data in string format 14-2-13 - start
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        dateString = [formatter stringFromDate:[NSDate date]];
        
        [formatter release];
        //narasimhaiah added to get the current data in string format 14-2-13 - end
        
        
        gObjAppDelegatePtr.m_cObjHttpHandlerPtr.m_cObjAthletePtr.m_cAthleteId = [NSString stringWithFormat:@"ABCSFTXYZ_%@",dateString];

        
        gObjAppDelegatePtr.m_cObjHttpHandlerPtr.m_cObjAthletePtr = m_cObjAthleteDetailsPtr;
        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr handleUpload];
    }
    else{
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"The Athlete could not be successfully added"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        lObjAlertViewPtr.tag = 401;
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}

#pragma mark - Keyboard Notifications
- (void)keyBoardWillShow:(NSNotification *)pObjNotificationPtr
{
    if (m_cObjActiveTextFieldPtr.tag == ATHLETEFIRSTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG  )
    {
        CGFloat lOffset;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
              lOffset = -63;
        }
        else
        {
              lOffset = 0;
        }
       
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:NO];
        [UIView commitAnimations];
        
    }
    
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
    {
        CGFloat lOffset = 75.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
    }
     else if(m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG)
     {
         
         CGFloat lOffset = 130.0;
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         m_cObjLowerTableViewPtr.contentInset = contentInsets;
         m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
         CGPoint scrollPoint = CGPointMake(0.0, lOffset);
         m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.1];
         [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
         [UIView commitAnimations];
         
     }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
    {

        CGFloat lOffset = 210.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];

    }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
    {
        CGFloat lOffset = 290.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];

    }
    else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
    {
        CGFloat lOffset = 370.0;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 790);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
        
    }



    
}

- (void)keyBoardWillHide : (NSNotification *)pObjNotificationPtr
{
    if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG || m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG ||m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG || m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEFIRSTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG || m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG || m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
    {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsZero;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
        CGRect lRect = m_cObjLowerTableViewPtr.frame;
        lRect.size.height = 400;
        m_cObjLowerTableViewPtr.frame = lRect;
        [UIView commitAnimations];
    }

    
}
-(void)onSaveButtonPressed : (id)sender
{
    UITextField *lObjTextField = (UITextField *)nil;
    BOOL lRetval = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {

    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 550);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
        
        CGRect lRect = m_cObjLowerTableViewPtr.frame;
        lRect.size.height = 350;
        m_cObjLowerTableViewPtr.frame = lRect;
        m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsZero;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
    

          
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
    [self validateFields:lObjTextField];
    lObjTextField = (UITextField *)nil;
    
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
    [self validateFields:lObjTextField];
    lObjTextField = (UITextField *)nil;
    
    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
    if([lObjTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
    {
    lRetval = [self validateEmail:lObjTextField.text];
    }
    else
    {
        lRetval = NO;
    }
    lObjTextField = (UITextField *)nil;
    
    if(IsFirstNameValidationSuccess == YES && IsLastNameValidationSuccess == YES && lRetval == YES)
    {
         IsEmailValidationSuccess = YES;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
        m_cObjAthleteDetailsPtr.m_cObjFirstNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
        m_cObjAthleteDetailsPtr.m_cObjLastNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;

        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
        m_cObjAthleteDetailsPtr.m_cObjNickNamePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        m_cObjAthleteDetailsPtr.m_cObjSportsPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
        m_cObjAthleteDetailsPtr.m_cObjEmailIdPtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];//sougata added this on 17/12/13
       if ([lObjTextField.text isEqualToString:@"Male"])
        {
             m_cObjAthleteDetailsPtr.m_cObjGenderPtr=@"M";
        }
        else
        {
             m_cObjAthleteDetailsPtr.m_cObjGenderPtr = @"F";
        }
        lObjTextField = (UITextField *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
        // added this as per narayan's report to add default password,if password is nil
        if( 0 >= [lObjTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            m_cObjAthleteDetailsPtr.m_cObjPasswordPtr = @"tempPWD";
        }
        else
        {
        m_cObjAthleteDetailsPtr.m_cObjPasswordPtr = lObjTextField.text;
        }
        lObjTextField = (UITextField *)nil;
        
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
        m_cObjAthleteDetailsPtr.m_cObjBirthDatePtr = lObjTextField.text;
        lObjTextField = (UITextField *)nil;
        
        
        m_cObjAthleteDetailsPtr.m_cPhotoNamePtr = @"";
        //Save Image into Docs Using Some random number 25-2-13 - end
        
        m_cObjAthleteDetailsPtr.isFavouriteAthlete = 0;
 
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        gObjAppDelegatePtr.m_cSignInAttemptCount +=1;
        if (YES ==[gObjAppDelegatePtr isNetworkAvailable])
        {
            [self.view endEditing:YES];
            [gObjAppDelegatePtr displayProgressHandler:@"Sending Athlete Information to server"];
            gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadRequest :m_cObjAthleteDetailsPtr isNewAthlete:YES];
        }
        else 
        {
            
                m_cObjAthleteDetailsPtr.m_cIsAddedinOfflineMode = YES;
                gObjAppDelegatePtr.m_cObjHttpHandlerPtr.m_cObjAthletePtr = m_cObjAthleteDetailsPtr;
            
                //narasimhaiah added to get the current data in string format 14-2-13 - start
                NSDateFormatter *formatter;
                NSString        *dateString;
                
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                
                dateString = [formatter stringFromDate:[NSDate date]];
            
                [formatter release];
                //narasimhaiah added to get the current data in string format 14-2-13 - end
            
            
                gObjAppDelegatePtr.m_cObjHttpHandlerPtr.m_cObjAthletePtr.m_cAthleteId = [NSString stringWithFormat:@"ABCSFTXYZ_%@",dateString];
                [gObjAppDelegatePtr.m_cObjHttpHandlerPtr handleUpload];
           

        }

    }
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == NO && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == NO && lRetval == YES)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    
    else if(IsFirstNameValidationSuccess == NO && IsLastNameValidationSuccess == YES && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    
    else if(IsFirstNameValidationSuccess == YES && IsLastNameValidationSuccess == NO && lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    
   else if(IsFirstNameValidationSuccess == NO)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];

    }
    else if(IsLastNameValidationSuccess == NO)
    {
        IsEmailValidationSuccess = YES;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    else if(lRetval == NO)
    {
        IsEmailValidationSuccess = NO;
        [m_cObjUpperTableViewPtr reloadData];
        [m_cObjLowerTableViewPtr reloadData];
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 400 || alertView.tag == 401)
    [self onBackButtonPressed:nil];
}

-(void)onBackButtonPressed : (id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onPhotoButtonPressed : (id)sender
{

    if(nil != m_cObjImagePtr)
    {
        UIActionSheet *lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",@"Delete Photo", nil];
        lObjActionSheetPtr.tag = 10;
        
        [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar];
        SAFE_RELEASE(lObjActionSheetPtr)
    }
    else
    {
        UIActionSheet *lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
        lObjActionSheetPtr.tag = 10;
        [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar];
        SAFE_RELEASE(lObjActionSheetPtr)
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((UIImagePickerController *)nil == m_cImagePickerControllerPtr)
    {
        m_cImagePickerControllerPtr = [[UIImagePickerController alloc] init];
        m_cImagePickerControllerPtr.delegate = self;
        m_cImagePickerControllerPtr.allowsEditing = YES;
    }
    
    if(actionSheet.tag == 10)
    {
        switch(buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    m_cImagePickerControllerPtr.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:m_cImagePickerControllerPtr animated:YES];
                }
                break;
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    m_cImagePickerControllerPtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:m_cImagePickerControllerPtr animated:YES];
                }
                break;
            case 2:
                if(nil != m_cObjImagePtr)
                {
                    UIActionSheet *lObjActionSheetPtr = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:nil, nil];
                    lObjActionSheetPtr.tag = 11;
                    [lObjActionSheetPtr showFromTabBar:gObjAppDelegatePtr.m_cObjTabBarControllerPtr.tabBar];
                    SAFE_RELEASE(lObjActionSheetPtr)
                }
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag == 11)
    {
        if(buttonIndex == 0)
        {
            [m_cTakeImageButtonPtr setImage:nil forState:UIControlStateNormal];
            m_cObjImagePtr = (UIImage *) nil;
            gObjAppDelegatePtr.m_cObjImageDatePtr = (NSData *)nil;
            [m_cTakeImageButtonPtr setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
        }
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *lObjImage = [info objectForKey:UIImagePickerControllerEditedImage];
  
   m_cTakeImageButtonPtr.imageView.frame =CGRectMake(m_cTakeImageButtonPtr.bounds.origin.x+5, m_cTakeImageButtonPtr.bounds.origin.y+5, m_cTakeImageButtonPtr.frame.size.width-10, m_cTakeImageButtonPtr.frame.size.height-30); 
    [m_cTakeImageButtonPtr setImage:lObjImage forState:UIControlStateNormal]; 
    m_cTakeImageButtonPtr.imageView.clipsToBounds = YES;
    m_cTakeImageButtonPtr.imageView.layer.cornerRadius = 4.0;
    m_cTakeImageButtonPtr.imageView.layer.borderWidth = 2.0;
    m_cTakeImageButtonPtr.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    [m_cTakeImageButtonPtr setTintColor:[UIColor clearColor]];
    
    [self dismissModalViewControllerAnimated:YES];
    m_cObjImagePtr = lObjImage;
    gObjAppDelegatePtr.m_cObjImageDatePtr = UIImagePNGRepresentation(m_cObjImagePtr);
//    gObjAppDelegatePtr.m_cObjImageDatePtr = UIImageJPEGRepresentation(m_cObjImagePtr, 0.0);

} 
-(void)saveIntoDocs
{
    if ((UIImage *)nil != m_cObjImagePtr)
    {
        m_cObjFolderPathPtr =  [gObjAppDelegatePtr createPhotoFolders:m_cObjAthleteDetailsPtr.m_cAthleteId];
        [self savePhoto:m_cObjFolderPathPtr];
    }
}

#pragma mark - Video File Saving Delegate Methods
- (void)savePhoto:(NSString *)pObjPhotoUrlPtr
{
  if ((UIImage *)nil !=m_cObjImagePtr) {
  
      NSString *imagePath = [m_cObjFolderPathPtr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.m_cObjAthleteDetailsPtr.m_cAthleteId]];
      gObjAppDelegatePtr.m_cObjphotonamePtr = imagePath;

    
      if ((NSString *)nil != gObjAppDelegatePtr.m_cObjphotonamePtr) {
          self.m_cObjAthleteDetailsPtr.m_cPhotoNamePtr =[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent];
      }
      else if( YES == [[gObjAppDelegatePtr.m_cObjphotonamePtr lastPathComponent] isEqualToString:@"Athlete--1.jpg"] )
      {
          self.m_cObjAthleteDetailsPtr.m_cPhotoNamePtr = @"";
      }
     
      
      //extracting image from the picker and saving it
      NSData *webData = UIImagePNGRepresentation(m_cObjImagePtr);
//      NSData *webData = UIImageJPEGRepresentation(m_cObjImagePtr, 0.0);
      [webData writeToFile:imagePath atomically:YES];
    
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRow = -1;
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
        lRow =  3;
        m_cTotalNoOfRows=m_cTotalNoOfRows+lRow;
    }
    else if(tableView.tag == ADDATHLETELOWERTABLE)
    {

            lRow = 1;
        m_cTotalNoOfRows=m_cTotalNoOfRows+lRow;
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
        lSection = 5;
    }
    return lSection;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *lObjErrorImageViewPtr = (UIImageView *)nil; 
    if(tableView.tag == ADDATHLETEUPPERTABLE)
    {
    static NSString		*lObjCellIdentifierPtr = @"AddAthleteUpperDetailCell";
	AddAthleteTableViewCell		*lObjCustomCellPtr = (AddAthleteTableViewCell *)nil;
	
	lObjCustomCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];	
	if((AddAthleteTableViewCell *)nil == lObjCustomCellPtr)
    {
		lObjCustomCellPtr = [[[AddAthleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
    }
        lObjCustomCellPtr.accessoryView = (UIView *)nil;
       
    switch (indexPath.row)
    {
        case 0:
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"First Name";
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETEFIRSTNAMETAG;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
            if(IsFirstNameValidationSuccess == NO)
            {
            lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
            lObjCustomCellPtr.accessoryView = lObjErrorImageViewPtr;
            SAFE_RELEASE(lObjErrorImageViewPtr)
            }
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
            break;
        case 1:
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"Last Name";
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETELASTNAMETAG;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
            if(IsLastNameValidationSuccess == NO)
            {
            lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
            lObjCustomCellPtr.accessoryView = lObjErrorImageViewPtr;
            SAFE_RELEASE(lObjErrorImageViewPtr)
            }
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
            break;
        case 2:
            
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.placeholder = @"Email";
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.tag = ATHLETEEMAILTAG;
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.delegate = self;
            if(IsEmailValidationSuccess == NO)
            {
                lObjErrorImageViewPtr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ErrorArrow.png"]];
                lObjCustomCellPtr.accessoryView = lObjErrorImageViewPtr;
                SAFE_RELEASE(lObjErrorImageViewPtr)
            }
            lObjCustomCellPtr.m_cObjAthleteDetailTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
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
        lObjCellPtr.accessoryView = (UIView *)nil;
        lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentCenter;
        switch (indexPath.section)
        {
            case 0:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Password";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeEmailAddress;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Password";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEEMAILPASSWORDTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.returnKeyType = UIReturnKeyNext;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.secureTextEntry = YES;
                break;
            
            case 1:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"NickName";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDefault;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"NickName";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETENICKNAMETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                break;
                
            case 2:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Date Of Birth";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Date Of Birth";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEAGETAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjDOBPickerPtr;
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                                
                break;
            case 3:
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Gender";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Gender";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETE_GENDER_TAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                //lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjGenderPickerViewPtr;
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentCenter;
                
                break;
                
                
            case 4:

                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Sports";
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Sports List";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPORTSTAG;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = self.m_cObjPickerViewPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjPickerToolBarPtr;
                              
                 break;
            default:
                break;
        }
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else
        return nil;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_cObjActiveTextFieldPtr = textField;
    int  lSelectIndexForYr;
    if(textField.tag == ATHLETESPORTSTAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"General",@"Baseball",@"Basketball",@"Football",@"Lacrosse",@"Volleyball", nil];
        self.m_cObjSportsListPtr = lObjArrayPtr;
        [self.m_cObjPickerViewPtr reloadAllComponents];
        textField.inputView = self.m_cObjPickerViewPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
    }
    if(textField.tag == ATHLETESPORTSTAG)
    {
    if(textField.text.length <= 0)
    {
        textField.text = [self.m_cObjSportsListPtr objectAtIndex:0];
        [self.m_cObjPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        for(int i = 0 ; i<self.m_cObjSportsListPtr.count ; i++)
        {
            if([textField.text isEqualToString:[self.m_cObjSportsListPtr objectAtIndex:i]])
            {
                [self.m_cObjPickerViewPtr selectRow:i inComponent:0 animated:NO];
            }
        }
    }
    }
    if(textField.tag == ATHLETESPORTSTAG)
    {
        self.m_cObjSportNamePtr = textField.text;
    }
    if(textField.tag == ATHLETE_GENDER_TAG)
    {
        NSArray *lObjArrayPtr = [NSArray arrayWithObjects:@"Male",@"Female", nil];
        self.m_cGenderArrayPtr = lObjArrayPtr;
        [self.m_cObjGenderPickerViewPtr reloadAllComponents];
        textField.inputView = self.m_cObjGenderPickerViewPtr;
        textField.inputAccessoryView = m_cObjPickerToolBarPtr;
        textField.text = [self.m_cGenderArrayPtr objectAtIndex:0];
         [self.m_cObjGenderPickerViewPtr selectRow:0 inComponent:0 animated:YES];
    }
    if(textField.tag == ATHLETEAGETAG)
    {
        if ((NSMutableArray *)nil == m_cObjDateArrayPtr)
            m_cObjDateArrayPtr = [[NSMutableArray alloc]init];
        if ((NSMutableArray *)nil == m_cObjMonthArrayPtr)
            m_cObjMonthArrayPtr = [[NSMutableArray alloc]init];
        if ((NSMutableArray *)nil == m_cObjYearArrayPtr)
            m_cObjYearArrayPtr = [[NSMutableArray alloc]init];

        for(int i = 1; i<=31 ;i++)
        {
            if(i<=9)
            {
            [self.m_cObjDateArrayPtr addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
            [self.m_cObjDateArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
         int lCount=0;
        for(int i = 1930 ; i<=2014 ; i++)
        {
           
            if (i==2000)
            {
                lSelectIndexForYr = lCount;
            }
            lCount++;
            
            [self.m_cObjYearArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
           
            
        }
       
        for(int i = 1 ; i <=12 ; i++)
        {
            if(i<=9)
            {
                [self.m_cObjMonthArrayPtr addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else
            {
                [self.m_cObjMonthArrayPtr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
       
        
        if(textField.text.length <= 0)
        {
            NSString *lObjDateTextPtr = [NSString stringWithFormat:@"%@/%@/%@",[m_cObjMonthArrayPtr objectAtIndex:0],[m_cObjDateArrayPtr objectAtIndex:0],[m_cObjYearArrayPtr objectAtIndex:lSelectIndexForYr]];
            textField.text =lObjDateTextPtr;
            self.m_cObjDayPtr = [m_cObjDateArrayPtr objectAtIndex:0];
            self.m_cObjMonthPtr = [m_cObjDateArrayPtr objectAtIndex:0];
            self.m_cObjYearPtr = [m_cObjYearArrayPtr objectAtIndex:lSelectIndexForYr];
//            [self.m_cObjDOBPickerPtr reloadAllComponents];
            textField.inputView = m_cObjDOBPickerPtr;
            textField.inputAccessoryView = m_cObjPickerToolBarPtr;

            [self.m_cObjDOBPickerPtr selectRow:0 inComponent:0 animated:YES];
            [self.m_cObjDOBPickerPtr selectRow:0 inComponent:1 animated:YES];
            [self.m_cObjDOBPickerPtr selectRow:lSelectIndexForYr inComponent:2 animated:YES];
            //SAFE_RELEASE(lNow)
        }

    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *lObjTextFieldPtr = (UITextField *)nil;
    if(textField.tag == ATHLETEFIRSTNAMETAG)
    {
    
    [textField resignFirstResponder];
    lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
    [lObjTextFieldPtr becomeFirstResponder];
    lObjTextFieldPtr = (UITextField *)nil;
        
    }
    else if(textField.tag == ATHLETELASTNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
      }
    else if(textField.tag == ATHLETEEMAILTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
   else if(textField.tag == ATHLETEEMAILPASSWORDTAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;

    }
    else if(textField.tag == ATHLETENICKNAMETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETEAGETAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }
    else if(textField.tag == ATHLETE_GENDER_TAG)
    {
        [textField resignFirstResponder];
        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
        [lObjTextFieldPtr becomeFirstResponder];
        lObjTextFieldPtr = (UITextField *)nil;
    }

           
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
       
    if(textField.tag == ATHLETEFIRSTNAMETAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag != ATHLETEFIRSTNAMETAG && textField.tag != ATHLETESPORTSTAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETESPORTSTAG)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:1];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)onSegmentBtnClicked : (id)sender
{
    UISegmentedControl *lObjSegCtrlPtr = (UISegmentedControl *)nil;
    lObjSegCtrlPtr = (UISegmentedControl *)sender;
    UITextField *lObjTextField = (UITextField *)nil;
    
    switch (lObjSegCtrlPtr.selectedSegmentIndex) 
    {
        case 0:
            if(m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                [m_cObjScrollViewPtr scrollRectToVisible:m_cObjUpperTableViewPtr.frame animated:YES];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEFIRSTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPORTSTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            break;
        case 1:
            
            if(m_cObjActiveTextFieldPtr.tag == ATHLETEFIRSTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETELASTNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETELASTNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEEMAILPASSWORDTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEEMAILPASSWORDTAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETENICKNAMETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETENICKNAMETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEAGETAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEAGETAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETE_GENDER_TAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETE_GENDER_TAG)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPORTSTAG];
                [lObjTextField becomeFirstResponder];
                lObjTextField = (UITextField *)nil;
            }

            break;
        default:
            break;
    }
}

-(BOOL)validateEmail:(NSString *)pEmailText
{
    BOOL lRetval = YES;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    lRetval = [emailTest evaluateWithObject:pEmailText];
    return lRetval;
}
-(void)validateFields:(UITextField *)pObjTextFieldPtr
{
    NSString *lObjStrPtr = (NSString *)nil;
    lObjStrPtr = [pObjTextFieldPtr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(pObjTextFieldPtr.tag == ATHLETEFIRSTNAMETAG)
    {
    if(0 >= lObjStrPtr.length)
    {
        IsFirstNameValidationSuccess = NO;
    }
        else
        IsFirstNameValidationSuccess = YES;
    }
    else if(pObjTextFieldPtr.tag == ATHLETELASTNAMETAG)
    {
    if(0 >= lObjStrPtr.length)
    {
         IsLastNameValidationSuccess = NO;
    }
        else
            IsLastNameValidationSuccess = YES;
    }
}




-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger lRow = -1;
    if(pickerView.tag == ATHLETE_GENDER_PICKERVIEW_TAG)
    {
        lRow = [self.m_cGenderArrayPtr count];
    }
    
    if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
    lRow = [m_cObjSportsListPtr count];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            lRow = [self.m_cObjMonthArrayPtr count];
        }
        else if(component == 1)
        {
            lRow = [self.m_cObjDateArrayPtr count];
        }
        else if(component == 2)
        {
            lRow = [self.m_cObjYearArrayPtr count];
        }
    }
    return lRow;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger lComponents = -1;
    if(pickerView.tag == ATHLETE_GENDER_PICKERVIEW_TAG)
    {
        lComponents = 1;
    }
    if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
        lComponents = 1;
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        lComponents = 3;
    }
    return lComponents;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *lObjTitlePtr = (NSString *)nil;
    if(pickerView.tag == ATHLETE_GENDER_PICKERVIEW_TAG)
    {
        lObjTitlePtr = [self.m_cGenderArrayPtr objectAtIndex:row];
    }
    if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
    lObjTitlePtr = [m_cObjSportsListPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            lObjTitlePtr = [self.m_cObjMonthArrayPtr objectAtIndex:row];
        }
        else if(component == 1)
        {
            lObjTitlePtr = [self.m_cObjDateArrayPtr objectAtIndex:row];
        }
        else if(component == 2)
        {
            lObjTitlePtr = [self.m_cObjYearArrayPtr objectAtIndex:row];
        }
    }
    return lObjTitlePtr;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == ATHLETE_GENDER_PICKERVIEW_TAG)
    {
        m_cObjActiveTextFieldPtr.text = [self.m_cGenderArrayPtr objectAtIndex:row];
    }
    if(pickerView.tag == ATHLETEADDPICKERTAG)
    {
    m_cObjActiveTextFieldPtr.text = [self.m_cObjSportsListPtr objectAtIndex:row];
    }
    else if(pickerView.tag == ATHLETEADDDOBPICKERTAG)
    {
        if(component == 0)
        {
            self.m_cObjMonthPtr = [self.m_cObjMonthArrayPtr objectAtIndex:row];
        }
        else if(component == 1)
        {
            self.m_cObjDayPtr = [self.m_cObjDateArrayPtr objectAtIndex:row];
        }
        else if(component == 2)
        {
            self.m_cObjYearPtr = [self.m_cObjYearArrayPtr objectAtIndex:row];
        }
        m_cObjActiveTextFieldPtr.text = [NSString stringWithFormat:@"%@/%@/%@",self.m_cObjMonthPtr,self.m_cObjDayPtr,self.m_cObjYearPtr];
    }
}

-(void)onPickerDoneBtnClicked : (id)sender
{
    if(m_cObjActiveTextFieldPtr != (UITextField *)nil)
    {
    [m_cObjActiveTextFieldPtr resignFirstResponder];
    }

    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        CGFloat lOffset;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            lOffset = -63;
        }
        else
        {
            lOffset = 0;
        }
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        m_cObjLowerTableViewPtr.contentInset = contentInsets;
        m_cObjLowerTableViewPtr.scrollIndicatorInsets = contentInsets;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 550);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 550);
    m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
    
    CGRect lRect = m_cObjLowerTableViewPtr.frame;
    lRect.size.height = 350;
    m_cObjLowerTableViewPtr.frame = lRect;
    m_cObjLowerTableViewPtr.contentInset = UIEdgeInsetsZero;
    m_cObjLowerTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    }
    
}


-(void)dealloc
{
    
    SAFE_RELEASE(m_cObjUpperTableViewPtr)
    SAFE_RELEASE(m_cObjLowerTableViewPtr)
    SAFE_RELEASE(m_cObjScrollViewPtr)
    SAFE_RELEASE(m_cImagePickerControllerPtr)
    SAFE_RELEASE(m_cObjAthleteDetailsPtr)
    SAFE_RELEASE(m_cObjPickerViewPtr)
    SAFE_RELEASE(m_cObjPickerToolBarPtr)
    SAFE_RELEASE(m_cObjSportsListPtr)
    SAFE_RELEASE(m_cObjSportNamePtr)
    SAFE_RELEASE(m_cObjSegementCtrlPtr)
    SAFE_RELEASE(m_cObjDOBPickerPtr)
    SAFE_RELEASE(m_cObjYearArrayPtr)
    SAFE_RELEASE(m_cObjMonthArrayPtr)
    SAFE_RELEASE(m_cObjDateArrayPtr)
    SAFE_RELEASE(m_cObjYearPtr)
    SAFE_RELEASE(m_cObjDayPtr)
    SAFE_RELEASE(m_cObjMonthPtr)
    SAFE_RELEASE(m_cObjGenderPickerViewPtr)
    SAFE_RELEASE(m_cGenderArrayPtr)
    [super dealloc];
}

@end
