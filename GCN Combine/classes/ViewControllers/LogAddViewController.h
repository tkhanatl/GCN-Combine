//
//  LogAddViewController.h
//  GCN Combine
//
//  Created by Debi Samantrai on 12/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "AppDelegate.h"
#import "ServerTransactionDelegate.h"
#import "AthleteLog.h"
#import <QuartzCore/QuartzCore.h>
#import "AthleteLog.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Tests.h"


@interface LogAddViewController : UIViewController<ServerTransactionDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AVAudioPlayerDelegate>
{
    LogDisplayMode  m_cLogDisplayMode;
    
    
    UILabel           *m_cObjInstructionLabelPtr;
    UITextField       *m_cObjSprintTextFieldPtr;
    UIButton          *m_cObjSprintTimerBtnPtr;
    UIButton          *m_cObjSprintClearBtnPtr;
    UILabel           *m_cObjSprintTimeLabelPtr;
    
    NSString      *m_cObjButtonTitlePtr;
    
    NSTimer       *m_cObjSprintTimerPtr;
    NSTimer       *m_cObjZigZagTimerPtr;
    NSString       *m_cObjSprintTimerValuePtr;
    NSString       *m_cObjSprintTotalTimePtr;
    NSString        *m_cAthleteId;
    NSString       *m_cObjZigZagTimerValuePtr;
    NSString       *m_cObjZigZagTimerValuePtr2;
    NSString       *m_cObjZigZagTotalTimePtr;
    NSString       *m_cObjZigZagTotalTimePtr2;
    UILabel         *m_cObjSprintTimeLabel;
    UILabel         *m_cObjZigZagTimeLabel;
    UILabel         *m_cObjZigZagTimeLabel2;
    
    UIBarButtonItem *m_cObjSaveButton;
    UITextField     *m_cObjCurrentTextFieldPtr;
    UITableView     *m_cObjVerJumpTableViewPtr;
    UITableView     *m_cObjZigZagTableViewPtr;
    AthleteLog      *m_cObjAthletelogPtr;
    NSString        *m_cObjZigZagTimerLabelPtr;
    UITextField     *m_cObjActiveTextFieldPtr;
    UIToolbar       *m_cObjToolBarPtr;

    UIPickerView            *m_cObjverticalJumpPicker;
    NSMutableArray          *m_cObjVerticalJumpChoiceListPtr;
    UISegmentedControl      *m_cObjSegementCtrlPtr;
    UIToolbar               *m_cObjkeyboardDoneButtonViewPtr;
    
    
    BOOL                     isServerTransactionSucceed;
    BOOL                    IsTextFieldActive;
    NSInteger               countDownTimer;
    
    UIPickerView            *m_cObjTimerPickerViewPtr;
    NSMutableArray          *m_cObjTimerArrayValuesPtr;
    NSString                *m_cObjCountDownTimerValue;
    
    AVAudioPlayer           *m_cObjAlarmSoundPtr;
    NSString                *m_cObjSprintTimePtr;
    NSString                *m_cObjZigZagTimePtr;
    NSString                *m_cObjZigZagTimePtr2;
    NSTimer                 *m_cObjZigZagTimerPtr2;
    UILabel                 *m_cObjChoiceLabelPtr;
    UIButton                *m_cObjeditTimerButtonPtr;
    UILabel                 *m_cObjeditTimerMessagePtr;
    UIScrollView            *m_cObjScrollViewPtr;
    
    Tests                   *m_cObjTestDataPtr;
}
@property (nonatomic,retain)    Tests                   *m_cObjTestDataPtr;
@property (nonatomic,retain)    UIScrollView            *m_cObjScrollViewPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjeditTimerMessagePtr;
@property (nonatomic,retain)    UIButton                *m_cObjeditTimerButtonPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjChoiceLabelPtr;
@property (nonatomic,copy)      NSString                *m_cObjCountDownTimerValue;
@property (nonatomic,retain)    NSMutableArray          *m_cObjTimerArrayValuesPtr;
@property (nonatomic,retain)    UIPickerView            *m_cObjTimerPickerViewPtr;
@property (nonatomic,assign)    NSInteger               countDownTimer;
@property (nonatomic)    BOOL                     isServerTransactionSucceed;
@property(nonatomic,retain) UIToolbar               *m_cObjkeyboardDoneButtonViewPtr;
@property(nonatomic,retain)UISegmentedControl      *m_cObjSegementCtrlPtr;
@property(nonatomic,retain)UIPickerView            *m_cObjverticalJumpPicker;
@property(nonatomic,retain)NSMutableArray          *m_cObjVerticalJumpChoiceListPtr;
@property (nonatomic,retain) UITextField     *m_cObjActiveTextFieldPtr;
@property (nonatomic,retain) NSString        *m_cObjZigZagTimerLabelPtr;
@property (nonatomic,assign) LogDisplayMode  m_cLogDisplayMode;
@property (nonatomic,retain) UILabel         *m_cObjInstructionLabelPtr;
@property (nonatomic,retain) UITextField     *m_cObjSprintTextFieldPtr;
@property (nonatomic,retain) UIButton        *m_cObjSprintTimerBtnPtr;
@property (nonatomic,retain) UIButton        *m_cObjSprintClearBtnPtr;
@property (nonatomic,retain) UILabel         *m_cObjSprintTimeLabelPtr;
@property (nonatomic,retain) NSString        *m_cObjButtonTitlePtr;
@property (nonatomic,retain) NSTimer         *m_cObjSprintTimerPtr;
@property (nonatomic,retain) NSTimer         *m_cObjZigZagTimerPtr;
@property (nonatomic,copy) NSString        *m_cObjSprintTimerValuePtr;
@property (nonatomic,copy) NSString        *m_cObjSprintTotalTimePtr;
@property (nonatomic,copy) NSString        *m_cObjZigZagTimerValuePtr;
@property (nonatomic,copy) NSString        *m_cObjZigZagTotalTimePtr;
@property (nonatomic,copy) NSString        *m_cAthleteId;
@property (nonatomic,retain)    AthleteLog      *m_cObjAthletelogPtr;
@property (nonatomic,retain)UITableView     *m_cObjVerJumpTableViewPtr;
@property (nonatomic,retain)UITableView     *m_cObjZigZagTableViewPtr;
@property (nonatomic,retain)UILabel         *m_cObjSprintTimeLabel;
@property (nonatomic,retain)UILabel         *m_cObjZigZagTimeLabel;
@property (nonatomic,retain)UILabel         *m_cObjZigZagTimeLabel2;
@property (nonatomic,copy)NSString        *m_cObjSprintTimePtr;
@property (nonatomic,copy)NSString        *m_cObjZigZagTimePtr;
@property (nonatomic,copy)NSString        *m_cObjZigZagTimePtr2;
@property (nonatomic,copy)NSString       *m_cObjZigZagTimerValuePtr2;
@property (nonatomic,retain)NSTimer                 *m_cObjZigZagTimerPtr2;
@property (nonatomic,copy)NSString       *m_cObjZigZagTotalTimePtr2;
@property (nonatomic,retain)AVAudioPlayer           *m_cObjAlarmSoundPtr;

-(void)createElements;
-(void)createControls;
-(void)createVerticalJumpPicker;
-(void)createTimerPicker;
-(void)updateZigZagTimer1 : (id)sender;
-(void)pickerDoneClicked:(id)pSender;


@end
