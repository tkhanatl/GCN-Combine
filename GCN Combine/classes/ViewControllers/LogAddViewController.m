//
//  LogAddViewController.m
//  GCN Combine
//
//  Created by Debi Samantrai on 12/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "LogAddViewController.h"
#import "AddAthleteDetailsTableViewCell.h"
#import "AddZigZagLogTableViewCell.h"

@implementation LogAddViewController
@synthesize m_cLogDisplayMode, m_cObjInstructionLabelPtr,m_cObjSprintTextFieldPtr,m_cObjSprintClearBtnPtr,m_cObjSprintTimerBtnPtr,m_cObjSprintTimeLabelPtr,m_cObjButtonTitlePtr,m_cObjSprintTimerPtr,m_cObjSprintTimerValuePtr,m_cObjSprintTotalTimePtr,m_cAthleteId,m_cObjZigZagTotalTimePtr,m_cObjZigZagTimerValuePtr,m_cObjZigZagTimerPtr;
@synthesize m_cObjAthletelogPtr;
@synthesize m_cObjVerJumpTableViewPtr;
@synthesize m_cObjZigZagTableViewPtr;
@synthesize m_cObjZigZagTimerLabelPtr;
@synthesize m_cObjActiveTextFieldPtr;
@synthesize m_cObjverticalJumpPicker,m_cObjVerticalJumpChoiceListPtr;
@synthesize m_cObjSegementCtrlPtr;
@synthesize m_cObjkeyboardDoneButtonViewPtr;
@synthesize isServerTransactionSucceed,m_cObjZigZagTimeLabel,m_cObjSprintTimeLabel;
@synthesize  countDownTimer;
@synthesize m_cObjTimerPickerViewPtr;
@synthesize m_cObjTimerArrayValuesPtr;
@synthesize m_cObjCountDownTimerValue;
@synthesize m_cObjSprintTimePtr,m_cObjZigZagTimePtr,m_cObjZigZagTimeLabel2,m_cObjZigZagTimePtr2,m_cObjZigZagTimerValuePtr2;
@synthesize m_cObjZigZagTimerPtr2,m_cObjZigZagTotalTimePtr2,m_cObjChoiceLabelPtr,m_cObjeditTimerButtonPtr,m_cObjeditTimerMessagePtr,m_cObjScrollViewPtr,m_cObjAlarmSoundPtr,m_cObjTestDataPtr;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"LoginBackGround", @"")]];
        m_cObjSprintTimerPtr = (NSTimer *)nil;
        m_cObjZigZagTimerPtr = (NSTimer *)nil;
        m_cObjVerJumpTableViewPtr = (UITableView *)nil;
        m_cObjZigZagTableViewPtr = (UITableView *)nil;
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        isServerTransactionSucceed = NO;
        IsTextFieldActive = NO;
        countDownTimer = -1;
        m_cObjZigZagTimerPtr2 = (NSTimer *)nil;
        m_cObjAlarmSoundPtr = (AVAudioPlayer *)nil;
 
        
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
-(void)loadView
{
    [super loadView];
    
    AthleteLog *lObjAthleteLogPtr = (AthleteLog *)nil;
    lObjAthleteLogPtr = [[AthleteLog alloc] init];
    
    self.m_cObjAthletelogPtr = lObjAthleteLogPtr;
    
    SAFE_RELEASE(lObjAthleteLogPtr)
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createElements];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isServerTransactionSucceed = NO;
    
    
//    if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
//    {
//        self.m_cObjCountDownTimerValue =[NSString stringWithFormat:@"%d",30];
//    }
    if ([m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"]) {
        self.m_cObjCountDownTimerValue =[NSString stringWithFormat:@"%d",30];
    }
    
    [self createControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:m_cObjCurrentTextFieldPtr];
    IsTextFieldActive = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = nil;
    if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
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
    else if(/*m_cLogDisplayMode == ZigZag*/ [m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [m_cObjTestDataPtr.m_cObjTestAttemptsPtr isEqualToString:@"3"] && [m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"])
    {
        if((NSTimer *)nil != m_cObjSprintTimerPtr)
        {
            [m_cObjSprintTimerPtr invalidate];
            m_cObjSprintTimerPtr = (NSTimer *)nil;
        }
        else if((NSTimer *)nil != m_cObjZigZagTimerPtr)
        {
            [m_cObjZigZagTimerPtr invalidate];
            m_cObjZigZagTimerPtr = (NSTimer *)nil;
        }
        else if ((NSTimer *)nil != m_cObjZigZagTimerPtr2)
        {
            [m_cObjZigZagTimerPtr2 invalidate];
            m_cObjZigZagTimerPtr2 = (NSTimer *)nil;
        }
    }
    else if(/*m_cLogDisplayMode == CourtSprints*/ [m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [m_cObjTestDataPtr.m_cObjTestAttemptsPtr isEqualToString:@"2"] && [m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Min and Secs"])
    {
        if((NSTimer *)nil != m_cObjSprintTimerPtr)
        {
            [m_cObjSprintTimerPtr invalidate];
            m_cObjSprintTimerPtr = (NSTimer *)nil;
        }
        else if((NSTimer *)nil != m_cObjZigZagTimerPtr)
        {
            [m_cObjZigZagTimerPtr invalidate];
            m_cObjZigZagTimerPtr = (NSTimer *)nil;
        }

    }
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

-(void)createControls
{
    if(/*m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy*/[m_cObjTestDataPtr.m_cObjTestTypePtr isEqualToString:@"TIME"] && [m_cObjTestDataPtr.m_cObjTestDataTypePtr isEqualToString:@"Integer Count"])
    {
       m_cObjScrollViewPtr = (UIScrollView *)nil;
        m_cObjScrollViewPtr = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        m_cObjScrollViewPtr.scrollEnabled = NO;
        m_cObjScrollViewPtr.delegate = self;
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320.0, 500.0);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0.0, 0.0);
        [self.view addSubview:m_cObjScrollViewPtr];
        
        
        m_cObjInstructionLabelPtr = [[UILabel alloc]init];
        m_cObjInstructionLabelPtr.frame = CGRectMake(60.0, 3.0, 240.0, 25.0);
        m_cObjInstructionLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjInstructionLabelPtr.font = [UIFont fontWithName:@"MuseoSlab-500" size:15.0];
        m_cObjInstructionLabelPtr.textColor = [UIColor whiteColor];
        m_cObjInstructionLabelPtr.shadowColor = UIColorFromRGBWithAlpha(0x000000,1.0);
        m_cObjInstructionLabelPtr.numberOfLines = 0;
        m_cObjInstructionLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        [m_cObjScrollViewPtr addSubview:m_cObjInstructionLabelPtr];
        
               
        if(/*m_cLogDisplayMode == SettingAccuracy*/[m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Setting Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record sets and tap save.";
            self.navigationItem.title = @"Setting Accuracy";
        }
        else if (/*m_cLogDisplayMode == PassingAccuracy*/ [m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Passing Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record passes and tap save.";
            self.navigationItem.title = @"Passing Accuracy";
        }
        else if (/*m_cLogDisplayMode == ServeAccuracy*/ [m_cObjTestDataPtr.m_cObjTestNamePtr isEqualToString:@"Serve Accuracy"])
        {
            m_cObjInstructionLabelPtr.text = @"Record serves and tap save.";
            self.navigationItem.title = @"Serve Accuracy";
        }
        
        
        m_cObjSprintTimeLabelPtr = [[UILabel alloc] init];
        if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy){
            m_cObjSprintTimeLabelPtr.frame = CGRectMake(25.0, CGRectGetMaxY(m_cObjInstructionLabelPtr.frame) + 15.0,260.0, 70.0);
        }
        m_cObjSprintTimeLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjSprintTimeLabelPtr.textAlignment = UITextAlignmentCenter;
        m_cObjSprintTimeLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjSprintTimeLabelPtr.textColor = [UIColor whiteColor];
        if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
        {
            m_cObjSprintTimeLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:64];
        }
        if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy) {
            if ((NSString *)nil == self.m_cObjCountDownTimerValue || [self.m_cObjCountDownTimerValue isEqualToString:@""] || [self.m_cObjCountDownTimerValue isEqualToString:@" "]) {
                m_cObjSprintTimeLabelPtr.text = @"00:30.00 secs";
            }
            else
            {
                m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
            }
        }
        [m_cObjScrollViewPtr addSubview:m_cObjSprintTimeLabelPtr];
        
        
        if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy) {
                       
            
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
            
            
            
        
        }
        else if(m_cLogDisplayMode == ServeAccuracy){
            
            m_cObjSprintTimerBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
            m_cObjSprintTimerBtnPtr.frame = CGRectMake(48.0, CGRectGetMaxY(m_cObjSprintTimeLabelPtr.frame)+5.0, 100.0, 46.0);
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
            
        }
        if (m_cLogDisplayMode == SettingAccuracy) {
            m_cObjChoiceLabelPtr.text = NSLocalizedString(@"Settings Message", @"");
        }
        else if (m_cLogDisplayMode == PassingAccuracy)
        {
            m_cObjChoiceLabelPtr.text = NSLocalizedString(@"Passing Message", @"");
        }
        else if (m_cLogDisplayMode == ServeAccuracy)
        {
            m_cObjChoiceLabelPtr.text = NSLocalizedString(@"Serve Message", @"");
        }
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
        
       if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
        {
            m_cObjSprintTextFieldPtr.placeholder = @"Enter Count";
            m_cObjSprintTextFieldPtr.userInteractionEnabled = NO;
            [self createTimerPicker];
        }
        
        
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
    else if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints || m_cLogDisplayMode == ServeSpeed || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump || m_cLogDisplayMode == StandingVertical)
    {
        
       CGRect lRect = CGRectMake(10.0, 10.0, 310.0, 410.0);
        if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ServeSpeed || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump || m_cLogDisplayMode == StandingVertical) 
        {
            m_cObjVerJumpTableViewPtr = [[UITableView alloc] initWithFrame:lRect style:UITableViewStyleGrouped];

            if(m_cLogDisplayMode == VerticalJump)
                self.navigationItem.title = @"Vertical";
            else if (m_cLogDisplayMode == ApproachJump)
                self.navigationItem.title = @"Approach Jump";
            else if (m_cLogDisplayMode == BroadJump)
                self.navigationItem.title = @"Broad Jump";
            else if (m_cLogDisplayMode == StandingVertical)
                self.navigationItem.title = @"Standing Vertical";
        }
        else if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
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
        if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
        {
            m_cObjVerJumpTableViewPtr.scrollEnabled = NO;
        }
        else if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump || m_cLogDisplayMode == ServeSpeed)
        {
        m_cObjVerJumpTableViewPtr.scrollEnabled = YES;
        }
        m_cObjVerJumpTableViewPtr.allowsSelectionDuringEditing = YES;
        m_cObjVerJumpTableViewPtr.alpha = 1.0;
        if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump) {
            m_cObjVerJumpTableViewPtr.tag=ADDLOGGERVERTICALJUMPTABLE;
            [self createVerticalJumpPicker];
        }
        else if(m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ServeSpeed){
            m_cObjVerJumpTableViewPtr.tag=ADDLOGGERSPIKESPEEDTALE;
            
            m_cObjToolBarPtr = (UIToolbar *)nil;
            m_cObjToolBarPtr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
            m_cObjToolBarPtr.barStyle = UIBarStyleBlack;
            m_cObjToolBarPtr.translucent = YES;
            m_cObjToolBarPtr.tintColor = nil;
            if (m_cLogDisplayMode == SpikeSpeed) {
                self.navigationItem.title = @"Spike Speed Drill";
            }
            else if (m_cLogDisplayMode == ServeSpeed)
            {
                self.navigationItem.title = @"Serve Speed";
            }
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
        else if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
        {

            UILabel *lObjSprintLabelPtr = (UILabel *)nil;
            lObjSprintLabelPtr = [[UILabel alloc] init];
            self.m_cObjSprintTimeLabel = lObjSprintLabelPtr;
            SAFE_RELEASE(lObjSprintLabelPtr)
            
           
            lObjSprintLabelPtr = [[UILabel alloc] init];
            self.m_cObjZigZagTimeLabel = lObjSprintLabelPtr;
            SAFE_RELEASE(lObjSprintLabelPtr)
            
            
            if (m_cLogDisplayMode == ZigZag) {
                lObjSprintLabelPtr = [[UILabel alloc] init];
                self.m_cObjZigZagTimeLabel2 = lObjSprintLabelPtr;
                self.navigationItem.title = @"Zig Zag Drill";
                SAFE_RELEASE(lObjSprintLabelPtr)
            }
            else if(m_cLogDisplayMode == CourtSprints)
            {
                self.navigationItem.title = @"Court Sprints";
            }
            
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
  }

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
    [m_cObjverticalJumpPicker reloadAllComponents];
    
       
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DoneBtnTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [m_cObjkeyboardDoneButtonViewPtr setItems:[NSArray arrayWithObjects:flexBtn,doneButton, nil]];
    SAFE_RELEASE(doneButton)
    SAFE_RELEASE(flexBtn)
    
}
-(void)photoDownloadSucceed
{
    
}
-(void)photoDownloadFailed
{
    
}
- (void)onSegmentBtnClicked:(id)pObjSenderPtr
{
    UISegmentedControl  *lObjSegmentCtrlPtr = (UISegmentedControl *)nil;
    lObjSegmentCtrlPtr = (UISegmentedControl *)pObjSenderPtr;
    UITextField *lObjTextFieldPtr = (UITextField *)nil;
        
    switch (lObjSegmentCtrlPtr.selectedSegmentIndex)
    {
        case 0:
            if(m_cObjActiveTextFieldPtr.tag == ATHLETEVERTICALJUMPTRIAL2)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL1];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEVERTICALJUMPTRIAL3)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPIKESPEED2)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED1];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPIKESPEED3)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED2];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            break;
        case 1:
            if(m_cObjActiveTextFieldPtr.tag == ATHLETEVERTICALJUMPTRIAL1)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETEVERTICALJUMPTRIAL2)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL3];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPIKESPEED1)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED2];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            else if(m_cObjActiveTextFieldPtr.tag == ATHLETESPIKESPEED2)
            {
                [m_cObjActiveTextFieldPtr resignFirstResponder];
                lObjTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED3];
                [lObjTextFieldPtr becomeFirstResponder];
                lObjTextFieldPtr = (UITextField *)nil;
            }
            
            break;
    }
}
-(void)pickerDoneClicked:(id)pSender
{
    if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump)
    {
    [m_cObjActiveTextFieldPtr resignFirstResponder];
    }
    else if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
    {
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
    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump) {
        
        return 1;
    }
    else if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
    {
        return 2;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump) {
      return [self.m_cObjVerticalJumpChoiceListPtr count];
    }
    else if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
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
    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump)
    {
            m_cObjActiveTextFieldPtr.text = [NSString stringWithFormat:@"%@ Inches",[self.m_cObjVerticalJumpChoiceListPtr objectAtIndex:row]];
    }
    else if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy){
        if (component == 0) {
            self.m_cObjCountDownTimerValue = [self.m_cObjTimerArrayValuesPtr objectAtIndex:row];
            m_cObjSprintTimeLabelPtr.text = [NSString stringWithFormat:@"00:%@.00 secs",self.m_cObjCountDownTimerValue];
            m_cObjSprintTimeLabelPtr.numberOfLines =2;
            if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy) {
                m_cObjSprintTimerBtnPtr.userInteractionEnabled = YES;
                m_cObjSprintClearBtnPtr.userInteractionEnabled = YES;
                [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor orangeColor]];
            }
        }
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45.0;
}
- (NSString *)pickerView:(UIPickerView *)pickerview titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump) {
        NSString	*lObjTitlePtr = (NSString *)nil;
        lObjTitlePtr = (NSString *)[NSString stringWithFormat:@"%@",[self.m_cObjVerticalJumpChoiceListPtr objectAtIndex:row]];
        return  lObjTitlePtr;
    }
    else if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
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
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_cObjVerJumpTableViewPtr.tag == ADDLOGGERVERTICALJUMPTABLE || m_cObjVerJumpTableViewPtr.tag == ADDLOGGERSPIKESPEEDTALE) {
        return 3;
    }
    else if (m_cObjVerJumpTableViewPtr.tag == ADDLOGGERZIGZAGTABLE)
    {
        if (m_cLogDisplayMode == ZigZag ) {
            return 3;
        }
        else if (m_cLogDisplayMode == CourtSprints)
        {
            return 2;
        }
        
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (m_cObjVerJumpTableViewPtr.tag == ADDLOGGERVERTICALJUMPTABLE || m_cObjVerJumpTableViewPtr.tag == ADDLOGGERSPIKESPEEDTALE) {
        return 70.0;
    }
    else if(m_cObjVerJumpTableViewPtr.tag ==  ADDLOGGERZIGZAGTABLE){
        if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
            return 130;
    }
    return 0.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lObjLabelPtr = (UILabel *)nil;
    if (m_cObjVerJumpTableViewPtr.tag == ADDLOGGERVERTICALJUMPTABLE) {
        static NSString		*lObjCellIdentifierPtr = @"AddAthleteLowerDetailCell";
        AddAthleteDetailsTableViewCell		*lObjCellPtr = (AddAthleteDetailsTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjCellIdentifierPtr];
        if((AddAthleteDetailsTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddAthleteDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjCellIdentifierPtr] autorelease];
        }
        lObjCellPtr.accessoryView = (UIView *)nil;
        lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentCenter;
        switch (indexPath.row)
        {
            case 0:
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"VerticalJump Trial1";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Approach Jump Trial1";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Broad Jump Trial1";
                else if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Standing Vertical Trial1";
                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                
//                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Vertical Jump Score1";
                
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Vertical Jump Score1";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Approach Jump Score1";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Broad Jump Score1";
                if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Standing Vertical Score1";
                
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjverticalJumpPicker;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALJUMPTRIAL1;
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
            case 1:
//                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"VerticalJump Trial2";
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"VerticalJump Trial2";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Approach Jump Trial2";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Broad Jump Trial2";
                else if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Standing Vertical Trial2";
                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
//                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"VerticalJump Trial2";
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Vertical Jump Score2";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Approach Jump Score2";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Broad Jump Score2";
                if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Standing Vertical Score2";
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjverticalJumpPicker;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALJUMPTRIAL2;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
            case 2:
//                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"VerticalJump Trial3";
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"VerticalJump Trial3";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Approach Jump Trial3";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Broad Jump Trial3";
                else if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Standing Vertical Trial3";

                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputView = m_cObjverticalJumpPicker;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;                
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
//                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"VerticalJump Trial3";
               
                if (m_cLogDisplayMode == VerticalJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Vertical Jump Score3";
                else if (m_cLogDisplayMode == ApproachJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Approach Jump Score3";
                else if (m_cLogDisplayMode == BroadJump)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Broad Jump Score3";
                if (m_cLogDisplayMode == StandingVertical)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Standing Vertical Score3";
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETEVERTICALJUMPTRIAL3;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
        }
        
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;
    }
    else if (m_cObjVerJumpTableViewPtr.tag == ADDLOGGERSPIKESPEEDTALE)
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
        
        switch (indexPath.row)
        {
            case 0:
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Trial1";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Serve Speed Trial1";
                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Spike Speed1";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Serve Speed1";
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                if(lObjCellPtr.m_cObjAthleteTextFieldPtr.text.length == 0)
                {
                    IsTextFieldActive = NO;
                }
                else
                    IsTextFieldActive = YES;
                lObjLabelPtr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 14)];
                lObjLabelPtr.text = @"MPH";
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
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPIKESPEED1;
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
            case 1:
//                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Trial2";
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Trial2";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Serve Speed Trial2";
                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                if(lObjCellPtr.m_cObjAthleteTextFieldPtr.text.length == 0)
                {
                    IsTextFieldActive = NO;
                }
                else
                    IsTextFieldActive = YES;
                lObjLabelPtr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 14)];
                lObjLabelPtr.text = @"MPH";
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
//                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Spike Speed2";
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Spike Speed2";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Serve Speed2";
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjToolBarPtr;                
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPIKESPEED2;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
            case 2:
