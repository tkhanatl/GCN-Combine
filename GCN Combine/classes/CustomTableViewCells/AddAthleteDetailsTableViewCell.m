//
//  AddAthleteDetailsTableViewCell.m
//  GCN Combine
//
//  Created by Debi Samantrai on 30/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AddAthleteDetailsTableViewCell.h"
#import "Macros.h"

@implementation AddAthleteDetailsTableViewCell
@synthesize m_cObjAthleteDetailLabelPtr,m_cObjAthleteTextFieldPtr,m_cObjLineViewPtr,m_cObjAthleteTextViewPtr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom initialization
        m_cObjAthleteDetailLabelPtr = (UILabel *)nil;
        m_cObjAthleteTextFieldPtr = (UITextField *)nil;
        m_cObjLineViewPtr = (UIView *)nil;
        m_cObjAthleteTextViewPtr = (UITextView *)nil;
        
        m_cObjAthleteTextFieldPtr = [[UITextField alloc] init];
       m_cObjAthleteTextFieldPtr.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cObjAthleteTextFieldPtr.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_cObjAthleteTextFieldPtr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_cObjAthleteTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:17];
        m_cObjAthleteTextFieldPtr.returnKeyType = UIReturnKeyNext;
        m_cObjAthleteTextFieldPtr.backgroundColor = [UIColor clearColor];
        m_cObjAthleteTextFieldPtr.textColor = [UIColor blackColor];
        [self.contentView addSubview:m_cObjAthleteTextFieldPtr];
        
        m_cObjLineViewPtr = [[UIView alloc]init];
        m_cObjLineViewPtr.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:m_cObjLineViewPtr];
        
        m_cObjAthleteDetailLabelPtr = [[UILabel alloc] init];
        m_cObjAthleteDetailLabelPtr.textAlignment = UITextAlignmentLeft;
		m_cObjAthleteDetailLabelPtr.backgroundColor = [UIColor clearColor];
		m_cObjAthleteDetailLabelPtr.lineBreakMode = UILineBreakModeWordWrap;
        m_cObjAthleteDetailLabelPtr.numberOfLines = 3;
		m_cObjAthleteDetailLabelPtr.textColor = [UIColor blackColor];
        m_cObjAthleteDetailLabelPtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
		[self.contentView addSubview:m_cObjAthleteDetailLabelPtr];
        
        m_cObjAthleteTextViewPtr = [[UITextView alloc]init];
        m_cObjAthleteTextViewPtr.autocorrectionType = UITextAutocorrectionTypeNo;
        m_cObjAthleteTextViewPtr.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_cObjAthleteTextViewPtr.textAlignment = UITextAlignmentLeft;
        m_cObjAthleteTextViewPtr.font = [UIFont fontWithName:@"Helvetica" size:15];
        m_cObjAthleteTextViewPtr.returnKeyType = UIReturnKeyNext;
        m_cObjAthleteTextViewPtr.backgroundColor = [UIColor clearColor];
        m_cObjAthleteTextViewPtr.textColor = [UIColor blackColor];
        [self.contentView addSubview:m_cObjAthleteTextViewPtr];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lRect = CGRectZero;
    CGFloat lXOffset = {0.0};
    CGFloat lYOffset = {0.0};
    lRect = self.contentView.frame;
    lXOffset = lRect.origin.x;
    lYOffset = lRect.origin.y;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
       self.m_cObjAthleteDetailLabelPtr.frame = CGRectMake(lXOffset+5,lYOffset,100.0,lRect.size.height);
    }
    else
    {
       self.m_cObjAthleteDetailLabelPtr.frame = CGRectMake(lXOffset,lYOffset,100.0,lRect.size.height);
    }


    
    lXOffset = m_cObjAthleteDetailLabelPtr.frame.size.width;
    self.m_cObjLineViewPtr.frame = CGRectMake(lXOffset+9, lYOffset, 1.0, lRect.size.height);//sougata added this on 8/8/13
    lXOffset = m_cObjAthleteDetailLabelPtr.frame.size.width + m_cObjLineViewPtr.frame.size.width;
    self.m_cObjAthleteTextFieldPtr.frame = CGRectMake(lXOffset + SPACING+9, lYOffset, lRect.size.width - lXOffset - 4.0, lRect.size.height);
    self.m_cObjAthleteTextViewPtr.frame = CGRectMake(lXOffset + SPACING, lYOffset, lRect.size.width - lXOffset - 4.0, lRect.size.height);
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)dealloc
{
    
    SAFE_RELEASE(m_cObjAthleteDetailLabelPtr)
    SAFE_RELEASE(m_cObjAthleteTextFieldPtr)
    SAFE_RELEASE(m_cObjLineViewPtr)
    SAFE_RELEASE(m_cObjAthleteTextViewPtr)
    [super dealloc];
}


@end
