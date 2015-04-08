//
//  LogViewController.m
//  GCN Combine
//
//  Created by DP Samantrai on 02/03/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import "LogViewController.h"
#import "AddAthleteDetailsTableViewCell.h"
#import "AddZigZagLogTableViewCell.h"


@interface LogViewController ()
{
    int m_cRowCount;
    float m_cHeightofRow;
    NSTimer *m_cObjTimer;
    UITextField *m_cObjMinTextField;
    UITextField *m_cObjSecTextField;
    UILabel *m_cObjMinLable;
    UILabel *m_cObjSecLable;
    UILabel *m_cObjDivLable;
    UILabel *m_cObjDiv2Lable;
    UILabel *m_cObjMilSecLable;
    UIButton *m_cObjStartButton;
    UIButton *m_cObjStopButton;
    UIView *m_cObjTimerView;
}
@end

@implementation LogViewController
@synthesize m_cObjTestDataPtr;
@synthesize m_cObjAthletelogPtr,m_cObjCountDownTimerValue,m_cObjTimerArrayPtr,m_cObjScrollViewPtr,m_cObjAlarmSoundPtr,m_cObjSprintTextFieldPtr,m_cObjInstructionLabelPtr,m_cObjSprintTimeLabelPtr,m_cObjSprintClearBtnPtr,m_cObjSprintTimerBtnPtr,m_cObjChoiceLabelPtr,m_cObjeditTimerButtonPtr,m_cObjeditTimerMessagePtr,m_cObjkeyboardDoneButtonViewPtr,m_cObjActiveTextFieldPtr,m_cObjTimerArrayValuesPtr,m_cObjTimerPickerViewPtr,m_cObjSegementCtrlPtr,m_cObjSprintTimerValuePtr,m_cObjSprintTotalTimePtr,m_cObjVerticalJumpChoiceListPtr,m_cObjverticalJumpPicker,m_cObjSprintTimeLabel,m_cObjSprintTimePtr;
@synthesize m_cAthleteId,isServerTransactionSucceed,m_cObjVerJumpTableViewPtr,m_cObjToolBarPtr,isValidationFailed,m_cObjTimerLabelDictPtr;
@synthesize m_cObjSprintTimeDictPtr,m_cObjSprintTimerDictPtr,m_cObjSprintTotalTimeDictPtr,m_cObjAthleteDetailsDataPtr,isAddedinOfflineMode;


int seconds,minute,secondsleft,milisec;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
          isServerTransactionSucceed = NO;
        m_cObjVerJumpTableViewPtr = (UITableView *)nil;
        isValidationFailed =NO;
        isAddedinOfflineMode = NO;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     [self createElements];
    
}

-(void)addTimerview
{
    m_cObjTimerView =[[UIView alloc]init];
    m_cObjTimerView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.m_cObjVerJumpTableViewPtr.frame), CGRectGetWidth(self.view.frame), 250);
    m_cObjTimerView.backgroundColor = [UIColor clearColor];
    
   
    m_cObjTimerView.backgroundColor=[UIColor clearColor];
    m_cObjMinTextField=[[UITextField alloc]init];
    m_cObjMinTextField.frame=CGRectMake(60, 20, 90, 40);
    m_cObjMinTextField.delegate=self;
    m_cObjMinTextField.backgroundColor=[UIColor whiteColor];
    m_cObjMinTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_cObjMinTextField.textAlignment=NSTextAlignmentCenter;
    m_cObjMinTextField.clipsToBounds = YES;
    m_cObjMinTextField.tag = MIN_TXTFIELD_TAG;
    m_cObjMinTextField.text=@"00";
    m_cObjMinTextField.layer.cornerRadius = 10.0f;
    m_cObjMinTextField.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;
    [m_cObjMinTextField setFont:[UIFont systemFontOfSize:25]];
    m_cObjMinTextField.keyboardType=UIKeyboardTypeNumberPad;
    m_cObjMinTextField.returnKeyType = UIReturnKeyDone;
    [m_cObjTimerView addSubview:m_cObjMinTextField];
    
    
    UILabel *lObjLable=[[UILabel alloc]init];
    lObjLable.frame=CGRectMake(155, 20, 5, 40);
    lObjLable.text=@":";
    [lObjLable setFont:[UIFont boldSystemFontOfSize:20]];
    [lObjLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [lObjLable setUserInteractionEnabled:NO];
    lObjLable.backgroundColor=[UIColor clearColor];
    lObjLable.textColor=[UIColor blackColor];
    [m_cObjTimerView addSubview:lObjLable];
    
    m_cObjSecTextField=[[UITextField alloc]init];
    m_cObjSecTextField.frame=CGRectMake(165, 20, 90, 40);
    m_cObjSecTextField.delegate=self;
    m_cObjSecTextField.textAlignment=NSTextAlignmentCenter;
    m_cObjSecTextField.clipsToBounds = YES;
    m_cObjSecTextField.tag = SEC_TXTFIELD_TAG;
    m_cObjSecTextField.text=@"00";
     m_cObjSecTextField.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;
    m_cObjSecTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_cObjSecTextField.backgroundColor=[UIColor whiteColor];
    m_cObjSecTextField.layer.cornerRadius = 10.0f;
    [m_cObjSecTextField setFont:[UIFont systemFontOfSize:25]];
    m_cObjSecTextField.keyboardType=UIKeyboardTypeNumberPad;
     m_cObjSecTextField.returnKeyType = UIReturnKeyDone;
    [m_cObjTimerView addSubview:m_cObjSecTextField];
    
    UILabel *lObjMinLable=[[UILabel alloc]init];
    lObjMinLable.frame=CGRectMake(90, 5, 80, 15);
    lObjMinLable.text=@"MIN";
    lObjMinLable.backgroundColor=[UIColor clearColor];
    lObjMinLable.textColor=[UIColor whiteColor];
    [lObjMinLable setFont:[UIFont boldSystemFontOfSize:14]];
    [lObjMinLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [lObjMinLable setUserInteractionEnabled:NO];
    [m_cObjTimerView addSubview:lObjMinLable];
    
    UILabel *lObjSecLable=[[UILabel alloc]init];
    lObjSecLable.frame=CGRectMake(195, 5, 80, 15);
    lObjSecLable.text=@"SEC";
    lObjSecLable.backgroundColor=[UIColor clearColor];
    lObjSecLable.textColor=[UIColor whiteColor];
    [lObjSecLable setFont:[UIFont boldSystemFontOfSize:14]];
    [lObjSecLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [lObjSecLable setUserInteractionEnabled:NO];
    [m_cObjTimerView addSubview:lObjSecLable];
    
    [self addButtons];
    [m_cObjScrollViewPtr addSubview:m_cObjTimerView];
    
}


-(void)loadView
{
    [super loadView];
    
    AthleteLog *lObjAthleteLogPtr = (AthleteLog *)nil;
    lObjAthleteLogPtr = [[AthleteLog alloc] init];
    
    self.m_cObjAthletelogPtr = lObjAthleteLogPtr;
    
    SAFE_RELEASE(lObjAthleteLogPtr)

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     isServerTransactionSucceed = NO;
    
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])) {
        self.m_cObjCountDownTimerValue =[NSString stringWithFormat:@"%d",30];
    }
    
    [self createControls];
    
    //Register For Keyboard Notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:m_cObjCurrentTextFieldPtr];
    IsTextFieldActive = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
    
     if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr isEqualToString:@"1"])
     {
        if((NSTimer *)nil != m_cObjSprintTimerPtr)
         {
             [m_cObjSprintTimerPtr invalidate];
             m_cObjSprintTimerPtr = (NSTimer *)nil;
         }
         if((AVAudioPlayer *)nil != self.m_cObjAlarmSoundPtr)
         {
             [self.m_cObjAlarmSoundPtr stop];
             self.m_cObjAlarmSoundPtr = (AVAudioPlayer *)nil;
         }
     }
}
-(void)countdownTimer
{
    m_cObjTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer
{
    NSLog(@"%d",seconds);
    if(secondsleft > 0 )
    {
        secondsleft -- ;
        minute = secondsleft / 3600;
        seconds = (secondsleft % 3600) / 60;
        milisec = (secondsleft %3600) % 60;
        m_cObjSecLable.text = [NSString stringWithFormat:@"%02d",seconds];
        m_cObjMilSecLable.text = [NSString stringWithFormat:@"%02d",milisec];
        m_cObjMinLable.text = [NSString stringWithFormat:@"%02d",minute];
    }
    else
    {
        [m_cObjTimer invalidate];
        m_cObjTimer = nil;
    }
}


-(void)whenStartbuttonpressed :(UITextField*)textfield
{
    m_cObjVerJumpTableViewPtr.userInteractionEnabled = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >=  7.0)
    {
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0,-70.0);
        
        
    }
    else
    {
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
        //[self scrollTableViewToCell:m_cObjActiveTextFieldPtr height:220];
    }
