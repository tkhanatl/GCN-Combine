//
//  ViewController.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Macros.h"
#import "UserInfo.h"


@implementation LoginViewController
@synthesize m_cObjPasswordTextFieldPtr,m_cObjUserIDTextFieldPtr,lObjSignInButtonPtr;

-(id)init
{
    self =[super init];
    
     if (self)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"screen320x480", @"")]];
        self.navigationItem.title = NSLocalizedString(@"GCN", @"");
        gObjAppDelegatePtr.m_cSignInAttemptCount = 0;
        lObjSignInButtonPtr=(UIBarButtonItem *)nil;
        
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    //Sougata added 18/7/13
    lObjSignInButtonPtr = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(OnSignInBtnClicked)];
    self.navigationItem.rightBarButtonItem = lObjSignInButtonPtr;
    SAFE_RELEASE(lObjSignInButtonPtr)
    //[lObjSignInButtonPtr release];
    [self createLoginFields];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    m_cObjUserIDTextFieldPtr.text = @"s@gmail.com";
//    m_cObjPasswordTextFieldPtr.text = @"1";

    
    [m_cObjUserIDTextFieldPtr becomeFirstResponder];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
#pragma mark - Create Login Fields
- (void)createLoginFields
{
    CGRect      lRect = {0};
    UILabel     *lObjUserIDLblPtr = (UILabel *)nil;
    UILabel     *lObjPassWdLblPtr = (UILabel *)nil;
    NSString    *lObjStringPtr = (NSString *)nil;
    CGSize      lSize = {0};
    float lOriginY = 0.0;
    
    
    //user id label
    lObjStringPtr = NSLocalizedString(@"UserID", @"");
    lSize = [lObjStringPtr sizeWithFont:[UIFont systemFontOfSize:17.0]];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        lOriginY = 20.0;
        lRect = CGRectMake(SPACING *2, CGRectGetMinY(self.view.frame)+lOriginY+HEIGHT, lSize.width , lSize.height);
    }
    else
    {
        lRect = CGRectMake(SPACING *2, CGRectGetMinY(self.view.frame), lSize.width , lSize.height);
    }
    
    
    lObjUserIDLblPtr = [[UILabel alloc] initWithFrame:lRect];
    lObjUserIDLblPtr.backgroundColor = [UIColor blackColor];
    lObjUserIDLblPtr.textColor = [UIColor whiteColor];
    lObjUserIDLblPtr.font = [UIFont systemFontOfSize:17.0];
    lObjUserIDLblPtr.text =lObjStringPtr;
    lObjUserIDLblPtr.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:lObjUserIDLblPtr];
    
       
       if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        lOriginY = 20.0;
        lRect = CGRectMake(CGRectGetMaxX(lObjUserIDLblPtr.frame) + SPACING *5,CGRectGetMinY(self.view.frame)+lOriginY+HEIGHT,self.view.frame.size.width - (CGRectGetMaxX(lObjUserIDLblPtr.frame) +SPACING *3 + SPACING *3 + SPACING),SPACING *8);
    }
    else
    {
        lRect = CGRectMake(CGRectGetMaxX(lObjUserIDLblPtr.frame) + SPACING *5,CGRectGetMinY(self.view.frame),self.view.frame.size.width - (CGRectGetMaxX(lObjUserIDLblPtr.frame) +SPACING *3 + SPACING *3 + SPACING),SPACING *8);

    }
    UITextField *lObjUserIdTxtFld =[[UITextField alloc] initWithFrame:lRect];
    self.m_cObjUserIDTextFieldPtr = lObjUserIdTxtFld;
    SAFE_RELEASE(lObjUserIdTxtFld)
    m_cObjUserIDTextFieldPtr.borderStyle = UITextBorderStyleRoundedRect;
    m_cObjUserIDTextFieldPtr.textColor = [UIColor blackColor];
    m_cObjUserIDTextFieldPtr.clearButtonMode=UITextFieldViewModeWhileEditing;
    m_cObjUserIDTextFieldPtr.delegate = self;
    m_cObjUserIDTextFieldPtr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_cObjUserIDTextFieldPtr.placeholder = lObjStringPtr;
    m_cObjUserIDTextFieldPtr.autocorrectionType = UITextAutocorrectionTypeNo;
    m_cObjUserIDTextFieldPtr.keyboardType=UIKeyboardTypeEmailAddress;
    [self.view addSubview:m_cObjUserIDTextFieldPtr];
    
    //allign the user id label to the center of the textfield here
    lObjUserIDLblPtr.center = CGPointMake(lObjUserIDLblPtr.center.x, CGRectGetMidY(m_cObjUserIDTextFieldPtr.frame));
    
    //Password Label
    lObjStringPtr = NSLocalizedString(@"Password", @"");
    lSize = [lObjStringPtr sizeWithFont:[UIFont systemFontOfSize:17.0]];
    lRect = CGRectMake(SPACING *2, CGRectGetMaxY(m_cObjUserIDTextFieldPtr.frame),
                       lSize.width, lSize.height);
    lObjPassWdLblPtr = [[UILabel alloc] initWithFrame:lRect];
    lObjPassWdLblPtr.backgroundColor = [UIColor clearColor];
    lObjPassWdLblPtr.textColor = [UIColor whiteColor];
    lObjPassWdLblPtr.font = [UIFont systemFontOfSize:17.0];
    lObjPassWdLblPtr.text =lObjStringPtr;
    lObjPassWdLblPtr.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:lObjPassWdLblPtr];
    
    //Password TextField
    lRect = m_cObjUserIDTextFieldPtr.frame;
    lRect.origin.y = CGRectGetMaxY(m_cObjUserIDTextFieldPtr.frame) + SPACING*2;
    
    UITextField *lObjTxtFld = [[UITextField alloc] initWithFrame:lRect];
    self.m_cObjPasswordTextFieldPtr = lObjTxtFld;
    SAFE_RELEASE(lObjTxtFld)
    m_cObjPasswordTextFieldPtr.borderStyle = UITextBorderStyleRoundedRect;
    m_cObjPasswordTextFieldPtr.clearButtonMode=UITextFieldViewModeWhileEditing;
    m_cObjPasswordTextFieldPtr.secureTextEntry=TRUE;
    m_cObjPasswordTextFieldPtr.textColor = [UIColor blackColor];
    m_cObjPasswordTextFieldPtr.delegate = self;
    m_cObjPasswordTextFieldPtr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_cObjPasswordTextFieldPtr.placeholder = lObjStringPtr;
    m_cObjPasswordTextFieldPtr.autocorrectionType = UITextAutocorrectionTypeNo;
    m_cObjPasswordTextFieldPtr.keyboardType=UIKeyboardTypeEmailAddress;
    [self.view addSubview:m_cObjPasswordTextFieldPtr];
    
    //allign the password label to the center of the textfield here
    lObjPassWdLblPtr.center = CGPointMake(lObjPassWdLblPtr.center.x, CGRectGetMidY(m_cObjPasswordTextFieldPtr.frame));
    

    SAFE_RELEASE(lObjUserIDLblPtr)
    SAFE_RELEASE(lObjPassWdLblPtr)
    