//                lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Trial3";
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Spike Speed Trial3";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteDetailLabelPtr.text = @"Serve Speed Trial3";
                
                lObjCellPtr.m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
                [lObjCellPtr.m_cObjAthleteDetailLabelPtr setFont:[UIFont systemFontOfSize:15.0]];
                lObjCellPtr.m_cObjAthleteTextViewPtr.hidden = YES;
                if(lObjCellPtr.m_cObjAthleteTextFieldPtr.text.length == 0)
                {
                    IsTextFieldActive = NO;
                }
                else
                    IsTextFieldActive = YES;
                lObjLabelPtr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 14)];
                lObjLabelPtr.text = @"MPH";
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
                lObjCellPtr.m_cObjAthleteTextFieldPtr.keyboardType = UIKeyboardTypeDecimalPad;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.inputAccessoryView = m_cObjToolBarPtr;                
                [lObjCellPtr.m_cObjAthleteTextFieldPtr setFont:[UIFont systemFontOfSize:15.0]];
//                lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Spike Speed3";
                if (m_cLogDisplayMode == SpikeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Spike Speed3";
                else if (m_cLogDisplayMode == ServeSpeed)
                    lObjCellPtr.m_cObjAthleteTextFieldPtr.placeholder = @"Serve Speed3";
                
                lObjCellPtr.m_cObjAthleteTextFieldPtr.tag = ATHLETESPIKESPEED3;
                lObjCellPtr.m_cObjAthleteTextFieldPtr.delegate = self;
                break;
        }
        
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        return lObjCellPtr;

    }
    else if(m_cLogDisplayMode == ZigZag)
    {
        static NSString *lObjIdentifierPtr = @"AddLoggerTableViewCell";
        AddZigZagLogTableViewCell *lObjCellPtr = (AddZigZagLogTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjIdentifierPtr];
        if ((AddZigZagLogTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddZigZagLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjIdentifierPtr :indexPath.row]autorelease];
        }
            lObjCellPtr.accessoryView = (UIView *)nil;
            lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        
            switch (indexPath.row)
            {
                case 0:
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 20;
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"ZIGZAG1", @"");
                    
                    if ((NSString *)nil != self.m_cObjSprintTimeLabel.text) {
                        lObjCellPtr.m_cObjSprintTimeLabelPtr.text = self.m_cObjSprintTimeLabel.text;
                    }                    
                    lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 22;

                    lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 21;
                    lObjCellPtr.m_cObjSprintTextFieldPtr.inputAccessoryView=m_cObjToolBarPtr;
                    [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    lObjCellPtr.m_cObjSprintClearBtnPtr.tag=24;
                    [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 20;
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"ZIGZAG2", @"");
                    
                    if ((NSString *)nil != self.m_cObjZigZagTimeLabel.text) {
                        lObjCellPtr.m_cObjSprintTimeLabelPtr.text = self.m_cObjZigZagTimeLabel.text;
                    }
                    lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 27;
                    lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 26;
                    [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                   
                    lObjCellPtr.m_cObjSprintClearBtnPtr.tag=29;
                    [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                case 2:
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 30;
                    lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"ZIGZAG3", @"");
                    
                    if ((NSString *)nil != self.m_cObjZigZagTimeLabel.text) {
                        lObjCellPtr.m_cObjSprintTimeLabelPtr.text = self.m_cObjZigZagTimeLabel.text;
                    }
                    lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 31;
                     
                    lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 32;
                    [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    lObjCellPtr.m_cObjSprintClearBtnPtr.tag=33;
                    [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                default:
                    break;
            }
        return lObjCellPtr;
    }
    else if(m_cLogDisplayMode == CourtSprints)
    {
        static NSString *lObjIdentifierPtr = @"AddLoggerTableViewCell";
        AddZigZagLogTableViewCell *lObjCellPtr = (AddZigZagLogTableViewCell *)nil;
        
        lObjCellPtr = [tableView dequeueReusableCellWithIdentifier:lObjIdentifierPtr];
        if ((AddZigZagLogTableViewCell *)nil == lObjCellPtr)
        {
            lObjCellPtr = [[[AddZigZagLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lObjIdentifierPtr :indexPath.row]autorelease];
        }
        lObjCellPtr.accessoryView = (UIView *)nil;
        lObjCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row)
        {
            case 0:
                lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 20;
                lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"COURTSPRINT1", @"");
                
                if ((NSString *)nil != self.m_cObjSprintTimeLabel.text) {
                    lObjCellPtr.m_cObjSprintTimeLabelPtr.text = self.m_cObjSprintTimeLabel.text;
                }
                lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 22;
                               
                lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 21;
                lObjCellPtr.m_cObjSprintTextFieldPtr.inputAccessoryView=m_cObjToolBarPtr;
                [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                lObjCellPtr.m_cObjSprintClearBtnPtr.tag=24;
                [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                
                lObjCellPtr.m_cObjZigzagHeaderLabelPtr.tag = 20;
                lObjCellPtr.m_cObjZigzagHeaderLabelPtr.text = NSLocalizedString(@"COURTSPRINT2", @"");
                
                if ((NSString *)nil != self.m_cObjZigZagTimeLabel.text) {
                    lObjCellPtr.m_cObjSprintTimeLabelPtr.text = self.m_cObjZigZagTimeLabel.text;
                }
                lObjCellPtr.m_cObjSprintTimeLabelPtr.tag = 27;
                lObjCellPtr.m_cObjSprintTimeLabelPtr.numberOfLines =2;
                lObjCellPtr.m_cObjSprintTimerBtnPtr.tag = 26;
                [lObjCellPtr.m_cObjSprintTimerBtnPtr addTarget:self action:@selector(onTimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                lObjCellPtr.m_cObjSprintClearBtnPtr.tag=29;
                [lObjCellPtr.m_cObjSprintClearBtnPtr addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        return lObjCellPtr;
    }
    return nil;
}

-(void)onBackButtonClicked : (id)sender
{
    [self.view endEditing:YES];
    if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == ServeAccuracy || m_cLogDisplayMode == PassingAccuracy)
    {
        if([m_cObjTimerPickerViewPtr isHidden] == NO)
        {
            [self pickerDoneClicked:nil];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onSaveButtonClicked : (id)sender
{
    UITextField *lObjTextField = (UITextField *)nil;
    UITextField *lObjTextField1 = (UITextField *)nil;
    UITextField *lObjTextField2 = (UITextField *)nil;
    CGFloat firstScore = 0.0;
    CGFloat secondScore = 0.0;
    CGFloat thirdScore = 0.0;
        
    if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump || m_cLogDisplayMode == StandingVertical)
    {
        if([m_cObjActiveTextFieldPtr isFirstResponder])
        {
            [m_cObjActiveTextFieldPtr resignFirstResponder];
        }
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL1];
         lObjTextField1 = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
         lObjTextField2 = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL3];
        
        if (lObjTextField.text.length <= 0 || lObjTextField1.text.length <= 0 || lObjTextField2.text.length <= 0) {
            UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
            lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Please Enter Three Trial Values" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [lObjAlertViewPtr show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            SAFE_RELEASE(lObjAlertViewPtr)
        }        
        else
        {
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL1];
                if (lObjTextField.text.length > 0) {
                    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical)
                        self.m_cObjAthletelogPtr.m_cVerticalJumpScore1 = lObjTextField.text;
                    else if (m_cLogDisplayMode == ApproachJump)
                        self.m_cObjAthletelogPtr.m_cObjApproachJumpScore1Ptr = lObjTextField.text;
                    else if (m_cLogDisplayMode == BroadJump)
                        self.m_cObjAthletelogPtr.m_cObjBroadJumpScore1Ptr = lObjTextField.text;
                    
                        firstScore = [lObjTextField.text floatValue];

                }
                
                lObjTextField = (UITextField *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
                if (lObjTextField.text.length > 0) {
                    if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical)
                        self.m_cObjAthletelogPtr.m_cVerticalJumpScore2 = lObjTextField.text;
                    else if (m_cLogDisplayMode == ApproachJump)
                        self.m_cObjAthletelogPtr.m_cObjApproachJumpScore2Ptr = lObjTextField.text;
                    else if (m_cLogDisplayMode == BroadJump)
                        self.m_cObjAthletelogPtr.m_cObjBroadJumpScore2Ptr = lObjTextField.text;                    
                    
                    secondScore = [lObjTextField.text floatValue];
                }
                
                lObjTextField = (UITextField *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL3];
                if (lObjTextField.text.length > 0) {
                    if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical)
                        self.m_cObjAthletelogPtr.m_cVerticalJumpScore3 = lObjTextField.text;
                    else if (m_cLogDisplayMode == ApproachJump)
                        self.m_cObjAthletelogPtr.m_cObjApproachJumpScore3Ptr = lObjTextField.text;
                    else if (m_cLogDisplayMode == BroadJump)
                        self.m_cObjAthletelogPtr.m_cObjBroadJumpScore3Ptr = lObjTextField.text;
   
                    thirdScore = [lObjTextField.text floatValue];

                }
            
                float highest = 0.0;
                highest = MAX(firstScore, MAX(secondScore, thirdScore));
            
                CGFloat highestValue;
                if (highest == firstScore) {
                    lObjTextField  =(UITextField *)nil;
                    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL1];
                    highestValue = firstScore;
                }
                else if (highest == secondScore)
                {
                    lObjTextField  =(UITextField *)nil;
                    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
                    highestValue = secondScore;
                }
                else{
                    lObjTextField  =(UITextField *)nil;
                    lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL3];
                    highestValue = thirdScore;            
                }
            
                if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical){
                   self.m_cObjAthletelogPtr.m_cObjVerticalJumpHighestScore = [NSString stringWithFormat:@"%f",highestValue];
//                   [gObjAppDelegatePtr.m_cDbHandler updateVerticalJumpLog:m_cObjAthletelogPtr :m_cAthleteId];
                }
                else if(m_cLogDisplayMode == ApproachJump){
                    self.m_cObjAthletelogPtr.m_cObjApproachJumpHighestScorePtr = [NSString stringWithFormat:@"%f",highestValue];
//                    [gObjAppDelegatePtr.m_cDbHandler updateApproachJumpLog:m_cObjAthletelogPtr :m_cAthleteId];
                }
                else if(m_cLogDisplayMode == BroadJump){
                    self.m_cObjAthletelogPtr.m_cObjBroadJumpHighestScorePtr = [NSString stringWithFormat:@"%f",highestValue];
//                    [gObjAppDelegatePtr.m_cDbHandler updateBroadJumpLog:m_cObjAthletelogPtr :m_cAthleteId];
                }

                 gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs To Server"];
//                    if(m_cLogDisplayMode == VerticalJump)
//                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :VerticalJump :m_cAthleteId];
//                    else if (m_cLogDisplayMode == ApproachJump)
//                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :ApproachJump :m_cAthleteId];
//                    else if (m_cLogDisplayMode == BroadJump)
//                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :BroadJump :m_cAthleteId];
//                    else if (m_cLogDisplayMode == StandingVertical)
//                        [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :StandingVertical :m_cAthleteId];
                }
                else
                {
                    
                     
                        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode =YES;
                        
                        if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical){
                            //self.m_cObjAthletelogPtr.m_cObjVerticalJumpHighestScore = [NSString stringWithFormat:@"%f",highestValue];
                            [gObjAppDelegatePtr.m_cDbHandler updateVerticalJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"532ba4f2-a7ce-4b3b-9cc2-652522e8d7a3"] ;
                        }
                        else if(m_cLogDisplayMode == ApproachJump){
                            //self.m_cObjAthletelogPtr.m_cObjApproachJumpHighestScorePtr = [NSString stringWithFormat:@"%f",highestValue];
                            [gObjAppDelegatePtr.m_cDbHandler updateApproachJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"d0e35609-7d8f-44d7-bb7a-ccbb11593224"];
                        }
                        else if(m_cLogDisplayMode == BroadJump){
                            //self.m_cObjAthletelogPtr.m_cObjBroadJumpHighestScorePtr = [NSString stringWithFormat:@"%f",highestValue];
                            [gObjAppDelegatePtr.m_cDbHandler updateBroadJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"2ecd82e5-28d1-4de5-9400-bc1867d4c5e0"];
                        }

                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr =self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];

                    