//    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
//    m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0,-70.0);
    [m_cObjMinTextField resignFirstResponder];
    [m_cObjSecTextField resignFirstResponder];
    //    [self hideTextfield:textfield];
    secondsleft = ([m_cObjMinTextField.text intValue]*3600)+[m_cObjSecTextField.text intValue]*60;
    [self countdownTimer];
    m_cObjStopButton.enabled=YES;
    if (m_cObjMinLable==nil)
    {
        m_cObjMinLable=[[UILabel alloc]init];
        m_cObjMinLable.frame=CGRectMake(0, 140,110, 75);
    }
    m_cObjMinLable.text=m_cObjMinTextField.text;
    m_cObjMinLable.backgroundColor = [UIColor clearColor];
    m_cObjMinLable.textColor=[UIColor whiteColor];
    m_cObjMinLable.textAlignment=NSTextAlignmentRight;
    [m_cObjMinLable setFont:[UIFont systemFontOfSize:40]];
    [m_cObjMinLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [m_cObjTimerView addSubview:m_cObjMinLable];
    
    if (m_cObjSecLable==Nil)
    {
        m_cObjSecLable=[[UILabel alloc]init];
        m_cObjSecLable.frame=CGRectMake(120, 140, 60, 75);
    }
    m_cObjSecLable.text=m_cObjSecTextField.text;
    m_cObjSecLable.textAlignment=NSTextAlignmentCenter;
    m_cObjSecLable.textColor=[UIColor whiteColor];
    m_cObjSecLable.backgroundColor = [UIColor clearColor];
    [m_cObjSecLable setFont:[UIFont systemFontOfSize:40]];
    [m_cObjSecLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [m_cObjSecLable setUserInteractionEnabled:NO];
    [m_cObjTimerView addSubview:m_cObjSecLable];
    
    if (m_cObjDivLable==Nil)
    {
        m_cObjDivLable=[[UILabel alloc]init];
        m_cObjDivLable.frame=CGRectMake(170,140, 20, 75);
    }
    m_cObjDivLable.text=@":";
    m_cObjDivLable.textColor=[UIColor whiteColor];
    m_cObjDivLable.backgroundColor = [UIColor clearColor];

    [m_cObjDivLable setFont:[UIFont systemFontOfSize:40]];
    m_cObjDivLable.textAlignment=NSTextAlignmentCenter;
    [m_cObjDivLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [m_cObjTimerView addSubview:m_cObjDivLable];
    
    if (m_cObjDiv2Lable==Nil)
    {
        m_cObjDiv2Lable=[[UILabel alloc]init];
        m_cObjDiv2Lable.frame=CGRectMake(110, 140, 20, 75);
    }
    m_cObjDiv2Lable.text=@":";
    m_cObjDiv2Lable.textColor=[UIColor whiteColor];
     m_cObjDiv2Lable.backgroundColor = [UIColor clearColor];

    [m_cObjDiv2Lable setFont:[UIFont systemFontOfSize:40]];
    m_cObjDiv2Lable.textAlignment=NSTextAlignmentCenter;
    [m_cObjDiv2Lable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [m_cObjTimerView addSubview:m_cObjDiv2Lable];
    
    if (m_cObjMilSecLable==Nil)
    {
        m_cObjMilSecLable=[[UILabel alloc]init];
        m_cObjMilSecLable.frame=CGRectMake(185, 140, 60, 75);
    }
    [m_cObjMilSecLable setFont:[UIFont systemFontOfSize:40]];
    m_cObjMilSecLable.textColor=[UIColor whiteColor];
    m_cObjMilSecLable.backgroundColor = [UIColor clearColor];

    m_cObjMilSecLable.textAlignment=NSTextAlignmentCenter;
    [m_cObjMilSecLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [m_cObjMilSecLable setUserInteractionEnabled:NO];
    [m_cObjTimerView addSubview:m_cObjMilSecLable];
    m_cObjStartButton.enabled=NO;
}

-(void)whenStoptbuttonpressed
{
    m_cObjVerJumpTableViewPtr.userInteractionEnabled = YES;
    m_cObjStartButton.enabled=NO;
    m_cObjStopButton.enabled=NO;
    [m_cObjTimer invalidate];
    m_cObjMinLable.hidden=YES;
    m_cObjSecLable.hidden=YES;
    m_cObjDivLable.hidden=YES;
    m_cObjDiv2Lable.hidden=YES;
    m_cObjMilSecLable.hidden=YES;
    m_cObjMinLable=nil;
    m_cObjSecLable=nil;
    m_cObjDivLable=nil;
    m_cObjMilSecLable=nil;
    m_cObjDiv2Lable=nil;
    m_cObjMinTextField.text=@"00";
    m_cObjSecTextField.text=@"00";
}


-(void)createElements
{
    UIBarButtonItem *lObjBtnPtr = (UIBarButtonItem *)nil;
    
    lObjBtnPtr = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackButtonClicked:)];
    self.navigationItem.leftBarButtonItem = lObjBtnPtr;
    SAFE_RELEASE(lObjBtnPtr)
    
    m_cObjSaveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = m_cObjSaveButton;
    
}
-(void)onBackButtonClicked : (id)sender
{
    [self.view endEditing:YES];
    if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        if([m_cObjTimerPickerViewPtr isHidden] == NO)
        {
            [self pickerDoneClicked:nil];
        }
    }
    if (m_cObjMinLable)
    {
        [self whenStoptbuttonpressed];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldDidChange : (NSNotification *)pObjNotification
{
    if(m_cObjCurrentTextFieldPtr == m_cObjSprintTextFieldPtr)
        m_cObjSaveButton.enabled = YES;
}

-(void)addButtons
{
    m_cObjStartButton=[UIButton buttonWithType:UIButtonTypeCustom];
    m_cObjStartButton.frame=CGRectMake(30, 80, 115, 30);
    m_cObjStartButton.backgroundColor=[UIColor redColor];
    m_cObjStartButton.clipsToBounds = YES;
    m_cObjStartButton.layer.cornerRadius=10;
    m_cObjStartButton.enabled=NO;
    [m_cObjStartButton addTarget:self action:@selector(whenStartbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_cObjTimerView addSubview:m_cObjStartButton];
    
    UILabel *lobjStartLable=[[UILabel alloc]init];
    lobjStartLable.frame=CGRectMake(30, 80, 115, 30);
    lobjStartLable.text=@"START";
    lobjStartLable.clipsToBounds=YES;
    lobjStartLable.layer.cornerRadius=10.0f;
    lobjStartLable.backgroundColor=[UIColor brownColor];
    lobjStartLable.textAlignment=NSTextAlignmentCenter;
    [lobjStartLable setFont:[UIFont boldSystemFontOfSize:20]];
    [lobjStartLable setUserInteractionEnabled:NO];
    lobjStartLable.textColor=[UIColor whiteColor];
    [m_cObjTimerView addSubview:lobjStartLable];
    
    m_cObjStopButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    m_cObjStopButton.frame=CGRectMake(175, 80, 115, 30);
    m_cObjStopButton.backgroundColor=[UIColor clearColor];
    m_cObjStopButton.clipsToBounds = YES;
    m_cObjStopButton.enabled=NO;
    m_cObjStopButton.layer.cornerRadius = 10.0f;
    [m_cObjStopButton addTarget:self action:@selector(whenStoptbuttonpressed) forControlEvents:UIControlEventTouchDown];
    m_cObjStopButton.layer.borderWidth=5.0f;
    [m_cObjTimerView addSubview:m_cObjStopButton];
    
    UILabel *lObjStopLable=[[UILabel alloc]init];
    lObjStopLable.frame=CGRectMake(175, 80, 115, 30);
    lObjStopLable.text=@"STOP";
    lObjStopLable.textAlignment=NSTextAlignmentCenter;
    lObjStopLable.backgroundColor=[UIColor brownColor];
    lObjStopLable.clipsToBounds=YES;
    lObjStopLable.layer.cornerRadius=10.0f;
    [lObjStopLable setFont:[UIFont boldSystemFontOfSize:20]];
    [lObjStopLable setUserInteractionEnabled:NO];
    lObjStopLable.textColor=[UIColor whiteColor];
    [m_cObjTimerView addSubview:lObjStopLable];
    
}


-(void)createControls
{
    [self createKeyBoardToolbar];
    if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        m_cObjScrollViewPtr = (UIScrollView *)nil;
        m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        m_cObjScrollViewPtr.scrollEnabled = NO;
        m_cObjScrollViewPtr.delegate = self;
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
       //[self.view addSubview:m_cObjScrollViewPtr];
        
        
        m_cObjInstructionLabelPtr = [[UILabel alloc]init];
        m_cObjInstructionLabelPtr.frame = CGRectMake(60.0, 3.0, 240.0, 25.0);
        m_cObjInstructionLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjInstructionLabelPtr.font = [UIFont fontWithName:@"MuseoSlab-500" size:15.0];
        m_cObjInstructionLabelPtr.textColor = [UIColor whiteColor];
        m_cObjInstructionLabelPtr.shadowColor = UIColorFromRGBWithAlpha(0x000000,1.0);
        m_cObjInstructionLabelPtr.numberOfLines = 0;
        m_cObjInstructionLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        [m_cObjScrollViewPtr addSubview:m_cObjInstructionLabelPtr];
        
        
        
        
        
        if([self.m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Setting Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record sets and tap save.";
            self.navigationItem.title = @"Setting Accuracy";
        }
        else if ([self.m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Passing Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record passes and tap save.";
            self.navigationItem.title = @"Passing Accuracy";
        }
        else if ([self.m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Serve Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record serves and tap save.";
            self.navigationItem.title = @"Serve Accuracy";
        }
        else
        {
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" "];
            NSArray *testNameArray = (NSArray *)nil;
            NSString *lObjTestnamePtr = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
            testNameArray = [lObjTestnamePtr componentsSeparatedByCharactersInSet:set];
            
          m_cObjInstructionLabelPtr.text = [NSString stringWithFormat:@"Record %@ and tap save",[testNameArray objectAtIndex:0]];
            self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        }
        
        m_cObjSprintTimeLabelPtr = [[UILabel alloc] init];
        m_cObjSprintTimeLabelPtr.frame = CGRectMake(25.0, CGRectGetMaxY(m_cObjInstructionLabelPtr.frame) + 15.0,260.0, 70.0);

        m_cObjSprintTimeLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjSprintTimeLabelPtr.textAlignment = UITextAlignmentCenter;
        m_cObjSprintTimeLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjSprintTimeLabelPtr.textColor = [UIColor whiteColor];
        m_cObjSprintTimeLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:64];
        if ((NSString *)nil == self.m_cObjCountDownTimerValue || [self.m_cObjCountDownTimerValue isEqualToString:@""] || [self.m_cObjCountDownTimerValue isEqualToString:@" "]) {
            m_cObjSprintTimeLabelPtr.text = @"00:30.00 secs";
        }
        else
        {
            m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
        }
        [m_cObjScrollViewPtr addSubview:m_cObjSprintTimeLabelPtr];

        //Narasimhaiah added the reset button for stopping the count down and reset to start
        m_cObjSprintClearBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        m_cObjSprintClearBtnPtr.frame = CGRectMake(26.0, CGRectGetMaxY(m_cObjSprintTimeLabelPtr.frame)+5.0, 130.0, 46.0);
        m_cObjSprintClearBtnPtr.tag = 21;
        m_cObjSprintClearBtnPtr.backgroundColor = [UIColor grayColor];
        m_cObjSprintClearBtnPtr.layer.cornerRadius = 10.0;
        m_cObjSprintClearBtnPtr.titleLabel.textAlignment = UITextAlignmentLeft;
        m_cObjSprintClearBtnPtr.titleLabel.textColor = [UIColor blackColor];
        [m_cObjSprintClearBtnPtr setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
        [m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[m_cObjSprintClearBtnPtr layer]setBorderWidth:3.0f];
        m_cObjSprintClearBtnPtr.userInteractionEnabled = NO;
        [[m_cObjSprintClearBtnPtr layer]setBorderColor:[UIColor colorWithRed:-51 green:-51 blue:-51 alpha:0.8].CGColor];
        [m_cObjScrollViewPtr addSubview:m_cObjSprintClearBtnPtr];
        
        
        
        m_cObjSprintTimerBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        m_cObjSprintTimerBtnPtr.frame = CGRectMake(10.0+CGRectGetMaxX(m_cObjSprintClearBtnPtr.frame), CGRectGetMaxY(m_cObjSprintTimeLabelPtr.frame)+5.0, 130.0, 46.0);
        m_cObjSprintTimerBtnPtr.tag = 24;
        m_cObjSprintTimerBtnPtr.backgroundColor = [UIColor orangeColor];
        m_cObjSprintTimerBtnPtr.layer.cornerRadius = 10.0;
        m_cObjSprintTimerBtnPtr.titleLabel.textAlignment = UITextAlignmentLeft;
        m_cObjSprintTimerBtnPtr.titleLabel.textColor = [UIColor blackColor];
        [m_cObjSprintTimerBtnPtr setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
        [m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[m_cObjSprintTimerBtnPtr layer]setBorderWidth:3.0f];
        [[m_cObjSprintTimerBtnPtr layer]setBorderColor:[UIColor colorWithRed:-51 green:-51 blue:-51 alpha:0.8].CGColor];
        [m_cObjScrollViewPtr addSubview:m_cObjSprintTimerBtnPtr];
        
        m_cObjChoiceLabelPtr = (UILabel *)nil;
        m_cObjChoiceLabelPtr = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(m_cObjSprintTimerBtnPtr.frame)+40.0, 143, 35)];
        
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSArray *testNameArray = (NSArray *)nil;
        NSString *lObjTestnamePtr = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        testNameArray = [lObjTestnamePtr componentsSeparatedByCharactersInSet:set];
        
        m_cObjChoiceLabelPtr.text = [NSString stringWithFormat:@"No. of %@",[testNameArray objectAtIndex:0]];
        m_cObjChoiceLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjChoiceLabelPtr.textAlignment = UITextAlignmentLeft;
        m_cObjChoiceLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjChoiceLabelPtr.textColor = [UIColor whiteColor];
        [m_cObjScrollViewPtr addSubview:m_cObjChoiceLabelPtr];
        
        
        m_cObjSprintTextFieldPtr = [[UITextField alloc] init];
        m_cObjSprintTextFieldPtr.frame = CGRectMake(CGRectGetMaxX(m_cObjChoiceLabelPtr.frame)+5.0,CGRectGetMaxY(m_cObjSprintTimerBtnPtr.frame)+45.0, 140.0, 35.0);
        m_cObjSprintTextFieldPtr.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cObjSprintTextFieldPtr.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_cObjSprintTextFieldPtr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_cObjSprintTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:18];
        m_cObjSprintTextFieldPtr.textColor = [UIColor blackColor];
        m_cObjSprintTextFieldPtr.backgroundColor = [UIColor lightGrayColor];
        m_cObjSprintTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
        m_cObjSprintTextFieldPtr.borderStyle = UITextBorderStyleRoundedRect;
        m_cObjSprintTextFieldPtr.delegate = self;
        m_cObjSprintTextFieldPtr.placeholder = @"Enter Count";
        m_cObjSprintTextFieldPtr.userInteractionEnabled = NO;
        [self createTimerPicker];
              
        
        [m_cObjScrollViewPtr addSubview:m_cObjSprintTextFieldPtr];
        m_cObjCurrentTextFieldPtr = m_cObjSprintTextFieldPtr;
        
        m_cObjeditTimerButtonPtr = (UIButton *)nil;
        m_cObjeditTimerButtonPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_cObjeditTimerButtonPtr setImage:[UIImage imageNamed:@"icon-timer1.png"] forState:UIControlStateNormal];
        m_cObjeditTimerButtonPtr.frame = CGRectMake(45, CGRectGetMaxY(m_cObjSprintTextFieldPtr.frame)+36.0, 35, 35);
        [m_cObjeditTimerButtonPtr addTarget:self action:@selector(showTimePicker:) forControlEvents:UIControlEventTouchUpInside];
        [m_cObjScrollViewPtr addSubview:m_cObjeditTimerButtonPtr];
        
        
        m_cObjeditTimerMessagePtr = (UILabel *)nil;
        m_cObjeditTimerMessagePtr = [[UILabel alloc]init];
        m_cObjeditTimerMessagePtr.frame = CGRectMake(CGRectGetMaxX(m_cObjeditTimerButtonPtr.frame)+10.0, CGRectGetMaxY(m_cObjSprintTextFieldPtr.frame)+40.0, 240.0, 25.0);
        m_cObjeditTimerMessagePtr.backgroundColor = [UIColor clearColor];
        [m_cObjeditTimerMessagePtr setText:NSLocalizedString(@"Edit Message", @"")];
        m_cObjeditTimerMessagePtr.font = [UIFont boldSystemFontOfSize:18.0];
        m_cObjeditTimerMessagePtr.textColor = [UIColor whiteColor];
        m_cObjeditTimerMessagePtr.numberOfLines = 0;
        m_cObjeditTimerMessagePtr.lineBreakMode = UILineBreakModeWordWrap;
        [m_cObjScrollViewPtr addSubview:m_cObjeditTimerMessagePtr];
    }
#if 0
    //UI for Spike Speed
    else if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        
        CGRect lRect = CGRectMake(10.0, 10.0, 310.0, 700.0);
        if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) ||  ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
        {
            m_cObjVerJumpTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];
            self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        }
        else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]))
        {
            m_cObjInstructionLabelPtr = [[UILabel alloc]init];
            m_cObjInstructionLabelPtr.frame = CGRectMake(60.0, 3.0, 240.0, 25.0);
            m_cObjInstructionLabelPtr.backgroundColor = [UIColor clearColor];
            m_cObjInstructionLabelPtr.font = [UIFont fontWithName:@"MuseoSlab-500" size:15.0];
            m_cObjInstructionLabelPtr.textColor = [UIColor whiteColor];
            m_cObjInstructionLabelPtr.shadowColor = UIColorFromRGBWithAlpha(0x000000,1.0);
            m_cObjInstructionLabelPtr.numberOfLines = 0;
            m_cObjInstructionLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
            m_cObjInstructionLabelPtr.text = NSLocalizedString(@"Instruction MSg", @"");
            [self.view addSubview:m_cObjInstructionLabelPtr];
            
            CGRect lRect = CGRectMake(10.0, 5.0 + CGRectGetMaxY(m_cObjInstructionLabelPtr.frame), 310.0, 480.0);
            m_cObjVerJumpTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStylePlain];
        }
        m_cObjVerJumpTableViewPtr.backgroundColor = [UIColor clearColor];
        m_cObjVerJumpTableViewPtr.backgroundView = nil;
        m_cObjVerJumpTableViewPtr.delegate = self;
        m_cObjVerJumpTableViewPtr.dataSource = self;
        m_cObjVerJumpTableViewPtr.autoresizesSubviews = YES;
        if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]))
        {
            m_cObjVerJumpTableViewPtr.scrollEnabled = NO;
        }
        if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
        {
            m_cObjVerJumpTableViewPtr.scrollEnabled = YES;
        }
        m_cObjVerJumpTableViewPtr.allowsSelectionDuringEditing = YES;
        m_cObjVerJumpTableViewPtr.alpha = 1.0;
        if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"])) {
            m_cObjVerJumpTableViewPtr.tag=ADDLOGGERVERTICALJUMPTABLE;
            [self createVerticalJumpPicker];
        }
        else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"])){
            m_cObjVerJumpTableViewPtr.tag=ADDLOGGERSPIKESPEEDTALE;
            
            m_cObjToolBarPtr = (UIToolbar *)nil;
            m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
            m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
            m_cObjToolBarPtr.translucent = YES;
            m_cObjToolBarPtr.tintColor = nil;

            self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
            m_cObjSegementCtrlPtr = [[UISegmentedControl alloc]initWithItems:
                                     [NSArray arrayWithObjects:@"Previous",@"Next", nil]];
            m_cObjSegementCtrlPtr.segmentedControlStyle = UISegmentedControlStyleBar;
            m_cObjSegementCtrlPtr.selectedSegmentIndex = -1;
            [m_cObjSegementCtrlPtr addTarget:self action:@selector(onSegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
            m_cObjSegementCtrlPtr.momentary = YES;
            UIBarButtonItem *lObjConversionBarBtnPtr = [[UIBarButtonItem alloc]initWithCustomView:m_cObjSegementCtrlPtr];
            
            UIBarButtonItem *lObjBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onDoneButtonPressed:)];
            UIBarButtonItem *lObjFlexSpacePtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            
            
            [m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjConversionBarBtnPtr,lObjFlexSpacePtr,lObjBarButtonItem,nil]];
            SAFE_RELEASE(lObjBarButtonItem)
            SAFE_RELEASE(lObjFlexSpacePtr)
            SAFE_RELEASE(lObjConversionBarBtnPtr)
            
        }
        else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"])
        {
            
            m_cObjTimerLabelDictPtr = [[NSMutableDictionary alloc] init];
            m_cObjSprintTimerDictPtr = [[NSMutableDictionary alloc] init];
            m_cObjSprintTimeDictPtr = [[NSMutableDictionary alloc] init];
            m_cObjSprintTotalTimeDictPtr = [[NSMutableDictionary alloc] init];
            
                       
            NSInteger testattempts = -1;
            testattempts = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue]-1;
            for (int i=0; i<=testattempts; i++) {
                UILabel *lObjLabelPtr = (UILabel *)nil;
                lObjLabelPtr = [[UILabel alloc] init];
                lObjLabelPtr.tag = 270+i;
                self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
                [self.m_cObjTimerLabelDictPtr setObject:lObjLabelPtr forKey:[NSString stringWithFormat:@"%d",lObjLabelPtr.tag]];
                SAFE_RELEASE(lObjLabelPtr)
            }

            self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
            
            m_cObjInstructionLabelPtr.text = @"Record times and tap save.";
            
            m_cObjToolBarPtr = (UIToolbar *)nil;
            m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
            m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
            m_cObjToolBarPtr.translucent = YES;
            m_cObjToolBarPtr.tintColor = nil;
            
            UIBarButtonItem *lObjBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onDoneButtonPressed:)];
            UIBarButtonItem *lObjFlexSpacePtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            
            [m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjFlexSpacePtr,lObjBarButtonItem,nil]];
            SAFE_RELEASE(lObjBarButtonItem)
            SAFE_RELEASE(lObjFlexSpacePtr)
            
            m_cObjVerJumpTableViewPtr.tag=ADDLOGGERZIGZAGTABLE;
            m_cObjVerJumpTableViewPtr.backgroundColor = [UIColor clearColor];
            m_cObjVerJumpTableViewPtr.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        }
        [self.view addSubview:m_cObjVerJumpTableViewPtr];
        
    }
