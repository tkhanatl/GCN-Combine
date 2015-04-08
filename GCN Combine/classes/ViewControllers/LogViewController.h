//
//  LogViewController.h
//  GCN Combine
//
//  Created by DP Samantrai on 02/03/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
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
#import "Athlete.h"
#import "ImageHandlerDelegate.h"


@interface LogViewController : UIViewController <ServerTransactionDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AVAudioPlayerDelegate,ImageHandlerDelegate>
{
    
    Tests                   *m_cObjTestDataPtr;
    AthleteLog              *m_cObjAthletelogPtr;

    BOOL                    IsTextFieldActive;
    UIBarButtonItem         *m_cObjSaveButton;
    NSMutableArray          *m_cObjTimerArrayPtr;
    UITextField             *m_cObjCurrentTextFieldPtr;

    UIScrollView            *m_cObjScrollViewPtr; //scroll view for 
    NSTimer                 *m_cObjSprintTimerPtr;//Timer for all the Accuaracy Countdown
    AVAudioPlayer           *m_cObjAlarmSoundPtr;//AVAudioPlayer for Alarm 
    UITextField             *m_cObjSprintTextFieldPtr;//Sprint Textfield for Count
    UILabel                 *m_cObjInstructionLabelPtr;//Instruction Label For all Accuracy
    UILabel                 *m_cObjSprintTimeLabelPtr;//Time Label to show the countdown Timer
    UIButton                *m_cObjSprintClearBtnPtr;//Timer Clear Button to reset the Timer
    UIButton                *m_cObjSprintTimerBtnPtr;//Timer Start Button to start the CountDown
    UILabel                 *m_cObjChoiceLabelPtr;//Choice Label for Integer Count in Accuracy Screens
    UIButton                *m_cObjeditTimerButtonPtr;//Edit Timer button for Countdown Accuracy
    UILabel                 *m_cObjeditTimerMessagePtr;//Edit Timer Message for Countdown Accuracy
    NSString                *m_cObjSprintTimerValuePtr;//Counting the remaining time in countdown     

    UIPickerView            *m_cObjTimerPickerViewPtr;//Timer Selection Picker for accuracy
    NSMutableArray          *m_cObjTimerArrayValuesPtr;//Timer Selection Array Values for accuracy
    NSString                *m_cObjCountDownTimerValue;//Count Down Timer Value 
    UIToolbar               *m_cObjkeyboardDoneButtonViewPtr;//keyboard done button for picker 
    
    UITextField             *m_cObjActiveTextFieldPtr;//Active TextField for Integer Capture in Jump Tests
    
    
    NSString                *m_cObjSprintTimePtr;//Sprint Time for Calculating Time in Datatype Mins & Secs
    UILabel                 *m_cObjSprintTimeLabel;//Mins & Secs Datatype
    
    NSString                *m_cAthleteId;//Saving AthleteID to send Logs By AthID
    
    BOOL                     isServerTransactionSucceed;
    
    UITableView             *m_cObjVerJumpTableViewPtr;//Vertical Jump tableview
    UIPickerView            *m_cObjverticalJumpPicker;//Vertical Jump Picker for Inches
    NSMutableArray          *m_cObjVerticalJumpChoiceListPtr;//Vertical Jump Choice List
    UISegmentedControl      *m_cObjSegementCtrlPtr;//Prev & Next Segemnt
    UIToolbar               *m_cObjToolBarPtr;//Prev,Next Toolbar for Table
    
    BOOL                         isValidationFailed;
    NSMutableDictionary          *m_cObjTimerLabelDictPtr;//Timer Label Array for multiple Timers
    NSMutableDictionary          *m_cObjSprintTimeDictPtr;//Sprint Time for each timer stores for every millisecond
    NSMutableDictionary          *m_cObjSprintTimerDictPtr;//Sprint Timer for each Timer stores
    NSMutableDictionary          *m_cObjSprintTotalTimeDictPtr;
    
    
    Athlete                      *m_cObjAthleteDetailsDataPtr;//Athlete object to check for Athlete added in offline mode
    BOOL                          isAddedinOfflineMode;
}

@property (nonatomic)           BOOL                    isServerTransactionSucceed;
@property (nonatomic,retain)    Tests                   *m_cObjTestDataPtr;
@property (nonatomic,retain)    AthleteLog              *m_cObjAthletelogPtr;
@property (nonatomic,copy)      NSString                *m_cObjCountDownTimerValue;
@property (nonatomic,retain)    NSMutableArray          *m_cObjTimerArrayPtr;
@property (nonatomic,retain)    UIScrollView            *m_cObjScrollViewPtr;
@property (nonatomic,retain)    AVAudioPlayer           *m_cObjAlarmSoundPtr;
@property (nonatomic,retain)    UITextField             *m_cObjSprintTextFieldPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjInstructionLabelPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjSprintTimeLabelPtr;
@property (nonatomic,retain)    UIButton                *m_cObjSprintClearBtnPtr;
@property (nonatomic,retain)    UIButton                *m_cObjSprintTimerBtnPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjChoiceLabelPtr;
@property (nonatomic,retain)    UIButton                *m_cObjeditTimerButtonPtr;
@property (nonatomic,retain)    UILabel                 *m_cObjeditTimerMessagePtr;
@property (nonatomic,retain)    NSMutableArray          *m_cObjTimerArrayValuesPtr;
@property (nonatomic,retain)    UIPickerView            *m_cObjTimerPickerViewPtr;
@property (nonatomic,retain)    UIToolbar               *m_cObjkeyboardDoneButtonViewPtr;
@property (nonatomic,retain)    UITextField             *m_cObjActiveTextFieldPtr;
@property (nonatomic,retain)    UISegmentedControl      *m_cObjSegementCtrlPtr;
@property (nonatomic,retain)    UIPickerView            *m_cObjverticalJumpPicker;
@property (nonatomic,retain)    NSMutableArray          *m_cObjVerticalJumpChoiceListPtr;
@property (nonatomic,copy)      NSString                *m_cObjSprintTimerValuePtr;
@property (nonatomic,copy)      NSString                *m_cObjSprintTotalTimePtr;
@property (nonatomic,copy)      NSString                *m_cObjSprintTimePtr;
@property (nonatomic,retain)    UILabel                 *m_cObjSprintTimeLabel;
@property (nonatomic,copy)      NSString                *m_cAthleteId;
@property (nonatomic,retain)    UITableView             *m_cObjVerJumpTableViewPtr;
@property (nonatomic,retain)    UIToolbar               *m_cObjToolBarPtr;
@property (nonatomic)           BOOL                    isValidationFailed;

@property (nonatomic,retain)    NSMutableDictionary     *m_cObjTimerLabelDictPtr;
@property (nonatomic,retain)    NSMutableDictionary     *m_cObjSprintTimeDictPtr;
@property (nonatomic,retain)    NSMutableDictionary     *m_cObjSprintTimerDictPtr;
@property (nonatomic,retain)    NSMutableDictionary     *m_cObjSprintTotalTimeDictPtr;

@property (nonatomic,retain)    Athlete                 *m_cObjAthleteDetailsDataPtr;
@property (nonatomic)           BOOL                     isAddedinOfflineMode;

-(void)createElements;
-(void)createControls;
-(void)createVerticalJumpPicker;
-(void)createTimerPicker;
-(void)pickerDoneClicked:(id)pSender;
//-(void)adjustScrool;
- (void)onSegmentBtnClicked:(id)pObjSenderPtr;


@end