//                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                        lObjAlertViewPtr.tag = 100;
//                        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [lObjAlertViewPtr show];
//                        SAFE_RELEASE(lObjAlertViewPtr)
                }
            
             }
        
         }
    else if (m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ServeSpeed)
    {
        
        if([m_cObjActiveTextFieldPtr isFirstResponder])
        {
            [m_cObjActiveTextFieldPtr resignFirstResponder];
        }
        lObjTextField  =(UITextField *)nil;
        lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED1];
        lObjTextField1 = (UITextField *)nil;
        lObjTextField1 = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED2];
        lObjTextField2 = (UITextField *)nil;
        lObjTextField2 = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED3];
        if (lObjTextField.text.length <= 0 || lObjTextField1.text.length <= 0 || lObjTextField2.text.length <= 0) {
            UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
            lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Please Enter Three Trial Values" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [lObjAlertViewPtr show];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            SAFE_RELEASE(lObjAlertViewPtr)
        }
        else
        {
            if (lObjTextField.text.length > 0) {
                firstScore = [lObjTextField.text floatValue];
                self.m_cObjAthletelogPtr.m_cObjSpikeSpeed1Ptr = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            lObjTextField = (UITextField *)nil;
            lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED2];
            if (lObjTextField.text.length > 0) {
                secondScore = [lObjTextField.text floatValue];
                self.m_cObjAthletelogPtr.m_cObjSpikeSpeed2Ptr = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            lObjTextField = (UITextField *)nil;
            lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED3];
            if (lObjTextField.text.length > 0) {
                thirdScore = [lObjTextField.text floatValue];
                self.m_cObjAthletelogPtr.m_cObjSpikeSpeed3Ptr = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            float highest = MAX(firstScore, MAX(secondScore, thirdScore));
           
            
            NSString *highestValue;
            if (highest == firstScore) {
                lObjTextField  =(UITextField *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED1];
                highestValue = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            else if (highest == secondScore)
            {
                lObjTextField  =(UITextField *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED2];
                highestValue = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            else{
                lObjTextField  =(UITextField *)nil;
                lObjTextField = (UITextField *)[self.view viewWithTag:ATHLETESPIKESPEED3];
                highestValue = [NSString stringWithFormat:@"%@", lObjTextField.text];
            }
            
            self.m_cObjAthletelogPtr.m_cObjSpikeSpeedHighestValuePtr = highestValue;
            // [gObjAppDelegatePtr.m_cDbHandler updateSpikeSpeed:m_cObjAthletelogPtr :m_cAthleteId :@"52b9c13c-054c-4fc0-89f4-3430e71c0141"];
 
            gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
            gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
            if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
//                if(m_cLogDisplayMode == SpikeSpeed)
//                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :SpikeSpeed :m_cAthleteId];
//                else if(m_cLogDisplayMode == ServeSpeed)
//                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :ServeSpeed :m_cAthleteId];
            }
            else{
//                if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
//
                    m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                    [gObjAppDelegatePtr.m_cDbHandler updateSpikeSpeed:m_cObjAthletelogPtr :m_cAthleteId :@"52b9c13c-054c-4fc0-89f4-3430e71c0141"];
                    gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                    [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
//                }
//                else{
//                    UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                    lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [lObjAlertViewPtr show];
//                    SAFE_RELEASE(lObjAlertViewPtr)
//                }
            }
 
        }
    }
    else if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
    {
        UILabel *lObjTemp1StringPtr = (UILabel *)nil;
        UILabel *lObjTemp2StringPtr = (UILabel *)nil;
        UILabel *lObjTemp3StringPtr = (UILabel *)nil;
        CGFloat  firstZigZagValue = 0.0;
        CGFloat  secondZigZagValue = 0.0;
        CGFloat  thirdZigZagValue = 0.0;
        UIButton *lObjButtonPtr = (UIButton *)[self.view viewWithTag:21];
        UIButton *lObjButton1Ptr = (UIButton *)[self.view viewWithTag:26];
        UIButton *lObjButton2Ptr = (UIButton *)[self.view viewWithTag:32];
        
        if (m_cLogDisplayMode == ZigZag) {
            lObjTemp1StringPtr = (UILabel *)[self.view viewWithTag:22];
            lObjTemp2StringPtr = (UILabel *)[self.view viewWithTag:27];
            lObjTemp3StringPtr = (UILabel *)[self.view viewWithTag:31];
        }
        else if (m_cLogDisplayMode == CourtSprints)
        {
            lObjTemp1StringPtr = (UILabel *)[self.view viewWithTag:22];
            lObjTemp2StringPtr = (UILabel *)[self.view viewWithTag:27];
        }

            
                
                if([lObjTemp1StringPtr.text isEqualToString:@"00:00.00 secs"]  || [lObjTemp2StringPtr.text isEqualToString:@"00:00.00 secs"]  || [lObjTemp3StringPtr.text isEqualToString:@"00:00.00 secs"] || [lObjButtonPtr.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")] || [lObjButton1Ptr.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")] || [lObjButton2Ptr.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")])
                {
                    if (m_cLogDisplayMode == ZigZag) {
                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                        lObjAlertViewPtr = [[UIAlertView alloc]
                                            initWithTitle:@"Athlete Logger"
                                            message:@"Please check the Timer Status for Three Trials"
                                            delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil,
                                            nil];
                        [lObjAlertViewPtr show];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        SAFE_RELEASE(lObjAlertViewPtr)
                    }
                    else if(m_cLogDisplayMode == CourtSprints){
                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
                        lObjAlertViewPtr = [[UIAlertView alloc]
                                            initWithTitle:@"Athlete Logger"
                                            message:@"Please check the Timer Status for Two Trials"
                                            delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil,
                                            nil];
                        [lObjAlertViewPtr show];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        SAFE_RELEASE(lObjAlertViewPtr)
                    }
                    
                }
                
                else if (m_cLogDisplayMode == ZigZag) {
                       
                       if ((NSString *)nil !=self.m_cObjSprintTotalTimePtr) {
                           firstZigZagValue = [self.m_cObjSprintTotalTimePtr floatValue];
                           self.m_cObjAthletelogPtr.m_cZigZigTimeScored1Ptr = lObjTemp1StringPtr.text;
                        }
                       if ((NSString *)nil !=self.m_cObjZigZagTotalTimePtr) {
                           secondZigZagValue = [self.m_cObjZigZagTotalTimePtr floatValue];
                           self.m_cObjAthletelogPtr.m_cZigZigTimeScored2Ptr = lObjTemp2StringPtr.text;
                       }
                       if ((NSString *)nil !=self.m_cObjZigZagTotalTimePtr2) {
                           thirdZigZagValue = [self.m_cObjZigZagTotalTimePtr2 floatValue];
                           self.m_cObjAthletelogPtr.m_cZigZigTimeScored3Ptr = lObjTemp3StringPtr.text;
                       }
                       
      
                       float highest = 0.0;
                       highest = MIN(firstZigZagValue, MIN(secondZigZagValue, thirdZigZagValue));
                       
                    NSString *highestValue = (NSString *)nil;;
                       if (highest == firstZigZagValue) {
                          
                           highestValue = self.m_cObjSprintTotalTimePtr;
                           m_cObjAthletelogPtr.m_cObjZigZagLeastTimeScoredPtr = highestValue;
                       }
                       else if (highest == secondZigZagValue)
                       {
                         
                           highestValue = self.m_cObjZigZagTotalTimePtr;
                           
                           m_cObjAthletelogPtr.m_cObjZigZagLeastTimeScoredPtr = highestValue;
                       }
                       else if(highest == thirdZigZagValue){
                         
                           highestValue = self.m_cObjZigZagTotalTimePtr2;
                           m_cObjAthletelogPtr.m_cObjZigZagLeastTimeScoredPtr = highestValue;
                       }
                       
      
                       [gObjAppDelegatePtr.m_cDbHandler updateZigZagLog:m_cObjAthletelogPtr :m_cAthleteId];
 
                       gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                       gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                       if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                           gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                           [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
//                           [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :ZigZag :m_cAthleteId];
                       }
                       else{
//                           if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
                               gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                               [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
//                           }
//                           else{
//                               UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                               lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                               [lObjAlertViewPtr show];
//                               SAFE_RELEASE(lObjAlertViewPtr)
//                           }
                       }
 

                  }
                   else if (m_cLogDisplayMode == CourtSprints)
                   {
                       if ((NSString *)nil !=lObjTemp1StringPtr.text) {
                           firstZigZagValue = [self.m_cObjSprintTotalTimePtr floatValue];
                           self.m_cObjAthletelogPtr.m_cSprintsTimeScoredPtr = lObjTemp1StringPtr.text;
                       }
                       if ((NSString *)nil !=lObjTemp2StringPtr.text) {
                           secondZigZagValue = [self.m_cObjZigZagTotalTimePtr floatValue];
                           self.m_cObjAthletelogPtr.m_cSprintsTimeScored1Ptr = lObjTemp2StringPtr.text;
                       }

                       float highest = 0.0;
                       highest = MIN(firstZigZagValue, secondZigZagValue);
                       
                       NSString *highestValue;
                       if (highest == firstZigZagValue) {
                           
                           highestValue = self.m_cObjSprintTotalTimePtr;
                           
                           m_cObjAthletelogPtr.m_cObjSprintsHighestValuePtr = highestValue;
                       }
                       else if (highest == secondZigZagValue)
                       {
                           
                           highestValue = self.m_cObjZigZagTotalTimePtr;
                            
                           m_cObjAthletelogPtr.m_cObjSprintsHighestValuePtr = highestValue;
                       }
                       

                       [gObjAppDelegatePtr.m_cDbHandler updateCourtSprintLog:m_cObjAthletelogPtr :m_cAthleteId];
 
                       gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                       gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                       if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                           gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                           [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
//                           [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :CourtSprints :m_cAthleteId];
                       }
                       else
                       {
//                           if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
                               gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                               [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
//                           }
//                           else{
//                               UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                               lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                               [lObjAlertViewPtr show];
//                               SAFE_RELEASE(lObjAlertViewPtr)
//                           }
                       }

                   }
        }
    else if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
    {
        [m_cObjSprintTextFieldPtr resignFirstResponder];
        if(m_cObjSprintTextFieldPtr.text.length <= 0)
        {
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
            if (m_cLogDisplayMode == SettingAccuracy) {
                m_cObjAthletelogPtr.m_cObjSettingAccuracyCountPtr = m_cObjSprintTextFieldPtr.text;

                m_cObjAthletelogPtr.m_cObjSettingAccuracyTimePtr = [NSString stringWithFormat:@"00:%@.00 secs",m_cObjCountDownTimerValue];
                    //[gObjAppDelegatePtr.m_cDbHandler updateSettingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"8c0f8f13-25c0-47a0-8db7-c8e5e225dca3"];
 
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
//                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :SettingAccuracy :m_cAthleteId];
                }
                else{
//                    if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
                         m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                        [gObjAppDelegatePtr.m_cDbHandler updateSettingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"8c0f8f13-25c0-47a0-8db7-c8e5e225dca3"];
                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
//                    }
////                    else{
//                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [lObjAlertViewPtr show];
//                        SAFE_RELEASE(lObjAlertViewPtr)
////                    }
                }
            }
            else if (m_cLogDisplayMode == PassingAccuracy)
            {
                m_cObjAthletelogPtr.m_cObjPassingAccuracyPtr = m_cObjSprintTextFieldPtr.text;
                m_cObjAthletelogPtr.m_cObjPassingAccuracyTimePtr = [NSString stringWithFormat:@"00:%@.00 secs",m_cObjCountDownTimerValue];

                //                [gObjAppDelegatePtr.m_cDbHandler updatePassingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"b0f1ba68-0298-4c47-bf84-d73219317d13"];
 
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                
                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
//                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :PassingAccuracy :m_cAthleteId];

                }
                else{
//                    if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
                        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
                        [gObjAppDelegatePtr.m_cDbHandler updatePassingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"b0f1ba68-0298-4c47-bf84-d73219317d13"];
                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
                        
//                    }
//                    else{
//                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
//                        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [lObjAlertViewPtr show];
//                        SAFE_RELEASE(lObjAlertViewPtr)
//                    }
                }
 
            }
            else if (m_cLogDisplayMode == ServeAccuracy)
            {
                m_cObjAthletelogPtr.m_cObjServeAccuracyPtr = m_cObjSprintTextFieldPtr.text;

                m_cObjAthletelogPtr.m_cObjServeAccuracyTimePtr = [NSString stringWithFormat:@"00:%@.00 secs",m_cObjCountDownTimerValue];                
                [gObjAppDelegatePtr.m_cDbHandler updateServeAccuracy:m_cObjAthletelogPtr :m_cAthleteId];
 
                gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
                gObjAppDelegatePtr.m_cSignInAttemptCount += 1;
                
//                if (YES == [gObjAppDelegatePtr isNetworkAvailable]) {
                    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = NO;
                    [gObjAppDelegatePtr displayProgressHandler:@"Sending Logs to server"];
//                    [gObjAppDelegatePtr.m_cObjHttpHandlerPtr uploadLog:m_cObjAthletelogPtr :ServeAccuracy :m_cAthleteId];

//                }
//                else{
////                    if (gObjAppDelegatePtr.m_cSignInAttemptCount == 2) {
//                        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
//                        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
////                    }
////                    else{
////                        UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
////                        lObjAlertViewPtr = [[UIAlertView alloc] initWithTitle:@"GCN Combine" message:@"Connection Failed.Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                        [lObjAlertViewPtr show];
////                        SAFE_RELEASE(lObjAlertViewPtr)
////                    }
//                }

            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (YES == isServerTransactionSucceed) {
        [self onBackButtonClicked:nil];
    }
    if (alertView.tag == 1001) {
        [self.m_cObjAlarmSoundPtr stop];
        self.m_cObjAlarmSoundPtr = (AVAudioPlayer *)nil;
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.m_cObjAlarmSoundPtr stop];
     self.m_cObjAlarmSoundPtr = (AVAudioPlayer *)nil;
}
-(void)serverTransactionSucceeded
{
    if (YES == gObjAppDelegatePtr.isNetworkAvailable) {
        m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = NO;
        if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical)
            [gObjAppDelegatePtr.m_cDbHandler updateVerticalJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"532ba4f2-a7ce-4b3b-9cc2-652522e8d7a3"];
        else if(m_cLogDisplayMode == ApproachJump)
            [gObjAppDelegatePtr.m_cDbHandler updateApproachJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"d0e35609-7d8f-44d7-bb7a-ccbb11593224"];
        else if(m_cLogDisplayMode == BroadJump)
            [gObjAppDelegatePtr.m_cDbHandler updateBroadJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"2ecd82e5-28d1-4de5-9400-bc1867d4c5e0"];
        else if (m_cLogDisplayMode == PassingAccuracy)
            [gObjAppDelegatePtr.m_cDbHandler updatePassingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"b0f1ba68-0298-4c47-bf84-d73219317d13"];
        else if (m_cLogDisplayMode == SettingAccuracy)
            [gObjAppDelegatePtr.m_cDbHandler updateSettingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"8c0f8f13-25c0-47a0-8db7-c8e5e225dca3"];
        else if (m_cLogDisplayMode == ServeSpeed)
            [gObjAppDelegatePtr.m_cDbHandler updateSpikeSpeed:m_cObjAthletelogPtr :m_cAthleteId :@"52b9c13c-054c-4fc0-89f4-3430e71c0141"];        
    }
  
    isServerTransactionSucceed = YES;
    gObjAppDelegatePtr.m_cObjWindowPtr.userInteractionEnabled = YES;
    [gObjAppDelegatePtr stopProgressHandler];
    UIAlertView *lObjAlertViewPtr = (UIAlertView *)nil;
    lObjAlertViewPtr = [[UIAlertView alloc]
                        initWithTitle:@"Athlete Logger" 
                        message:@"The Athlete Log Details has been successfully uploaded in the server"
                        delegate:self
                        cancelButtonTitle:@"Ok" 
                        otherButtonTitles:nil,
                        nil];
    [lObjAlertViewPtr show];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    SAFE_RELEASE(lObjAlertViewPtr)
}
-(void)serverTransactionFailed
{
    m_cObjAthletelogPtr.m_cIsAddedinOfflineMode = YES;
    if(YES == gObjAppDelegatePtr.isConnectionTimeout){
        if(m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == StandingVertical)
            [gObjAppDelegatePtr.m_cDbHandler updateVerticalJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"532ba4f2-a7ce-4b3b-9cc2-652522e8d7a3"];
        else if(m_cLogDisplayMode == ApproachJump)
            [gObjAppDelegatePtr.m_cDbHandler updateApproachJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"d0e35609-7d8f-44d7-bb7a-ccbb11593224"];
        else if(m_cLogDisplayMode == BroadJump)
            [gObjAppDelegatePtr.m_cDbHandler updateBroadJumpLog:m_cObjAthletelogPtr :m_cAthleteId :@"2ecd82e5-28d1-4de5-9400-bc1867d4c5e0"];
        else if (m_cLogDisplayMode == PassingAccuracy)
            [gObjAppDelegatePtr.m_cDbHandler updatePassingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"b0f1ba68-0298-4c47-bf84-d73219317d13"];
        else if (m_cLogDisplayMode == SettingAccuracy)
            [gObjAppDelegatePtr.m_cDbHandler updateSettingAccuracy:m_cObjAthletelogPtr :m_cAthleteId :@"8c0f8f13-25c0-47a0-8db7-c8e5e225dca3"];
        else if (m_cLogDisplayMode == ServeSpeed)
            [gObjAppDelegatePtr.m_cDbHandler updateSpikeSpeed:m_cObjAthletelogPtr :m_cAthleteId :@"52b9c13c-054c-4fc0-89f4-3430e71c0141"];
        gObjAppDelegatePtr.m_cObjserverTransDelegatePtr = self;
        [gObjAppDelegatePtr.m_cObjserverTransDelegatePtr serverTransactionSucceeded];
    }
    else{
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
-(void)onTimerButtonPressed : (id)sender
{
    UIButton *lObjButton = (UIButton *)sender;
    
    if (m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints) {
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
        if(lButtonPtr.tag == 21)
        {
            lObjClearBtnPtr = (UIButton *)[self.view viewWithTag:24];
            lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:22];
            lObjTotalLabelPtr = (UILabel *)[self.view viewWithTag:23];
            if(lObjButton.tag == 21 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Start", @"")])
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
                self.m_cObjSprintTimeLabel = lObjTimeLabelPtr;
                
                m_cObjSprintTimerPtr = [NSTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(updateSprintTimer:) userInfo:self.m_cObjSprintTimeLabel repeats:YES];
                
                lObjTotalLabelPtr.text =@"00.00 secs";
                SAFE_RELEASE(sourceDate)
            }
            else if(lObjButton.tag == 21 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")])
            {
                [lObjButton setBackgroundColor:[UIColor orangeColor]];
                [lObjButton setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];

                //invalidate the timer
                if((NSTimer *)nil != m_cObjSprintTimerPtr)
                {
                    [m_cObjSprintTimerPtr invalidate];
                    m_cObjSprintTimerPtr = (NSTimer *)nil;
                }
                

                lObjClearBtnPtr.userInteractionEnabled = YES;
                m_cObjSaveButton.enabled = YES;
                lObjDotSepArrayPtr = [self.m_cObjSprintTimePtr componentsSeparatedByString:@"."];
                lObjStringMiliPtr = [lObjDotSepArrayPtr objectAtIndex:1];
                
                lObjColonSepStringPtr = [lObjDotSepArrayPtr objectAtIndex:0];
                lObjColonSepArrayPtr = [lObjColonSepStringPtr componentsSeparatedByString:@":"];
                lObjStringMinPtr = [lObjColonSepArrayPtr objectAtIndex:0];
                lMinsVal = [lObjStringMinPtr integerValue]*60;
                lSecsVal = [[lObjColonSepArrayPtr objectAtIndex:1]integerValue];
                lTotalTime = lMinsVal + lSecsVal;
		
                self.m_cObjSprintTotalTimePtr = [NSString stringWithFormat:@"%d.%@",lTotalTime,lObjStringMiliPtr];

           }
        }
        else if(lButtonPtr.tag == 26)
        {
            lObjClearBtnPtr = (UIButton *)[self.view viewWithTag:29];
            lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:27];
            lObjTotalLabelPtr = (UILabel *)[self.view viewWithTag:28];
            if(lObjButton.tag == 26 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Start", @"")])
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
                
                
                gObjAppDelegatePtr.m_cObjZigZagStartTimePtr = destinationDate;
                
                self.m_cObjZigZagTimeLabel = lObjTimeLabelPtr;
                m_cObjZigZagTimerPtr = [NSTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(updateZigZagTimer:) userInfo:self.m_cObjZigZagTimeLabel repeats:YES];
                lObjTotalLabelPtr.text =@"00.00 secs";
                SAFE_RELEASE(sourceDate)
            }
            else if(lObjButton.tag == 26 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")])
            {
                //invalidate the timer
                if((NSTimer *)nil != m_cObjZigZagTimerPtr)
                {
                    [m_cObjZigZagTimerPtr invalidate];
                    m_cObjZigZagTimerPtr = (NSTimer *)nil;
                }
                
                [lObjButton setBackgroundColor:[UIColor orangeColor]];
                [lObjButton setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
                
                lObjClearBtnPtr.userInteractionEnabled = YES;
                m_cObjSaveButton.enabled = YES;
                lObjDotSepArrayPtr = [self.m_cObjZigZagTimePtr componentsSeparatedByString:@"."];
                lObjStringMiliPtr = [lObjDotSepArrayPtr objectAtIndex:1];
                
                lObjColonSepStringPtr = [lObjDotSepArrayPtr objectAtIndex:0];
                lObjColonSepArrayPtr = [lObjColonSepStringPtr componentsSeparatedByString:@":"];
                lObjStringMinPtr = [lObjColonSepArrayPtr objectAtIndex:0];
                lMinsVal = [lObjStringMinPtr integerValue]*60;
                lSecsVal = [[lObjColonSepArrayPtr objectAtIndex:1]integerValue];
                lTotalTime = lMinsVal + lSecsVal;
		
                self.m_cObjZigZagTotalTimePtr = [NSString stringWithFormat:@"%d.%@",lTotalTime,lObjStringMiliPtr];
            }
        }
        else if(lButtonPtr.tag == 32)
        {
            lObjClearBtnPtr = (UIButton *)[self.view viewWithTag:33];
            lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:31];
            if(lObjButton.tag == 32 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Start", @"")])
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
                
                
                gObjAppDelegatePtr.m_cObjZigZagStartTimePtr2 = destinationDate;
                
                self.m_cObjZigZagTimeLabel2 = lObjTimeLabelPtr;
                m_cObjZigZagTimerPtr2 = [NSTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(updateZigZagTimer1:) userInfo:self.m_cObjZigZagTimeLabel2 repeats:YES];
                SAFE_RELEASE(sourceDate)
            }
            else if(lObjButton.tag == 32 && [lObjButton.titleLabel.text isEqualToString:NSLocalizedString(@"Stop", @"")])
            {
                //invalidate the timer
                if((NSTimer *)nil != m_cObjZigZagTimerPtr2)
                {
                    [m_cObjZigZagTimerPtr2 invalidate];
                    m_cObjZigZagTimerPtr2 = (NSTimer *)nil;
                }
                
                [lObjButton setBackgroundColor:[UIColor orangeColor]];
                [lObjButton setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
                
                lObjClearBtnPtr.userInteractionEnabled = YES;
                m_cObjSaveButton.enabled = YES;
                lObjDotSepArrayPtr = [self.m_cObjZigZagTimePtr2 componentsSeparatedByString:@"."];
                        lObjStringMiliPtr = [lObjDotSepArrayPtr objectAtIndex:1];
                       lObjColonSepStringPtr = [lObjDotSepArrayPtr objectAtIndex:0];
                       lObjColonSepArrayPtr = [lObjColonSepStringPtr componentsSeparatedByString:@":"];

                       lObjStringMinPtr = [lObjColonSepArrayPtr objectAtIndex:0];
                       lMinsVal = [lObjStringMinPtr integerValue]*60;
                       lSecsVal = [[lObjColonSepArrayPtr objectAtIndex:1]integerValue];
                       lTotalTime = lMinsVal + lSecsVal;
                       self.m_cObjZigZagTotalTimePtr2 = [NSString stringWithFormat:@"%d.%@",lTotalTime,lObjStringMiliPtr];
            }
        }
    }
     else if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
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
    if(m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy)
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
    if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
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
        
        NSDate *lObjstrt= gObjAppDelegatePtr.m_cObjSprintStartTimePtr;
        
        NSTimeInterval lTimeInterval = [lObjCurrentDateStr timeIntervalSinceDate:lObjstrt];
        NSDate *lObjTimerDatePtr = [NSDate dateWithTimeIntervalSince1970:lTimeInterval];
        NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
        [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
        [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        self.m_cObjSprintTimePtr=[lObjDateFormatterPtr stringFromDate:lObjTimerDatePtr];
        self.m_cObjSprintTimerValuePtr = [NSString stringWithFormat:@"%@ secs",self.m_cObjSprintTimePtr];
        self.m_cObjSprintTimeLabel.text = self.m_cObjSprintTimerValuePtr;
                
        SAFE_RELEASE(lObjCurrentDateStr)
        SAFE_RELEASE(lObjDateFormatterPtr)
        }
}
-(void)updateZigZagTimer : (id)sender
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
    
    NSDate *lObjstrt= gObjAppDelegatePtr.m_cObjZigZagStartTimePtr;
    
    NSTimeInterval lTimeInterval = [lObjCurrentDateStr timeIntervalSinceDate:lObjstrt];
    NSDate *lObjTimerDatePtr = [NSDate dateWithTimeIntervalSince1970:lTimeInterval];
    NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
    [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
    [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.m_cObjZigZagTimePtr=[lObjDateFormatterPtr stringFromDate:lObjTimerDatePtr];
    self.m_cObjZigZagTimerValuePtr = [NSString stringWithFormat:@"%@ secs",self.m_cObjZigZagTimePtr];
    
    self.m_cObjZigZagTimeLabel.text = self.m_cObjZigZagTimerValuePtr;
   
    
    SAFE_RELEASE(lObjCurrentDateStr)
    SAFE_RELEASE(lObjDateFormatterPtr)
}

-(void)updateZigZagTimer1 : (id)sender
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
    
    NSDate *lObjstrt= gObjAppDelegatePtr.m_cObjZigZagStartTimePtr2;
    
    NSTimeInterval lTimeInterval = [lObjCurrentDateStr timeIntervalSinceDate:lObjstrt];
    NSDate *lObjTimerDatePtr = [NSDate dateWithTimeIntervalSince1970:lTimeInterval];
    NSDateFormatter *lObjDateFormatterPtr = [[NSDateFormatter alloc] init];
    [lObjDateFormatterPtr setDateFormat:@"mm:ss.SS"];
    [lObjDateFormatterPtr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.m_cObjZigZagTimePtr2=[lObjDateFormatterPtr stringFromDate:lObjTimerDatePtr];
    self.m_cObjZigZagTimerValuePtr2 = [NSString stringWithFormat:@"%@ secs",self.m_cObjZigZagTimePtr2];
    
    self.m_cObjZigZagTimeLabel2.text = self.m_cObjZigZagTimerValuePtr2;
    
    
    SAFE_RELEASE(lObjCurrentDateStr)
    SAFE_RELEASE(lObjDateFormatterPtr)
}

-(void)onClearButtonClicked : (id)sender
{
    if(m_cLogDisplayMode == ZigZag || m_cLogDisplayMode == CourtSprints)
    {
    UIButton *lObjButtonPtr = (UIButton *)nil;
    UILabel *lObjTimeLabelPtr = (UILabel *)nil;
    lObjButtonPtr = (UIButton *)sender;
     
    if(lObjButtonPtr.tag == 24)
    {
        lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:22];

        lObjTimeLabelPtr.text = @"00:00.00 secs";
        m_cObjSprintTimerValuePtr = @"00:00.00 secs";

        self.m_cObjSprintTotalTimePtr = @"00.00";
        m_cObjSaveButton.enabled = NO;
    }
    else if(lObjButtonPtr.tag == 29)
    {
        lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:27];

        lObjTimeLabelPtr.text = @"00:00.00 secs";
        self.m_cObjZigZagTimerValuePtr = @"00:00.00 secs";

        self.m_cObjZigZagTotalTimePtr = @"00.00";
        m_cObjSaveButton.enabled = NO;
    }
    else if(lObjButtonPtr.tag == 33)
    {
        lObjTimeLabelPtr = (UILabel *)[self.view viewWithTag:31];

        lObjTimeLabelPtr.text = @"00:00.00 secs";
       self.m_cObjZigZagTimerValuePtr2 = @"00:00.00 secs";

        self.m_cObjZigZagTotalTimePtr2 = @"00.00";
        m_cObjSaveButton.enabled = NO;
    }
  }
 else if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy)
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
         [m_cObjSprintTimerBtnPtr setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
         [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor orangeColor]];
     }
   }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
 if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy) {

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
    m_cObjActiveTextFieldPtr = textField;
    
    if (m_cLogDisplayMode == VerticalJump || m_cLogDisplayMode == ApproachJump || m_cLogDisplayMode == BroadJump || m_cLogDisplayMode == StandingVertical) {
        
        [m_cObjverticalJumpPicker selectRow:0 inComponent:0 animated:NO];
        
        if (textField.tag == ATHLETEVERTICALJUMPTRIAL3) {
            NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
            [UIView beginAnimations:@"Table View Resizing" context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [UIView commitAnimations];

        }
        if (textField.tag == ATHLETEVERTICALJUMPTRIAL1 || textField.tag == ATHLETEVERTICALJUMPTRIAL2 || textField.tag == ATHLETEVERTICALJUMPTRIAL3)
        {
            textField.inputView = self.m_cObjverticalJumpPicker;
            textField.inputAccessoryView = m_cObjkeyboardDoneButtonViewPtr;
            if(textField.text.length <= 0)
            {
                textField.text = [NSString stringWithFormat:@"%@ Inches",[self.m_cObjVerticalJumpChoiceListPtr objectAtIndex:0]];
                [self.m_cObjverticalJumpPicker selectRow:0 inComponent:0 animated:YES];
                
            }
        }
    }
    else if (m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ServeSpeed)
    {
        if (textField.tag == ATHLETESPIKESPEED3) {
            NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
            [UIView beginAnimations:@"Table View Resizing" context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [UIView commitAnimations];
        }
    }
    else if (m_cLogDisplayMode == ZigZag)
    {
        if (textField.tag == ATHLETEZIGZAGTAG2) {
            NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
            [UIView beginAnimations:@"Table View Resizing" context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [UIView commitAnimations];
        }
    }
    if(textField.text.length <= 0)
    {
        m_cObjSaveButton.enabled = NO;
    }
    else
        m_cObjSaveButton.enabled = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == ATHLETEVERTICALJUMPTRIAL1)
    {
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETEVERTICALJUMPTRIAL2)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETEVERTICALJUMPTRIAL3)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETESPIKESPEED1)
    {
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETESPIKESPEED2)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:1];
    }
    else if(textField.tag == ATHLETESPIKESPEED3)
    {
        [m_cObjSegementCtrlPtr setEnabled:YES forSegmentAtIndex:0];
        [m_cObjSegementCtrlPtr setEnabled:NO forSegmentAtIndex:1];
    }
    return YES;

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(m_cLogDisplayMode == SpikeSpeed || m_cLogDisplayMode == ServeSpeed)
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
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == ATHLETEVERTICALJUMPTRIAL1) {
        [textField resignFirstResponder];
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        m_cObjActiveTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL2];
        [m_cObjActiveTextFieldPtr becomeFirstResponder];
    }
    if (textField.tag == ATHLETEVERTICALJUMPTRIAL2) {
        [textField resignFirstResponder];
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        m_cObjActiveTextFieldPtr = (UITextField *)[self.view viewWithTag:ATHLETEVERTICALJUMPTRIAL3];
        [m_cObjActiveTextFieldPtr becomeFirstResponder];
    }
    if (textField.tag == ATHLETEVERTICALJUMPTRIAL3) 
    {
        [textField resignFirstResponder];
        m_cObjActiveTextFieldPtr = (UITextField *)nil;
        
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == ATHLETEVERTICALJUMPTRIAL3) {
        NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
        [UIView beginAnimations:@"Table View Resizing" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView commitAnimations];

    }
    else if (textField.tag == ATHLETEZIGZAGTAG2) {
        NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
        [UIView beginAnimations:@"Table View Resizing" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView commitAnimations];
    }
    else if (textField.tag == ATHLETESPIKESPEED3)
    {
        NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        m_cObjVerJumpTableViewPtr.contentInset = UIEdgeInsetsMake(0 , 0 ,300 , 0);
        [UIView beginAnimations:@"Table View Resizing" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [m_cObjVerJumpTableViewPtr scrollToRowAtIndexPath:lObjIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [UIView commitAnimations];
    }
  if (m_cLogDisplayMode == SettingAccuracy || m_cLogDisplayMode == PassingAccuracy || m_cLogDisplayMode == ServeAccuracy) {
      
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
       m_cObjkeyboardDoneButtonViewPtr.hidden = YES;
        m_cObjScrollViewPtr.contentSize = CGSizeMake(320, 500);
        m_cObjScrollViewPtr.contentOffset = CGPointMake(0, 0);
         [UIView commitAnimations];
  }
       }

-(void)textFieldDidChange : (NSNotification *)pObjNotification
{
    if(m_cObjCurrentTextFieldPtr == m_cObjSprintTextFieldPtr)
        m_cObjSaveButton.enabled = YES;
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
    SAFE_RELEASE(m_cObjCountDownTimerValue)
    SAFE_RELEASE(m_cObjSegementCtrlPtr)
    SAFE_RELEASE(m_cObjToolBarPtr)
    SAFE_RELEASE(m_cObjInstructionLabelPtr)
    SAFE_RELEASE(m_cObjVerticalJumpChoiceListPtr)
    SAFE_RELEASE(m_cObjAthletelogPtr)
    SAFE_RELEASE(m_cObjSprintTimeLabelPtr)
    SAFE_RELEASE(m_cObjSprintTextFieldPtr)
    SAFE_RELEASE(m_cObjSaveButton)
    SAFE_RELEASE(m_cObjVerJumpTableViewPtr)
    SAFE_RELEASE(m_cObjZigZagTableViewPtr)
    SAFE_RELEASE(m_cObjkeyboardDoneButtonViewPtr)
    SAFE_RELEASE(m_cObjSprintTimeLabel)
    SAFE_RELEASE(m_cObjZigZagTimeLabel)
	SAFE_RELEASE(m_cObjAlarmSoundPtr)
    SAFE_RELEASE(m_cObjSprintTimePtr)
    SAFE_RELEASE(m_cObjZigZagTimePtr)
    SAFE_RELEASE(m_cObjZigZagTimePtr2)
    SAFE_RELEASE(m_cObjZigZagTimeLabel2)
    SAFE_RELEASE(m_cObjTimerArrayValuesPtr)
    
    [super dealloc];
}

@end