#else
else if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
{
    
    m_cObjScrollViewPtr = (UIScrollView *)nil;
    m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    m_cObjScrollViewPtr.scrollEnabled = YES;//sougata changes scrollenabled to yes
    m_cObjScrollViewPtr.delegate = self;
    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);//sougata changes
    m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
    [self.view addSubview:m_cObjScrollViewPtr];
    

    [self addTimerview];
    
    
    
    CGRect lRect = CGRectMake(10.0, 10.0, 300.0, 700.0);//sougata changes
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) ||
        ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) ||
        ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) ||
        ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) ||
        ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]))
    {
        m_cObjVerJumpTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];
        
        self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] &&
             [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) ||
            ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        m_cObjInstructionLabelPtr = [[UILabel alloc]init];
        m_cObjInstructionLabelPtr.frame = CGRectMake(60.0, 3.0, 240.0, 25.0);
        m_cObjInstructionLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjInstructionLabelPtr.font = [UIFont fontWithName:@"MuseoSlab-500" size:15.0];
        m_cObjInstructionLabelPtr.textColor = [UIColor whiteColor];
        m_cObjInstructionLabelPtr.shadowColor = UIColorFromRGBWithAlpha(0x000000,1.0);
        m_cObjInstructionLabelPtr.numberOfLines = 0;
        m_cObjInstructionLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjInstructionLabelPtr.text = NSLocalizedString(@"Instruction MSg", @"");
