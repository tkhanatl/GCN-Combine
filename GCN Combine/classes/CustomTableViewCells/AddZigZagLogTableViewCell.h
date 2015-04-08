//
//  AddZigZagLogTableViewCell.h
//  GCN Combine
//
//  Created by DP Samantrai on 28/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddZigZagLogTableViewCell : UITableViewCell
{
  
    
    UILabel             *m_cObjInstructionLabelPtr;
    UITextField         *m_cObjSprintTextFieldPtr;
    UIButton            *m_cObjSprintTimerBtnPtr;
    UILabel             *m_cObjSprintTimeLabelPtr;
    UILabel             *m_cObjSprintLabelPtr;
    UIButton            *m_cObjSprintClearBtnPtr;
    UILabel             *m_cObjZigzagHeaderLabelPtr;
}

@property (nonatomic,retain)    UILabel             *m_cObjZigzagHeaderLabelPtr;
@property (nonatomic,retain)    UILabel             *m_cObjInstructionLabelPtr;
@property (nonatomic,retain)    UITextField         *m_cObjSprintTextFieldPtr;
@property (nonatomic,retain)    UIButton            *m_cObjSprintTimerBtnPtr;
@property (nonatomic,retain)    UILabel             *m_cObjSprintTimeLabelPtr;
@property (nonatomic,retain)    UILabel             *m_cObjSprintLabelPtr;
@property (nonatomic,retain)    UIButton            *m_cObjSprintClearBtnPtr;


- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)tag;



@end
