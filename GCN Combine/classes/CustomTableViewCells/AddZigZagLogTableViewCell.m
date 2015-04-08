//
//  AddZigZagLogTableViewCell.m
//  GCN Combine
//
//  Created by DP Samantrai on 28/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AddZigZagLogTableViewCell.h"
#import "Macros.h"
#import <QuartzCore/QuartzCore.h>


@implementation AddZigZagLogTableViewCell

@synthesize m_cObjInstructionLabelPtr,m_cObjSprintTextFieldPtr,m_cObjSprintTimerBtnPtr,m_cObjSprintTimeLabelPtr,m_cObjSprintLabelPtr,m_cObjSprintClearBtnPtr;
@synthesize m_cObjZigzagHeaderLabelPtr;



- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)tag
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       m_cObjZigzagHeaderLabelPtr = (UILabel *)nil;
        m_cObjZigzagHeaderLabelPtr = [[UILabel alloc] init];
        m_cObjZigzagHeaderLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjZigzagHeaderLabelPtr.textAlignment = UITextAlignmentCenter;
        m_cObjZigzagHeaderLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjZigzagHeaderLabelPtr.numberOfLines =2;
        m_cObjZigzagHeaderLabelPtr.textColor = [UIColor orangeColor];
        m_cObjZigzagHeaderLabelPtr.font =[UIFont fontWithName:@"STHeitiTC-Medium" size:17];
        [self.contentView addSubview:m_cObjZigzagHeaderLabelPtr];
        
        m_cObjSprintTimeLabelPtr = (UILabel *)nil;
        m_cObjSprintTimeLabelPtr = [[UILabel alloc] init];
        m_cObjSprintTimeLabelPtr.backgroundColor = [UIColor clearColor];
        m_cObjSprintTimeLabelPtr.textAlignment = UITextAlignmentCenter;
        m_cObjSprintTimeLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjSprintTimeLabelPtr.numberOfLines = 2;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            m_cObjSprintTimeLabelPtr.textColor = [UIColor blackColor];
        }
        else
        {
             m_cObjSprintTimeLabelPtr.textColor = [UIColor whiteColor];
        }
        
        m_cObjSprintTimeLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:44];
        m_cObjSprintTimeLabelPtr.text = @"00:00.00 secs";
        [self.contentView addSubview:m_cObjSprintTimeLabelPtr];
        
        m_cObjSprintTimerBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_cObjSprintTimerBtnPtr setBackgroundColor:[UIColor orangeColor]];
        [m_cObjSprintTimerBtnPtr.titleLabel setTextColor:[UIColor whiteColor]];
        m_cObjSprintTimerBtnPtr.layer.cornerRadius = 10.0;
        [m_cObjSprintTimerBtnPtr setTitle:NSLocalizedString(@"Start", @"") forState:UIControlStateNormal];
        m_cObjSprintTimerBtnPtr.titleLabel.textAlignment = UITextAlignmentCenter;
        m_cObjSprintTimerBtnPtr.layer.borderWidth = 3.0f;
        m_cObjSprintTimerBtnPtr.layer.borderColor = [UIColor colorWithRed:-51 green:-51 blue:-51 alpha:0.8].CGColor;
        [self.contentView addSubview:m_cObjSprintTimerBtnPtr];
                    
        m_cObjSprintClearBtnPtr = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_cObjSprintClearBtnPtr setBackgroundColor:[UIColor grayColor]];
        [m_cObjSprintClearBtnPtr.titleLabel setTextColor:[UIColor whiteColor]];
        m_cObjSprintClearBtnPtr.layer.cornerRadius = 10.0;
        [m_cObjSprintClearBtnPtr setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
        m_cObjSprintClearBtnPtr.titleLabel.textAlignment = UITextAlignmentCenter;
        m_cObjSprintClearBtnPtr.layer.borderWidth = 3.0f;
        m_cObjSprintClearBtnPtr.layer.borderColor = [UIColor colorWithRed:-51 green:-51 blue:-51 alpha:0.8].CGColor;
       [self.contentView addSubview:m_cObjSprintClearBtnPtr];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lRect = CGRectZero;
    lRect = self.contentView.frame;
 
    m_cObjZigzagHeaderLabelPtr.frame = CGRectMake(55.0, 2.0, 180.0, 25.0);
    m_cObjSprintTimeLabelPtr.frame = CGRectMake(45, CGRectGetMaxY(m_cObjZigzagHeaderLabelPtr.frame)+5.0, 200.0, 44.0);
    m_cObjSprintClearBtnPtr.frame = CGRectMake(25, CGRectGetMaxY(m_cObjSprintTimeLabelPtr.frame)+2.0 , 125.0, 40.0);
    m_cObjSprintTimerBtnPtr.frame  = CGRectMake(CGRectGetMinX(m_cObjSprintClearBtnPtr.frame)+CGRectGetWidth(m_cObjSprintClearBtnPtr.frame) + 10.0, CGRectGetMaxY(m_cObjSprintTimeLabelPtr.frame)+2.0,125.0, 40.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{

    SAFE_RELEASE(m_cObjZigzagHeaderLabelPtr)
    SAFE_RELEASE(m_cObjSprintTimeLabelPtr)
    [super dealloc];
}

@end