//        [self.view addSubview:m_cObjInstructionLabelPtr];
         [m_cObjScrollViewPtr addSubview:m_cObjInstructionLabelPtr];
        
        
        CGRect lRect = CGRectMake(10.0, 5.0 + CGRectGetMaxY(m_cObjInstructionLabelPtr.frame), 300.0, 130);
        //sougata changes table view height on 9/8/13
        m_cObjVerJumpTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStylePlain];
    }
    m_cObjVerJumpTableViewPtr.backgroundColor = [UIColor clearColor];
        m_cObjVerJumpTableViewPtr.backgroundView = nil;
    m_cObjVerJumpTableViewPtr.delegate = self;
    m_cObjVerJumpTableViewPtr.dataSource = self;
    m_cObjVerJumpTableViewPtr.autoresizesSubviews = YES;
    
    
    if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        m_cObjVerJumpTableViewPtr.scrollEnabled = NO;
    }
    if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]))
    {
        m_cObjVerJumpTableViewPtr.scrollEnabled = YES;
    }
    m_cObjVerJumpTableViewPtr.allowsSelectionDuringEditing = YES;
    m_cObjVerJumpTableViewPtr.alpha = 1.0;

    if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"])){
        m_cObjVerJumpTableViewPtr.tag=ADDLOGGERSPIKESPEEDTALE;
        
        m_cObjToolBarPtr = (UIToolbar *)nil;
        m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
        m_cObjToolBarPtr.translucent = YES;
        m_cObjToolBarPtr.tintColor = nil;
        
        self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        m_cObjSegementCtrlPtr = [[UISegmentedControl alloc]initWithItems:
                                 [NSArray arrayWithObjects:@"Previous",@"Next", nil]];
        m_cObjSegementCtrlPtr.segmentedControlStyle = UISegmentedControlStyleBar;
        m_cObjSegementCtrlPtr.selectedSegmentIndex = -1;
        [m_cObjSegementCtrlPtr addTarget:self action:@selector(onSegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
        m_cObjSegementCtrlPtr.momentary = YES;
        UIBarButtonItem *lObjConversionBarBtnPtr = [[UIBarButtonItem alloc]initWithCustomView:m_cObjSegementCtrlPtr];
        
        UIBarButtonItem *lObjBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onDoneButtonPressed:)];
        UIBarButtonItem *lObjFlexSpacePtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        [m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjConversionBarBtnPtr,lObjFlexSpacePtr,lObjBarButtonItem,nil]];
        SAFE_RELEASE(lObjBarButtonItem)
        SAFE_RELEASE(lObjFlexSpacePtr)
        SAFE_RELEASE(lObjConversionBarBtnPtr)
        
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        
        m_cObjTimerLabelDictPtr = [[NSMutableDictionary alloc] init];
        m_cObjSprintTimerDictPtr = [[NSMutableDictionary alloc] init];
        m_cObjSprintTimeDictPtr = [[NSMutableDictionary alloc] init];
        m_cObjSprintTotalTimeDictPtr = [[NSMutableDictionary alloc] init];
        
        
        NSInteger testattempts = -1;
        testattempts = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue]-1;
        for (int i=0; i<=testattempts; i++) {
            UILabel *lObjLabelPtr = (UILabel *)nil;
            lObjLabelPtr = [[UILabel alloc] init];
            lObjLabelPtr.tag = 270+i;
            self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
            [self.m_cObjTimerLabelDictPtr setObject:lObjLabelPtr forKey:[NSString stringWithFormat:@"%d",lObjLabelPtr.tag]];
            SAFE_RELEASE(lObjLabelPtr)
        }
        
        self.navigationItem.title = self.m_cObjTestDataPtr.m_cObjTestNamePtr;
        
        m_cObjInstructionLabelPtr.text = @"Record times and tap save.";
        
        m_cObjToolBarPtr = (UIToolbar *)nil;
        m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
        m_cObjToolBarPtr.translucent = YES;
        m_cObjToolBarPtr.tintColor = nil;
        
        UIBarButtonItem *lObjBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onDoneButtonPressed:)];
        UIBarButtonItem *lObjFlexSpacePtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [m_cObjToolBarPtr setItems:[NSArray arrayWithObjects:lObjFlexSpacePtr,lObjBarButtonItem,nil]];
        SAFE_RELEASE(lObjBarButtonItem)
        SAFE_RELEASE(lObjFlexSpacePtr)
        
        m_cObjVerJumpTableViewPtr.tag=ADDLOGGERZIGZAGTABLE;
        m_cObjVerJumpTableViewPtr.backgroundColor = [UIColor clearColor];
        m_cObjVerJumpTableViewPtr.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
//    [self.view addSubview:m_cObjVerJumpTableViewPtr];
    [m_cObjScrollViewPtr addSubview:m_cObjVerJumpTableViewPtr];
    
     //[self adjustScrool];
    
}
#endif
}
-(void)createKeyBoardToolbar
{
    m_cObjkeyboardDoneButtonViewPtr = [[UIToolbar alloc] init];
    m_cObjkeyboardDoneButtonViewPtr.barStyle = UIBarStyleBlack;
    m_cObjkeyboardDoneButtonViewPtr.translucent = YES;
    m_cObjkeyboardDoneButtonViewPtr.tintColor = nil;
    [m_cObjkeyboardDoneButtonViewPtr sizeToFit];
    
    UIBarButtonItem* lObjFlexibleSpaceBtnPtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* lObjDoneButtonPtr = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DoneBtnTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(OnKeyBoardDoneClicked)];
    
    [m_cObjkeyboardDoneButtonViewPtr setItems:[NSArray arrayWithObjects:lObjFlexibleSpaceBtnPtr,lObjDoneButtonPtr, nil]];

}
-(void)OnKeyBoardDoneClicked
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >=  7.0)
    {
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0,-70.0);
        
        
    }
    else
    {
         m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
    }
    [m_cObjMinTextField resignFirstResponder];
    [m_cObjSecTextField resignFirstResponder];