//   UIButton *lObjSubmitBtnPtr = [[UIButton alloc] initWithFrame:CGRectMake(m_cObjPasswordTextFieldPtr.frame.origin.x,150.0f,100.0f, 30.0f)];
//    [lObjSubmitBtnPtr setTitle:NSLocalizedString(@"Sign In", @"") forState:UIControlStateNormal];
//    [lObjSubmitBtnPtr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [lObjSubmitBtnPtr addTarget:self action:@selector(OnSignInBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [lObjSubmitBtnPtr setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"BtnBackgroundImage", @"")]]];
//    [self.view addSubview:lObjSubmitBtnPtr];
//    SAFE_RELEASE(lObjSubmitBtnPtr)
}

#pragma mark - Validation
- (BOOL)validateTheFields
{
    BOOL    lRetval = YES;
    
    //to resign the firt responder if any for the view
    [self.view endEditing:YES];
    
    
//    if(0 >= [m_cObjUserIDTextFieldPtr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length )
//    {
//        [gObjAppDelegatePtr showAlertMsg:NSLocalizedString(@"UserIDValidationMsg", @"")
//                                     Tag:0 delegate:nil];
//        lRetval = NO;
//    }
    if([self validateEmail:m_cObjUserIDTextFieldPtr.text ]==NO)
    {
        [gObjAppDelegatePtr showAlertMsg:NSLocalizedString(@"UserIDValidationMsg", @"")
                                     Tag:0 delegate:nil];
        lRetval = NO;
    }
    else if(0 >= [m_cObjPasswordTextFieldPtr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
    {
        [gObjAppDelegatePtr showAlertMsg:NSLocalizedString(@"PwdIDValidationMsg", @"")
                                     Tag:0 delegate:nil];
        lRetval = NO;
    }
    
    return lRetval;
}
-(BOOL)validateEmail:(NSString *)pEmailText
{
    BOOL lRetval = YES;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    lRetval = [emailTest evaluateWithObject:pEmailText];
    return lRetval;
}

-(void)OnSignInBtnClicked
{
#if 0
    //[gObjAppDelegatePtr stopProgressHandler];//Remove it everything complete
    
    

#else
    

    
    
    NSUserDefaults *languagePrefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *lLangCode = [languagePrefs stringForKey:@"userSelServer"];
    
    if (nil == lLangCode)
    {
        gObjAppDelegatePtr.m_cUserSelServer = @"Production";
    }
    else
    {
        gObjAppDelegatePtr.m_cUserSelServer = lLangCode;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localizedServerChanged" object:self userInfo:nil];
    
    
    gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
    NSDate *lObjCurrentDate = [NSDate date];
    NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
    
	[lObjDateFormatterPtr setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [lObjDateFormatterPtr stringFromDate:lObjCurrentDate];
    
    if (YES == [self validateTheFields])
    {
        if (YES ==[gObjAppDelegatePtr isNetworkAvailable]) {
           // gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
            [gObjAppDelegatePtr displayProgressHandler:@"Signing In"];
            gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjUserIdPtr = m_cObjUserIDTextFieldPtr.text;
            gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjPasswordPtr = m_cObjPasswordTextFieldPtr.text;
            gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
            [gObjAppDelegatePtr.m_cObjHttpHandlerPtr loginRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr deviceId:gObjAppDelegatePtr.m_cObjDeviceIdPtr];
        }

        else if(NO == [gObjAppDelegatePtr isNetworkAvailable])
        {

            gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
            UserInfo *lObjUserInforPtr = (UserInfo *)nil;
            lObjUserInforPtr = [gObjAppDelegatePtr.m_cDbHandler getUserDetail];
            // getting an NSString
           
            
            if ((UserInfo *)nil != lObjUserInforPtr)
            {
                
                gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjUserIdPtr = m_cObjUserIDTextFieldPtr.text;
                gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjPasswordPtr = m_cObjPasswordTextFieldPtr.text;
                if ((NSString *)nil != m_cObjUserIDTextFieldPtr.text && (NSString *)nil != m_cObjPasswordTextFieldPtr.text) {
                    if (YES == [self validateTheFields])
                    {
                        if ([m_cObjUserIDTextFieldPtr.text isEqualToString:lObjUserInforPtr.m_cObjUserIdPtr] )
                        {
                            if ([m_cObjPasswordTextFieldPtr.text isEqualToString:lObjUserInforPtr.m_cObjPasswordPtr])
                            {
                                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                            }
                            else
                            {
                                UIAlertView *lObjAlertViewPtr;
                                lObjAlertViewPtr = [[UIAlertView alloc]
                                                    initWithTitle:@"Athlete Logger"
                                                    message:@"Please type correct password"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil,
                                                    nil];
                                [lObjAlertViewPtr show];
                                [gObjAppDelegatePtr stopProgressHandler];
                                SAFE_RELEASE(lObjAlertViewPtr)
                            }
                            
                        }
                        else
                        {
                            UIAlertView *lObjAlertViewPtr;
                            lObjAlertViewPtr = [[UIAlertView alloc]
                                                initWithTitle:@"Athlete Logger"
                                                message:[NSString stringWithFormat:@"User %@ was previously logged in and you need to login as user %@ to continue",lObjUserInforPtr.m_cObjUserIdPtr,lObjUserInforPtr.m_cObjUserIdPtr]
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil,
                                                nil];
                            [lObjAlertViewPtr show];
                            [gObjAppDelegatePtr stopProgressHandler];
                            SAFE_RELEASE(lObjAlertViewPtr)
                            
                        }
                    }
                }
            }
            else{
                UIAlertView *lObjAlertViewPtr;
                lObjAlertViewPtr = [[UIAlertView alloc]
                                    initWithTitle:@"Athlete Logger"
                                    message:@"Connection Failed."
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil,
                                    nil];
                [lObjAlertViewPtr show];
                [gObjAppDelegatePtr stopProgressHandler];
                SAFE_RELEASE(lObjAlertViewPtr)
            }
        }

    }
    SAFE_RELEASE(lObjDateFormatterPtr)
#endif
}
-(void)serverTransactionSucceeded
{
    [gObjAppDelegatePtr stopProgressHandler];
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
   
    
    if (YES == gObjAppDelegatePtr.IsAddedinOfflineMode)
        gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cIsAddedinOfflineMode = YES;
    else
        gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cIsAddedinOfflineMode = NO;
    
    //Added to save login info and save into database 8-2-2013 - start
    [gObjAppDelegatePtr.m_cDbHandler insertLoginInfo:gObjAppDelegatePtr.m_cObjUserInfoPtr];
    
    gObjAppDelegatePtr.m_cIsValidationSucceed = YES;
    gObjAppDelegatePtr.m_cObjWindowPtr.rootViewController = gObjAppDelegatePtr.m_cObjTabBarControllerPtr;
    
    //Narasimhaiah added to get the string from date 14-2-13  - start
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [formatter release];
    //Narasimhaiah added to get the string from date 14-2-13  - end
    
    gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjLastTimeDownloaded = [NSString stringWithFormat:@"%@",dateString];
    [gObjAppDelegatePtr stopProgressHandler];
    
   // gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
    [gObjAppDelegatePtr displayProgressHandler:@"Downloading Combine List"];
    //[gObjAppDelegatePtr displayProgressHandler:@"Downloading List of Athletes"];
    
    
    if (YES == [gObjAppDelegatePtr isNetworkAvailable]) 
    {
         [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadCombineIds];
//        gObjAppDelegatePtr.isDownloadForAllAthletes = YES;
//        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr downloadRequest:gObjAppDelegatePtr.m_cObjUserInfoPtr];
    }
    else if(NO == [gObjAppDelegatePtr isNetworkAvailable]){
        [gObjAppDelegatePtr stopProgressHandler];
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    }
    //Added to save login info and save into database 8-2-2013 - end
}
-(void)serverTransactionFailed
{
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    
    if (NO == gObjAppDelegatePtr.m_cObjUserInfoPtr.isLoginSucceed && YES == [gObjAppDelegatePtr isNetworkAvailable] && YES == gObjAppDelegatePtr.isForLogin) {
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Please enter correct UserID and Password."
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil,
                            nil];
        [lObjAlertViewPtr show];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
    else if (YES == gObjAppDelegatePtr.isConnectionTimeout)
    {
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        UserInfo *lObjUserInforPtr = (UserInfo *)nil;
        lObjUserInforPtr = [[UserInfo alloc] init];
        lObjUserInforPtr = [gObjAppDelegatePtr.m_cDbHandler getUserDetail];
        if ((UserInfo *)nil != lObjUserInforPtr) {
            gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjUserIdPtr = m_cObjUserIDTextFieldPtr.text;
            gObjAppDelegatePtr.m_cObjUserInfoPtr.m_cObjPasswordPtr = m_cObjPasswordTextFieldPtr.text;
            if ((NSString *)nil != m_cObjUserIDTextFieldPtr.text && (NSString *)nil != m_cObjPasswordTextFieldPtr.text) {
                if (YES == [self validateTheFields])
                {
                    if ([m_cObjUserIDTextFieldPtr.text isEqualToString:lObjUserInforPtr.m_cObjUserIdPtr] && [m_cObjPasswordTextFieldPtr.text isEqualToString:lObjUserInforPtr.m_cObjPasswordPtr]) {
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                    }
                    else
                    {
                        UIAlertView *lObjAlertViewPtr;
                        lObjAlertViewPtr = [[UIAlertView alloc]
                                            initWithTitle:@"Athlete Logger"
                                            message:@"Connection Failed."
                                            delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil,
                                            nil];
                        [lObjAlertViewPtr show];
                        [gObjAppDelegatePtr stopProgressHandler];
                        SAFE_RELEASE(lObjAlertViewPtr)
                        
                    }
                }
            }
            SAFE_RELEASE(lObjUserInforPtr)
        }
        else
        {
            UIAlertView *lObjAlertViewPtr;
            lObjAlertViewPtr = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"Connection Failed."
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil,
                                nil];
            [lObjAlertViewPtr show];
            [gObjAppDelegatePtr stopProgressHandler];
            SAFE_RELEASE(lObjAlertViewPtr)
            
        }        
    }
    else{
        UIAlertView *lObjAlertViewPtr;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Connection Failed."
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil,
                            nil];
        [lObjAlertViewPtr show];
        [gObjAppDelegatePtr stopProgressHandler];
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
#pragma TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField ==  m_cObjUserIDTextFieldPtr) 
    {
        [m_cObjPasswordTextFieldPtr becomeFirstResponder];
    }
    else if (textField == m_cObjPasswordTextFieldPtr)
    {
        [m_cObjPasswordTextFieldPtr resignFirstResponder];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    BOOL lRetval = NO;
//    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    return lRetval = !([newString length] > 20);
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjPasswordTextFieldPtr)
    SAFE_RELEASE(m_cObjUserIDTextFieldPtr)
    [super dealloc];
}

@end