//    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
//     m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0,-70.0);
//    
    
}
//Create Picker for Inches Values 4-2-13 - start
#pragma Mark - Pickerview methods
- (void)createVerticalJumpPicker
{
    //create picker row data
    m_cObjVerticalJumpChoiceListPtr = [[NSMutableArray alloc] init];
    for(CGFloat i=0; i<=100; i+=0.5)
    {
        [self.m_cObjVerticalJumpChoiceListPtr addObject:[NSNumber numberWithFloat:i]];
    }
    // create a UIPicker view as a custom keyboard view
    UIPickerView *lObjTmpverticalJumpPicker    = [[UIPickerView alloc] init];
    self.m_cObjverticalJumpPicker = lObjTmpverticalJumpPicker;
    SAFE_RELEASE(lObjTmpverticalJumpPicker)
    [self.m_cObjverticalJumpPicker sizeToFit];
    self.m_cObjverticalJumpPicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjverticalJumpPicker.delegate = self;
    self.m_cObjverticalJumpPicker.dataSource = self;
    self.m_cObjverticalJumpPicker.showsSelectionIndicator = YES;
    
    //By Default 0th Row Will Be Selected
    [m_cObjverticalJumpPicker selectRow:0 inComponent:0 animated:YES];
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    m_cObjkeyboardDoneButtonViewPtr = [[UIToolbar alloc] init];
    m_cObjkeyboardDoneButtonViewPtr.barStyle = UIBarStyleBlack;
    m_cObjkeyboardDoneButtonViewPtr.translucent = YES;
    m_cObjkeyboardDoneButtonViewPtr.tintColor = nil;
    [m_cObjkeyboardDoneButtonViewPtr sizeToFit];
    
    
    //By Default 1st Choice will be selected
    [m_cObjverticalJumpPicker reloadAllComponents];
    
    //Segment Ctrlr
    m_cObjSegementCtrlPtr = [[UISegmentedControl alloc]initWithItems:
                             [NSArray arrayWithObjects:@"Previous",@"Next", nil]];
    m_cObjSegementCtrlPtr.segmentedControlStyle = UISegmentedControlStyleBar;
    m_cObjSegementCtrlPtr.selectedSegmentIndex = -1;
    [m_cObjSegementCtrlPtr addTarget:self action:@selector(onSegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
    m_cObjSegementCtrlPtr.momentary = YES;
    UIBarButtonItem *lObjConversionBarBtnPtr = [[UIBarButtonItem alloc]initWithCustomView:m_cObjSegementCtrlPtr];
    
    
    UIBarButtonItem* lObjFlexibleSpaceBtnPtr = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DoneBtnTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
    
    [m_cObjkeyboardDoneButtonViewPtr setItems:[NSArray arrayWithObjects:lObjConversionBarBtnPtr,lObjFlexibleSpaceBtnPtr,lObjFlexibleSpaceBtnPtr,doneButton, nil]];
    SAFE_RELEASE(lObjConversionBarBtnPtr)
    SAFE_RELEASE(lObjFlexibleSpaceBtnPtr)
    SAFE_RELEASE(doneButton)
}
//Create Picker for Inches Values 4-2-13 - end

//Creating Timer Picker for Countdown Timer for Accuracy 2-3-13 - start
-(void)showTimePicker:(id)sender
{
    if([self.m_cObjSprintTextFieldPtr isFirstResponder])
    {
        [self.m_cObjSprintTextFieldPtr resignFirstResponder];
    }
    CGRect lRect = self.view.bounds;
    
    CGRect lFrame  = m_cObjkeyboardDoneButtonViewPtr.frame;
    lFrame.origin.y =  lRect.size.height - 200.0 - lFrame.size.height;
    
    CATransition *lUpAnimation = (CATransition *)nil;
    lUpAnimation = [CATransition animation];
    [lUpAnimation setDuration:0.1];
    [lUpAnimation setType:kCATransitionPush];
    [lUpAnimation setSubtype:kCATransitionFromTop];
    [lUpAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    m_cObjTimerPickerViewPtr.frame =  CGRectMake(0,lRect.size.height - 200.0, 320, 216);
    m_cObjkeyboardDoneButtonViewPtr.frame = lFrame;
    [self.m_cObjTimerPickerViewPtr.layer addAnimation:lUpAnimation forKey:nil];
    [self.m_cObjkeyboardDoneButtonViewPtr.layer addAnimation:lUpAnimation forKey:nil];
    
    [self.view bringSubviewToFront:self.m_cObjTimerPickerViewPtr];
    m_cObjkeyboardDoneButtonViewPtr.hidden = NO;
    m_cObjTimerPickerViewPtr.hidden = NO;
    [self.m_cObjTimerPickerViewPtr selectRow:[self.m_cObjTimerArrayValuesPtr indexOfObject:m_cObjCountDownTimerValue] inComponent:0 animated:YES];
}
-(void)createTimerPicker
{
    //create picker row data
    m_cObjTimerArrayValuesPtr = [[NSMutableArray alloc] init];
    for(int i=0; i<=60; i++)
    {
        if (i>=0 && i<=9) {
            
            [self.m_cObjTimerArrayValuesPtr addObject:[NSString stringWithFormat:@"0%d",i]];
        }
        else
            [self.m_cObjTimerArrayValuesPtr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // create a UIPicker view as a custom keyboard view
    UIPickerView *lObjTmpverticalJumpPicker    = [[UIPickerView alloc] init];
    self.m_cObjTimerPickerViewPtr = lObjTmpverticalJumpPicker;
    SAFE_RELEASE(lObjTmpverticalJumpPicker)
    
    [self.m_cObjTimerPickerViewPtr sizeToFit];
    
    self.m_cObjTimerPickerViewPtr.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_cObjTimerPickerViewPtr.delegate = self;
    self.m_cObjTimerPickerViewPtr.dataSource = self;
    self.m_cObjTimerPickerViewPtr.showsSelectionIndicator = YES;
    self.m_cObjTimerPickerViewPtr.hidden = YES;
    [self.view addSubview:self.m_cObjTimerPickerViewPtr];
    [self.view bringSubviewToFront:self.m_cObjTimerPickerViewPtr];
    
    
    //By Default 0th Row Will Be Selected
    [m_cObjTimerPickerViewPtr selectRow:30 inComponent:0 animated:YES];
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    m_cObjkeyboardDoneButtonViewPtr = [[UIToolbar alloc] init];
    
    m_cObjkeyboardDoneButtonViewPtr.barStyle = UIBarStyleBlack;
    m_cObjkeyboardDoneButtonViewPtr.translucent = YES;
    m_cObjkeyboardDoneButtonViewPtr.tintColor = nil;
    [m_cObjkeyboardDoneButtonViewPtr sizeToFit];
    m_cObjkeyboardDoneButtonViewPtr.hidden = YES;
    [self.view addSubview:m_cObjkeyboardDoneButtonViewPtr];
    
    //By Default 1st Choice will be selected
    [self.m_cObjTimerPickerViewPtr reloadAllComponents];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DoneBtnTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [m_cObjkeyboardDoneButtonViewPtr setItems:[NSArray arrayWithObjects:flexBtn,doneButton, nil]];
    SAFE_RELEASE(doneButton)
    SAFE_RELEASE(flexBtn)
    
}
#pragma mark -
#pragma mark ScrollView force Scroll
-(void)scrollTableViewToCell:(UITextField *)pTextFieldPtr height:(CGFloat)pHeight
{
//    NSInteger   lTag = pTextFieldPtr.tag;
    NSInteger   lSection = 0, lRow = 0;

        
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
        {
            
            NSInteger attemptsCount = -1;
            attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
            
            
            for (int i =0; i<attemptsCount; i++) {
                if (m_cObjActiveTextFieldPtr.tag == 170+i) {
                    
                    lSection = 0;
                    lRow = i;
                    break;
                    
                }
                
            }
        }
    
    
    
    
    
    //ananymous added on 22.8.12 -start
    // to solve the payscreen scroll issue
    //    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 1750.0);
    m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0, 0, 226.0, 0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lRow inSection:lSection];
    [m_cObjVerJumpTableViewPtr selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //ananymous added on 22.8.12 -end
}

//Creating Timer Picker for Countdown Timer for Accuracy 2-3-13 - end
#pragma mark -
#pragma Picker View Delegate Methods
-(void)pickerDoneClicked:(id)pSender
{
    if(( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        [m_cObjActiveTextFieldPtr resignFirstResponder];
        m_cObjSaveButton.enabled = YES;
        

        
        [self scrollTableViewToCell:m_cObjActiveTextFieldPtr height:220];


    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"]))
    {
        m_cObjSaveButton.enabled = YES;
        if([m_cObjSprintTextFieldPtr isFirstResponder])
        {
            [m_cObjSprintTextFieldPtr resignFirstResponder];
        }
        CGRect lFrame  = m_cObjkeyboardDoneButtonViewPtr.frame;
        lFrame.origin.y =  480;
        [UIView animateWithDuration:0.2 animations:^{
            m_cObjTimerPickerViewPtr.frame = CGRectMake(0,480, 320, 216);
            m_cObjkeyboardDoneButtonViewPtr.frame = lFrame;}
                         completion:^(BOOL finished) {
                             m_cObjkeyboardDoneButtonViewPtr.hidden = YES;
                             m_cObjTimerPickerViewPtr.hidden = YES;}];
        
    }
     
}
#pragma mark - Picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"MPH"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"])  || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"])) {
        
        return 1;
    }
    else if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        return 2;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"MPH"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"])|| ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"])) {
        
        return [self.m_cObjVerticalJumpChoiceListPtr count];
    }
    else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        if (component == 0) {
            return [self.m_cObjTimerArrayValuesPtr count];
        }
        else{
            return 1;
        }
    }
    return 0;
}
- (void)pickerView:(UIPickerView *)pickerview didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"])|| ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        m_cObjActiveTextFieldPtr.text = [NSString stringWithFormat:@"%@ Inches",[self.m_cObjVerticalJumpChoiceListPtr objectAtIndex:row]];
    }
    else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"]){
        if (component == 0) {
            self.m_cObjCountDownTimerValue = [self.m_cObjTimerArrayValuesPtr objectAtIndex:row];
            m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
            m_cObjSprintTimeLabelPtr.numberOfLines =2;
            m_cObjSprintTimerBtnPtr.userInteractionEnabled = YES;
            m_cObjSprintClearBtnPtr.userInteractionEnabled = YES;
            [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor orangeColor]];
        }
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45.0;
}
- (NSString *)pickerView:(UIPickerView *)pickerview titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        NSString	*lObjTitlePtr = (NSString *)nil;
        lObjTitlePtr = (NSString *)[NSString stringWithFormat:@"%@",[self.m_cObjVerticalJumpChoiceListPtr objectAtIndex:row]];
        return  lObjTitlePtr;
    }
    else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        if (component == 0) {
            NSString	*lObjTitlePtr = (NSString *)nil;
            lObjTitlePtr = (NSString *)[NSString stringWithFormat:@"%@",[self.m_cObjTimerArrayValuesPtr objectAtIndex:row]];
            return  lObjTitlePtr;
        }
        else{
            return @"secs";
        }
    }
    return nil;
	
}

-(void)onDoneButtonPressed:(id)sender
{
    if(m_cObjActiveTextFieldPtr != (UITextField *)nil)
    {
        [m_cObjActiveTextFieldPtr resignFirstResponder];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=  7.0)
        {
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
             m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0,-70.0);
            
            
        }
        else
        {
            [self scrollTableViewToCell:m_cObjActiveTextFieldPtr height:220];
        }

    }
}
//Timer Button For Accuracy and all the Timers 2-3-13 - start
-(void)onTimerButtonPressed : (id)sender
{
    UIButton *lObjButton = (UIButton *)sender;
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"])) {
        
        UIButton *lButtonPtr = (UIButton *)nil;
        UIButton *lObjClearBtnPtr = (UIButton *)nil;
        UILabel *lObjTimeLabelPtr = (UILabel *)nil;
        UILabel *lObjTotalLabelPtr = (UILabel *)nil;
        NSString *lObjStringMiliPtr = (NSString *)nil;
        NSString *lObjStringMinPtr = (NSString *)nil;
        
        NSString *lObjColonSepStringPtr = (NSString *)nil;
        NSArray *lObjDotSepArrayPtr = (NSArray *)nil;
        NSArray *lObjColonSepArrayPtr = (NSArray *)nil;
        
        NSInteger lMinsVal = 0;
        NSInteger lSecsVal = 0;
        NSInteger lTotalTime = 0;
        lButtonPtr = (UIButton *)sender;
//        if(lButtonPtr.tag == 21)
//        {
                   
            NSInteger testattempts = -1;
            testattempts = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
            for (int i=0;i<testattempts;i++)
            {
                lObjClearBtnPtr = (UIButton *)[self.view viewWithTag:24+i*10];
                lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:22+i*10];
                lObjTotalLabelPtr = (UILabel *)[self.view viewWithTag:23+i*10];

                NSLog(@"Button tag %d",lObjButton.tag);
                if(lObjButton.tag == 21+i*10 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Start", @"")])
                {
                    
                    [lObjButton setBackgroundColor:[UIColor blueColor]];
                    [lObjButton setTitle:NSLocalizedString(@"Stop", @"") forState:UIControlStateNormal];
                    
                    lObjClearBtnPtr.userInteractionEnabled = NO;
                    m_cObjSaveButton.enabled = NO;
                    
                    NSDate* sourceDate = [[NSDate date]retain];
                    
                    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
                    
                    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
                    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
                    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
                    
                    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
                    
                    
                    gObjAppDelegatePtr.m_cObjSprintStartTimePtr = destinationDate;

                    NSString *buttontagptr = [NSString stringWithFormat:@"%d",21+i*10];
                   
                    if (gObjAppDelegatePtr.m_cObjSprintStartTimeDictPtr.count > 0) {
                        NSArray *keys = [gObjAppDelegatePtr.m_cObjSprintStartTimeDictPtr allKeys];
                        for (int i=0; i<keys.count; i++) {
                            if ([buttontagptr isEqualToString:[keys objectAtIndex:i]]) {
                                [gObjAppDelegatePtr.m_cObjSprintStartTimeDictPtr removeObjectForKey:buttontagptr];
                                [self.m_cObjSprintTimerDictPtr removeObjectForKey:buttontagptr];
                                [self.m_cObjTimerLabelDictPtr removeObjectForKey:buttontagptr];
                            }
                        }
                    }
                    
                   [gObjAppDelegatePtr.m_cObjSprintStartTimeDictPtr setObject:gObjAppDelegatePtr.m_cObjSprintStartTimePtr forKey:buttontagptr];

                    self.m_cObjSprintTimeLabel = lObjTimeLabelPtr;
                    
                    m_cObjSprintTimerPtr = [NSTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(updateSprintTimer:) userInfo:self.m_cObjSprintTimeLabel repeats:YES];
                    
                    
                    [self.m_cObjSprintTimerDictPtr setObject:m_cObjSprintTimerPtr forKey:buttontagptr];
                    
                    
                    [self.m_cObjTimerLabelDictPtr setObject:self.m_cObjSprintTimeLabel forKey:buttontagptr];
                    
                    
                    lObjTotalLabelPtr.text =@"00.00 secs";
                    
                    
                    SAFE_RELEASE(sourceDate)
                }
                else if(lObjButton.tag == 21+i*10 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")])
                {
                    [lObjButton setBackgroundColor:[UIColor orangeColor]];
                    [lObjButton setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
                    
                    //invalidate the timer
                    m_cObjSprintTimerPtr = [self.m_cObjSprintTimerDictPtr objectForKey:[NSString stringWithFormat:@"%d",lObjButton.tag]];
                    
                    if((NSTimer *)nil != m_cObjSprintTimerPtr)
                    {
                        [m_cObjSprintTimerPtr invalidate];
                        m_cObjSprintTimerPtr = (NSTimer *)nil;
                    }
                    
                    
                    lObjClearBtnPtr.userInteractionEnabled = YES;
                    m_cObjSaveButton.enabled = YES;
                    isValidationFailed = NO;
                    
                    
                    lObjDotSepArrayPtr = [self.m_cObjSprintTimePtr componentsSeparatedByString:@"."];

                    lObjStringMiliPtr = [lObjDotSepArrayPtr objectAtIndex:1];
                    
                    lObjColonSepStringPtr = [lObjDotSepArrayPtr objectAtIndex:0];
                    lObjColonSepArrayPtr = [lObjColonSepStringPtr componentsSeparatedByString:@":"];
                    lObjStringMinPtr = [lObjColonSepArrayPtr objectAtIndex:0];
                    lMinsVal = [lObjStringMinPtr integerValue]*60;
                    lSecsVal = [[lObjColonSepArrayPtr objectAtIndex:1]integerValue];
                    lTotalTime = lMinsVal + lSecsVal;
                    
                    self.m_cObjSprintTotalTimePtr = [NSString stringWithFormat:@"%d.%@",lTotalTime,lObjStringMiliPtr];
                    NSString *buttontagptr = [NSString stringWithFormat:@"%d",lObjButton.tag];
                    
                    if (m_cObjSprintTotalTimeDictPtr.count > 0) {
                        NSArray *keys = [m_cObjSprintTotalTimeDictPtr allKeys];
                        for (int i=0; i<keys.count; i++) {
                            if ([buttontagptr isEqualToString:[keys objectAtIndex:i]]) {
                                [m_cObjSprintTotalTimeDictPtr removeObjectForKey:buttontagptr];
                              
                            }
                        }
                    }
                    [m_cObjSprintTotalTimeDictPtr setObject:self.m_cObjSprintTotalTimePtr forKey:buttontagptr];
                    
                }
            }
    }
    if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        if([m_cObjSprintTimerBtnPtr.titleLabel.text isEqualToString:NSLocalizedString(@"Start", @"")])
        {
            if ((NSString *)nil == self.m_cObjCountDownTimerValue || [self.m_cObjCountDownTimerValue isEqualToString:@""] || [self.m_cObjCountDownTimerValue isEqualToString:@" "] || [self.m_cObjCountDownTimerValue isEqualToString:@"00"] || [self.m_cObjCountDownTimerValue isEqualToString:@"0"])
            {
                UIAlertView *lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Please select timer value greater than zero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [lObjAlertViewPtr show];
                SAFE_RELEASE(lObjAlertViewPtr)
            }
            else
            {
                [self.m_cObjTimerPickerViewPtr endEditing:YES];
                m_cObjScrollViewPtr.scrollEnabled = NO;
                m_cObjeditTimerButtonPtr.userInteractionEnabled = NO;
                self.m_cObjTimerPickerViewPtr.hidden = YES;
                m_cObjkeyboardDoneButtonViewPtr.hidden = YES;
                m_cObjSprintTextFieldPtr.userInteractionEnabled = NO;
                [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor blueColor]];
                m_cObjSprintClearBtnPtr.userInteractionEnabled = YES;
                m_cObjSprintTimerBtnPtr.userInteractionEnabled = NO;
                m_cObjSaveButton.enabled = NO;
                NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alarm_clock_ringing" ofType:@"wav"];
                AVAudioPlayer *lObjAudioPlayer = (AVAudioPlayer *)nil;
                lObjAudioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath: soundPath] error:nil];
                self.m_cObjAlarmSoundPtr = lObjAudioPlayer;
                SAFE_RELEASE(lObjAudioPlayer)
                self.m_cObjAlarmSoundPtr.volume = 5.0;
                self.m_cObjAlarmSoundPtr.delegate = self;
                [self.m_cObjAlarmSoundPtr prepareToPlay];
                
                m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
                
                NSDate  *startDate = [[NSDate date]retain];
                //to get the destination date in milliseconds 4-1-13
                NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
                [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
                [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.00]];
                //to get the destination date in milliseconds 4-1-13
                
                
                NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
                
                NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:startDate];
                NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:startDate];
                NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
                NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:startDate] autorelease];
                
                
                gObjAppDelegatePtr.m_cObjSprintStartTimePtr = destinationDate;
                
                m_cObjSprintTimerPtr = [NSTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(updateSprintTimer:) userInfo:nil repeats:YES];
                SAFE_RELEASE(startDate)
                SAFE_RELEASE(lObjDateFormatterPtr)
            }
        }
    }
}

-(void)updateSprintTimer : (id)sender
{
     
    UILabel *userLabel = (UILabel *)[sender userInfo];
    
    
    if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        
        NSDate* sourceDate = [NSDate date];
        NSDate *lObjCurrentDateStr = (NSDate *)nil;
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"mm:ss.SS"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.00]];
        NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
       
        
        
        NSDate *lObjstrt= gObjAppDelegatePtr.m_cObjSprintStartTimePtr;
         
        
        NSInteger lObjCountDowntime = [self.m_cObjCountDownTimerValue intValue];
        NSTimeInterval totalCountdownInterval = lObjCountDowntime;
        NSTimeInterval elapsedTime = [destinationDate timeIntervalSinceDate:lObjstrt];
        NSTimeInterval remainingTime = totalCountdownInterval - elapsedTime;
        
        NSDate *lObjTimerDatePtr = [NSDate dateWithTimeIntervalSince1970:remainingTime];
        NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
        [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
        [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.00]];
        NSString *lObjTimeStringPtr=[lObjDateFormatterPtr stringFromDate:lObjTimerDatePtr];
        self.m_cObjSprintTimerValuePtr = [NSString stringWithFormat:@"%@ secs",lObjTimeStringPtr];
        m_cObjSprintTimeLabelPtr.text = self.m_cObjSprintTimerValuePtr;
        SAFE_RELEASE(lObjDateFormatterPtr)
        
        
        if([lObjTimeStringPtr isEqualToString:@"00:00.00"] || remainingTime == 0)
        {
            [m_cObjSprintTimerPtr invalidate];
            m_cObjSprintTimerPtr = (NSTimer *)nil;
            m_cObjSprintTimeLabelPtr.text = @"00:00.00 secs";
            
            m_cObjSprintTimerBtnPtr.userInteractionEnabled = NO;
            m_cObjSprintClearBtnPtr.userInteractionEnabled = YES;
            //           [m_cObjSprintTimerBtnPtr setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
            //            [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor grayColor]];
            m_cObjSaveButton.enabled = YES;
            m_cObjSprintTextFieldPtr.userInteractionEnabled = YES;
            [m_cObjSprintTextFieldPtr becomeFirstResponder];
            m_cObjeditTimerButtonPtr.userInteractionEnabled = YES;
            [self.m_cObjAlarmSoundPtr play];
            
            UIAlertView *lObjAlertViewPtr =(UIAlertView *)nil;
            lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Timer Done" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            lObjAlertViewPtr.tag = 1001;
            [lObjAlertViewPtr show];
            SAFE_RELEASE(lObjAlertViewPtr)
            SAFE_RELEASE(lObjCurrentDateStr)
            SAFE_RELEASE(lObjDateFormatterPtr)
            
        }
    }
    if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        NSDate* sourceDate = [NSDate date];
        NSDate *lObjCurrentDateStr = (NSDate *)nil;
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
        
        lObjCurrentDateStr = [destinationDate retain];
        
        NSInteger attemptsCount = -1;
        attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
//        NSDate *lObjstrt= gObjAppDelegatePtr.m_cObjSprintStartTimePtr;
        NSString *lObjLabelTag = [NSString stringWithFormat:@"%d",userLabel.tag-1];
        NSDate *lObjstrt= [gObjAppDelegatePtr.m_cObjSprintStartTimeDictPtr objectForKey:lObjLabelTag];
        
        NSTimeInterval lTimeInterval = [lObjCurrentDateStr timeIntervalSinceDate:lObjstrt];
        NSDate *lObjTimerDatePtr = [NSDate dateWithTimeIntervalSince1970:lTimeInterval];
        NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
        [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
        [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        self.m_cObjSprintTimePtr=[lObjDateFormatterPtr stringFromDate:lObjTimerDatePtr];
        self.m_cObjSprintTimerValuePtr = [NSString stringWithFormat:@"%@ secs",self.m_cObjSprintTimePtr];
        
        self.m_cObjSprintTimeLabel = [self.m_cObjTimerLabelDictPtr objectForKey:lObjLabelTag];
        self.m_cObjSprintTimeLabel.text = self.m_cObjSprintTimerValuePtr;
        
        SAFE_RELEASE(lObjCurrentDateStr)
        SAFE_RELEASE(lObjDateFormatterPtr)
    }
}
//Timer Button For Accuracy and all the Timers 2-3-13 - end
-(void)onClearButtonClicked : (id)sender
{
   
   if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        if([m_cObjSprintClearBtnPtr.titleLabel.text isEqualToString:NSLocalizedString(@"Reset", @"")])
        {
            if ((NSTimer *)nil != m_cObjSprintTimerPtr) {
                [m_cObjSprintTimerPtr invalidate];
                m_cObjSprintTimerPtr = (NSTimer *)nil;
            }
            m_cObjSprintTextFieldPtr.userInteractionEnabled = YES;
            m_cObjSprintTimerBtnPtr.userInteractionEnabled = YES;
            m_cObjeditTimerButtonPtr.userInteractionEnabled = YES;
            m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
            self.m_cObjSprintTimerValuePtr = @"00:00.00 secs";
            m_cObjSaveButton.enabled = NO;
            isValidationFailed = YES;
            [m_cObjSprintTimerBtnPtr setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
            [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor orangeColor]];
        }
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        UIButton *lObjButtonPtr = (UIButton *)nil;
        UILabel *lObjTimeLabelPtr = (UILabel *)nil;
        lObjButtonPtr = (UIButton *)sender;
        
        NSInteger testattempts = -1;
        testattempts = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
        for (int i=0; i < testattempts; i++) {
            if(lObjButtonPtr.tag == 24+i*10)
            {
                lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:22+i*10];
                
                lObjTimeLabelPtr.text = @"00:00.00 secs";
                m_cObjSprintTimerValuePtr = @"00:00.00 secs";
                
                self.m_cObjSprintTotalTimePtr = @"00.00";
                
            }
        }
        m_cObjSaveButton.enabled = NO;
    }
}
#pragma mark - TableView Delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    m_cRowCount=0;
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]))
    {
        NSInteger rowCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        m_cRowCount=rowCount;
        [self adjustFrame:(m_cRowCount*90)];

        return rowCount;
    }
    else if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] &&
              [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) ||
             ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        NSInteger rowCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];

        m_cRowCount=rowCount;
        [self adjustFrame:(rowCount*150)];

        return rowCount;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]))
    {
        m_cHeightofRow=70;
        return 70.0;
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        m_cHeightofRow=130;
            return 130;
    }
    return 0.0;
}

-(void)adjustFrame:(float)tableHeight
{
    NSLog(@"%f heighy",tableHeight);
    m_cObjVerJumpTableViewPtr.frame=CGRectMake(10.0, 5.0 + CGRectGetMaxY(m_cObjInstructionLabelPtr.frame), 300.0, tableHeight);
     m_cObjTimerView.frame=CGRectMake((CGRectGetMinX(self.view.bounds)+10), (CGRectGetHeight(m_cObjVerJumpTableViewPtr.frame)+20), 300, 300);
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *lObjLabelPtr = (UILabel *)nil;

    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        lObjCellPtr.accessoryView = (UIView *)nil;

        lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = [NSString stringWithFormat:@"%@ Trial%d",self.m_cObjTestDataPtr.m_cObjTestNamePtr,indexPath.row+1];
        lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
        [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
        lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
        lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = [NSString stringWithFormat:@"%@%d",self.m_cObjTestDataPtr.m_cObjTestNamePtr,indexPath.row+1];
        
        if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"] || [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"])
        {
            
            lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"])){

            lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeNumberPad;
        }

        if(lObjCellPtr.m_cObjAthleteTextFieldPtr.text.length == 0)
        {
            IsTextFieldActive = NO;
        }
        else
            IsTextFieldActive = YES;
        lObjLabelPtr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 14)];
        if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) {
             lObjLabelPtr.text = @"MPH";
        }

        [lObjLabelPtr setTextColor:[UIColor blackColor]];
        lObjCellPtr.accessoryView = lObjLabelPtr;
        SAFE_RELEASE(lObjLabelPtr)
        if(IsTextFieldActive == NO)
        {
            lObjCellPtr.accessoryView.hidden = YES;
        }
        else if(IsTextFieldActive == YES)
        {
            lObjCellPtr.accessoryView.hidden = NO;
        }
        lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjToolBarPtr;
        lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = 170+indexPath.row;
        [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
        lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
        
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
        
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        static NSString *lObjIdentifierPtr = @"AddLoggerTableViewCell";
        AddZigZagLogTableViewCell *lObjCellPtr = (AddZigZagLogTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjIdentifierPtr];
        if ((AddZigZagLogTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddZigZagLogTableViewCell alloc] initWithStyle :UITableViewCellStyleDefault reuseIdentifier:lObjIdentifierPtr  tag:indexPath.row]autorelease];
        }
        lObjCellPtr.accessoryView = (UIView *)nil;
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;

        lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 20+indexPath.row*10;
//        lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"ZIGZAG1", @"");
        lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = [NSString stringWithFormat:@"%@ %d",self.m_cObjTestDataPtr.m_cObjTestNamePtr,indexPath.row+1];
        
        UILabel *lObjLabelPtr = (UILabel *)nil;
        lObjLabelPtr = [self.m_cObjTimerLabelDictPtr objectForKey:[NSString stringWithFormat:@"%d",270+indexPath.row]];
        
        
        if ((NSString *)nil != lObjLabelPtr.text) {
            lObjCellPtr.m_cObjSprintTimeLabelPtr.text = lObjLabelPtr.text;
        }
        
        
        lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 22+indexPath.row*10;
        
        lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 21+indexPath.row*10;
        lObjCellPtr.m_cObjSprintTextFieldPtr.inputAccessoryView=m_cObjToolBarPtr;
        [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        lObjCellPtr.m_cObjSprintClearBtnPtr.tag=24+indexPath.row*10;
        [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return lObjCellPtr;
    }
    return nil;
}

#pragma mark - Segment delegates
- (void)onSegmentBtnClicked:(id)pObjSenderPtr
{
    UISegmentedControl  *lObjSegmentCtrlPtr = (UISegmentedControl *)nil;
    lObjSegmentCtrlPtr = (UISegmentedControl *)pObjSenderPtr;
    UITextField *lObjTextFieldPtr = (UITextField *)nil;
    
    NSInteger attemptsCount = -1;
    attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
    
    switch (lObjSegmentCtrlPtr.selectedSegmentIndex)
    {
        case 0:
        {

        if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
            {
                int j= 170+attemptsCount-1;
                int i=j;
                for (i = j; i>=170; i--) {
                    if(m_cObjActiveTextFieldPtr.tag == i)
                    {
                        [m_cObjActiveTextFieldPtr resignFirstResponder];
                        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:i-1];
                        [lObjTextFieldPtr becomeFirstResponder];
                        lObjTextFieldPtr = (UITextField *)nil;
                        break;
                    }
                }
                
            }
        }
        break;
            case 1:
        {
            if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
            {
                for (int i=170; i<=170+attemptsCount-1; i++) {
                    if(m_cObjActiveTextFieldPtr.tag == i)
                    {
                        [m_cObjActiveTextFieldPtr resignFirstResponder];
                        
                        lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:i+1];
                        [lObjTextFieldPtr becomeFirstResponder];
                        lObjTextFieldPtr = (UITextField *)nil;
                        break;
                    }
                }
            }

            
        }
       break;
            default:
            break;
    }
}

#pragma mark - Keyboard Notifications
- (void)keyBoardWillShow:(NSNotification *)pObjNotificationPtr
{
    
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        
        NSInteger attemptsCount = -1;
        attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
        
        for (int i =0; i<attemptsCount; i++) {
            if (m_cObjActiveTextFieldPtr.tag == 170+i)
            {
                if ([[[UIDevice currentDevice]systemVersion]floatValue ]>= 7.0)
                {
                    if (attemptsCount == 1)
                    {
                        
                    }
                    else
                    {
                        if (i==0)
                        {
                            
                        }
                        else
                        {
                            CGFloat lOffset = 40.0*i;
                            
                            CGPoint scrollPoint = CGPointMake(0.0, lOffset);
                            m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, (m_cRowCount+2)*100);//sougata changes
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:1.0];
                            [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
                            [UIView commitAnimations];

                        }
                    }
                    

                    
                }
                else
                {
                    CGFloat lOffset = 70.0*i;
                    
                    CGPoint scrollPoint = CGPointMake(0.0, lOffset);
                    m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, (m_cRowCount+2)*100);//sougata changes
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1.0];
                    [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
                    [UIView commitAnimations];

                }
                
            }
            
        }
    }
    if (m_cObjActiveTextFieldPtr.tag == MIN_TXTFIELD_TAG)
    {
        CGFloat lOffset;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=  7.0)
        {
            if ([self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue] > 1)
            {
                lOffset = 75.0 * [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
                
            }
            else
            {
                lOffset = 40.0f;
                
            }
 
        }
        else
        {
            
            if ([self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue] > 1)
            {
                lOffset = 100.0 * [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
                
            }
            else
            {
                lOffset = 100.0f;
                
            }

            
        }
       
        
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
         m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, (m_cRowCount+4)*100);


        
    }
}
- (void)keyBoardWillHide : (NSNotification *)pObjNotificationPtr
{

    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]))
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue ]>= 7.0)
        {
            
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsZero;
            m_cObjVerJumpTableViewPtr.scrollIndicatorInsets = UIEdgeInsetsZero;
            m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, (m_cRowCount+2)*100);//sougata changes
            m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
            [UIView commitAnimations];
        }
        
        
    }
}
#pragma mark - Textfield delegate methods




-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_cObjActiveTextFieldPtr = textField;
    if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"]) {
        
        m_cObjScrollViewPtr.scrollEnabled = YES;
        CGFloat lOffset = 150.0;
        CGPoint scrollPoint = CGPointMake(0.0, lOffset);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [m_cObjScrollViewPtr setContentOffset:scrollPoint animated:YES];
        [UIView commitAnimations];
        CGRect lRect = self.view.bounds;
        CGRect lFrame  = m_cObjkeyboardDoneButtonViewPtr.frame;
        lFrame.origin.y =  lRect.size.height - 215.0 - lFrame.size.height;
        CATransition *lUpAnimation = (CATransition *)nil;
        lUpAnimation = [CATransition animation];
        [lUpAnimation setDuration:0.3];
        [lUpAnimation setType:kCATransitionPush];
        [lUpAnimation setSubtype:kCATransitionFromTop];
        [lUpAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        m_cObjkeyboardDoneButtonViewPtr.frame = lFrame;
        [self.m_cObjkeyboardDoneButtonViewPtr.layer addAnimation:lUpAnimation forKey:nil];m_cObjkeyboardDoneButtonViewPtr.hidden = NO;
    }
    }

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || (( [self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"])))
    {
        NSInteger attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        if(textField.tag == 170 + attemptsCount-1)
        {
            [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
            [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:1];
        }
        else if (textField.tag == 170)
        {
            [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:0];
            [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
        }
        else if (textField.tag > 170 && textField.tag < 170+attemptsCount-1)
        {
            [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
            [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
        }
    }
   
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if(m_cObjActiveTextFieldPtr.tag == MIN_TXTFIELD_TAG)
    {
        if ([string intValue] <= 0)
        {
            NSLog(@"%@",string);
            NSLog(@"%d",[string intValue] );
            m_cObjStartButton.enabled = NO;
        }
        else
            NSLog(@"%@",string);
            m_cObjStartButton.enabled = YES;
    }
    


    
   else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"MPH"])
    {
               AddAthleteDetailsTableViewCell *lObjCellPtr = (AddAthleteDetailsTableViewCell *)[[textField superview]superview];
        if(textField.text.length == 0)
        {
            lObjCellPtr.accessoryView.hidden = NO;
            IsTextFieldActive = YES;
        }
        else if(textField.text.length == 1 && [string isEqualToString:@""])
        {
            lObjCellPtr.accessoryView.hidden = YES;
            IsTextFieldActive = NO;
        }
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        if(textField.text.length > 0)
            m_cObjSaveButton.enabled = YES;
    }
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (YES == isServerTransactionSucceed)
    {
        [self onBackButtonClicked:nil];
    }
    if (alertView.tag == 1001)
    {
        if (self.m_cObjAlarmSoundPtr != nil)
        {
            [self.m_cObjAlarmSoundPtr stop];
            self.m_cObjAlarmSoundPtr = (AVAudioPlayer *)nil;
        }

    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
    for (int i=70; i<70+attemptsCount-1; i++) {
        if(m_cObjActiveTextFieldPtr.tag == i)
        {
            [m_cObjActiveTextFieldPtr resignFirstResponder];
            m_cObjActiveTextFieldPtr = (UITextField *)nil;
            m_cObjActiveTextFieldPtr = (UITextField *)[self.view viewWithTag:i+1];
            [m_cObjActiveTextFieldPtr becomeFirstResponder];
        }
        
    }
    [textField resignFirstResponder];
    m_cObjStartButton.enabled=YES;
   

   return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"]) {
        m_cObjScrollViewPtr.scrollEnabled = NO;
     m_cObjScrollViewPtr.userInteractionEnabled=YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        m_cObjkeyboardDoneButtonViewPtr.hidden = YES;
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320, m_cRowCount*30);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
        [UIView commitAnimations];
    }
}

-(void)onSaveButtonClicked : (id)sender
{
    UITextField *lObjTextField = (UITextField *)nil;

    CGFloat firstScore = 0.0;
    NSInteger integerfirstScore = -1;
    
    
    if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Inches"] ||[self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"feet"]))
    {
        if([m_cObjActiveTextFieldPtr isFirstResponder])
        {
            [m_cObjActiveTextFieldPtr resignFirstResponder];
        }
        NSInteger  attemptsCount = -1;
        attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
        for (int i=170; i <=170+attemptsCount-1; i++)
        {

            lObjTextField = (UITextField *)[self.view viewWithTag:i];
            if (lObjTextField.text.length <= 0) {
                isValidationFailed = YES;
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Please Enter All Trial Values" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [lObjAlertViewPtr show];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                SAFE_RELEASE(lObjAlertViewPtr)
                break;
             }
            else
            {
                isValidationFailed = NO;
            }
        }
            if (NO == isValidationFailed)
            {
                NSMutableArray *lObjcapturedValuesPtr = (NSMutableArray *)nil;
                lObjcapturedValuesPtr = [[NSMutableArray alloc] init];
                
                for (int i=170 ; i<=170+attemptsCount-1 ;i++) {
                    lObjTextField = (UITextField *)[self.view viewWithTag:i];
                    if (lObjTextField.text.length > 0) {
                        
                        firstScore = [lObjTextField.text floatValue];
                        
                        [lObjcapturedValuesPtr addObject:[NSNumber numberWithFloat:firstScore]];
                    }
                }
                
                
                float highest = 0.0;
                float myInches=0.0;
                highest = [[lObjcapturedValuesPtr valueForKeyPath:@"@max.floatValue"] floatValue];
                highest =  roundf (highest * 100) / 100.0;
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"feet"])
                   {
                       float totalHeight = highest;
                       int myFeet = (int) totalHeight;
                        myInches = (totalHeight - myFeet) * 12;
                       
                   }
                
                
                SAFE_RELEASE(lObjcapturedValuesPtr)
                
                if([self.m_cObjAthleteDetailsDataPtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0)
                {
                   
                        self.m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                        isAddedinOfflineMode = YES;
                    if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"feet"])
                    {
                        self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",myInches];
                        self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",myInches];
                    }
                    else
                    {
                        self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                        self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                    }
                        [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                }
                else{
                    
                    isAddedinOfflineMode = NO;
                    if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    
                        if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"feet"])
                        {
                            self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",myInches];
                            self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",myInches];
                        }
                        else
                        {
                            self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                            self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                        }

                        [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                        self.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cAthleteId;
                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :self.m_cObjAthletelogPtr Tests:self.m_cObjTestDataPtr];
                    }
                    else{
                        
                        self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                        self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                        [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                    }
                }
         }
    }
    else if (([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"MPH"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Numbers"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Repetitions"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Counting"]))
    {
        
        if([m_cObjActiveTextFieldPtr isFirstResponder])
        {
            [m_cObjActiveTextFieldPtr resignFirstResponder];
        }

      NSInteger  attemptsCount = -1;
      attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
            
        for (int i=170; i <=170+attemptsCount-1; i++) {
            
            lObjTextField = (UITextField *)[self.view viewWithTag:i];
            if (lObjTextField.text.length <= 0) {
                isValidationFailed = YES;
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Please Enter All Trial Values" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [lObjAlertViewPtr show];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                SAFE_RELEASE(lObjAlertViewPtr)
                break;
            }
            else
            {
                isValidationFailed = NO;
            }
        }
        if (NO == isValidationFailed) {
            NSMutableArray *lObjcapturedValuesPtr = (NSMutableArray *)nil;
            lObjcapturedValuesPtr = [[NSMutableArray alloc] init];
            
            for (int i=170 ; i<=170+attemptsCount-1 ;i++) {
                lObjTextField = (UITextField *)[self.view viewWithTag:i];
                if (lObjTextField.text.length > 0) {

                    if ([self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer"]){
                        integerfirstScore = [lObjTextField.text integerValue];
                        [lObjcapturedValuesPtr addObject:[NSNumber numberWithInteger:integerfirstScore]];
                    }
                    else{
                        firstScore = [lObjTextField.text floatValue];
                        [lObjcapturedValuesPtr addObject:[NSNumber numberWithFloat:firstScore]];
                    }
                }
            }
            
            if ([self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer"]){

                NSInteger highest = -1;
                highest = [[lObjcapturedValuesPtr valueForKeyPath:@"@max.integerValue"] integerValue];

                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    
                    self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%d",highest];
                    self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%d",highest];
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    self.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cAthleteId;
                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :self.m_cObjAthletelogPtr Tests:self.m_cObjTestDataPtr];
                }
                else{
                    
                    m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                    [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                }
            }
            else{
                float highest = 0.0;
                highest = [[lObjcapturedValuesPtr valueForKeyPath:@"@max.floatValue"] floatValue];
                highest =  roundf (highest * 100) / 100.0;
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                
                SAFE_RELEASE(lObjcapturedValuesPtr)
                
                if([self.m_cObjAthleteDetailsDataPtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0)
                {
                    isAddedinOfflineMode = YES;
                    self.m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                    self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                    self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                    [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                }
                else{
                
                    isAddedinOfflineMode = NO;
                    if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                        
                        self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                        self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                        [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                        self.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cAthleteId;
                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :self.m_cObjAthletelogPtr Tests:self.m_cObjTestDataPtr];
                    }
                    else{
                        
                        self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                        self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                        [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                    }
                }
            }
        }
    }
    else if(([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"]) || ([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"Timer"]))
    {
        UILabel *lObjTemp1StringPtr = (UILabel *)nil;

        
        NSInteger attemptsCount = -1;
        attemptsCount = [self.m_cObjTestDataPtr.m_cObjTestAttemptsPtr integerValue];
        
        for (int i=0; i <attemptsCount; i++) {
            
             UIButton *lObjButtonPtr = (UIButton *)[self.view viewWithTag:21+i*10];
             lObjTemp1StringPtr = (UILabel *)[self.view viewWithTag:22+i*10];            
            
            if ([lObjTemp1StringPtr.text isEqualToString:@"00:00.00 secs"]  || [lObjButtonPtr.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")]) {
                isValidationFailed = YES;
                UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:[NSString stringWithFormat:@"Please check the Timer Status for %d Trials",attemptsCount] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [lObjAlertViewPtr show];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                SAFE_RELEASE(lObjAlertViewPtr)
                break;
            }
            else
            {
                isValidationFailed = NO;
            }
        }
        if (NO == isValidationFailed) {
            NSMutableArray *lObjcapturedValuesPtr = (NSMutableArray *)nil;
            lObjcapturedValuesPtr = [[NSMutableArray alloc] init];
            
            for (int i=0 ; i<attemptsCount ;i++) {
                
                NSString *key = [NSString stringWithFormat:@"%d",21+i*10];
                NSString *value = [m_cObjSprintTotalTimeDictPtr objectForKey:key];
                firstScore = [value floatValue];
                [lObjcapturedValuesPtr addObject:[NSNumber numberWithFloat:firstScore]];
                
            }
            
            float highest = 0.0;
            highest = [[lObjcapturedValuesPtr valueForKeyPath:@"@min.floatValue"] floatValue];
            highest =  roundf (highest * 100) / 100.0;            
            gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
            
            SAFE_RELEASE(lObjcapturedValuesPtr)
            
            if([self.m_cObjAthleteDetailsDataPtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0)
            {
                isAddedinOfflineMode = YES;
                m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
            }
            else{
            
                isAddedinOfflineMode = NO;
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    
                    self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                    self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    self.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cAthleteId;
                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :self.m_cObjAthletelogPtr Tests:self.m_cObjTestDataPtr];
                }
                else{
                    
                    self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%.03f",highest];
                    self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%.03f",highest];
                    m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                    [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                }
            }
        }
    }
    else if([self.m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [self.m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
        [m_cObjSprintTextFieldPtr resignFirstResponder];
        if(m_cObjSprintTextFieldPtr.text.length <= 0)
        {
            isValidationFailed = YES;
            UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
            lObjAlertViewPtr = [[UIAlertView alloc]
                                initWithTitle:@"Athlete Logger"
                                message:@"Please enter Accuracy"
                                delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil,
                                nil];
            [lObjAlertViewPtr show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            SAFE_RELEASE(lObjAlertViewPtr)
        }
       else
        {
                isValidationFailed = NO;
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
            
            if([self.m_cObjAthleteDetailsDataPtr.m_cAthleteId rangeOfString:@"ABCSFTXYZ_"].length > 0)
            {
                isAddedinOfflineMode = YES;
                self.m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%@",m_cObjSprintTextFieldPtr.text];
                self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%@",m_cObjSprintTextFieldPtr.text];
                [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
            }
            else{
            
                isAddedinOfflineMode = NO;
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    
                    self.m_cObjAthletelogPtr.m_cObjTestResultPtr = m_cObjSprintTextFieldPtr.text;
                    self.m_cObjTestDataPtr.m_cObjTestResultsPtr = m_cObjSprintTextFieldPtr.text;
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    self.m_cObjAthletelogPtr.m_cObjAthleteIdPtr = self.m_cAthleteId;
                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog :self.m_cObjAthletelogPtr Tests:self.m_cObjTestDataPtr];
                }
                else{
                    
                   self.m_cObjAthletelogPtr.m_cObjTestResultPtr = [NSString stringWithFormat:@"%@",m_cObjSprintTextFieldPtr.text];
                   self.m_cObjTestDataPtr.m_cObjTestResultsPtr = [NSString stringWithFormat:@"%@",m_cObjSprintTextFieldPtr.text];
                   m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                   [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
                   gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                   [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                }
            }
        }
    }
}
//Server Transactions Methods 2-3-13 - start
-(void)serverTransactionSucceeded
{
    
    if (NO == gObjAppDelegatePtr.isNetworkAvailable) 

    {
        isAddedinOfflineMode =YES;
    }
    
    if (isAddedinOfflineMode)
    {
        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
        [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
        
        isServerTransactionSucceed = YES;
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Data stored for sync"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        SAFE_RELEASE(lObjAlertViewPtr)
    }
    else
    {
        if (YES == gObjAppDelegatePtr.isNetworkAvailable) 
        {
            m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = NO;
            [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];
        }

        isServerTransactionSucceed = YES;//Srikant
    
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Updated Successfully"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
-(void)serverTransactionFailed
{
//    m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
    if(YES == gObjAppDelegatePtr.isConnectionTimeout)
    {
        [gObjAppDelegatePtr.m_cDbHandler updateTestResult :self.m_cObjAthletelogPtr Test:self.m_cObjTestDataPtr];

        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
    }
    else
    {
        isServerTransactionSucceed = NO;
        gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
        [gObjAppDelegatePtr stopProgressHandler];
        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
        lObjAlertViewPtr = [[UIAlertView alloc]
                            initWithTitle:@"Athlete Logger"
                            message:@"Log Details couldnot be uploaded to server"
                            delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil,
                            nil];
        [lObjAlertViewPtr show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        SAFE_RELEASE(lObjAlertViewPtr)
    }
}
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

//Server Transactions Methods 2-3-13 - end


#pragma mark - Table View Delegates

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
    SAFE_RELEASE(m_cObjTimerLabelDictPtr)
    SAFE_RELEASE(m_cObjSprintTimerDictPtr)
    SAFE_RELEASE(m_cObjSprintTimeDictPtr)
    SAFE_RELEASE(m_cObjVerticalJumpChoiceListPtr)    
    SAFE_RELEASE(m_cObjTimerArrayValuesPtr)
    SAFE_RELEASE(m_cObjTimerPickerViewPtr)
    SAFE_RELEASE(m_cObjkeyboardDoneButtonViewPtr)
    SAFE_RELEASE(m_cObjAthletelogPtr)
    SAFE_RELEASE(m_cObjScrollViewPtr)
    SAFE_RELEASE(m_cObjInstructionLabelPtr)
    SAFE_RELEASE(m_cObjSprintTimeLabelPtr)
    SAFE_RELEASE(m_cObjSprintTextFieldPtr)
    SAFE_RELEASE(m_cObjeditTimerMessagePtr)
    SAFE_RELEASE(m_cObjSaveButton)
    [super dealloc];
}
@end
