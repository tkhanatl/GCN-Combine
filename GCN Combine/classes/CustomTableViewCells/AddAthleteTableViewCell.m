//
//  AddAthleteTableViewCell.m
//  GCN Combine
//
//  Created by Debi Samantrai on 30/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AddAthleteTableViewCell.h"
#import "Macros.h"

@implementation AddAthleteTableViewCell
@synthesize m_cObjAthleteDetailTextFieldPtr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom initialization
        m_cObjAthleteDetailTextFieldPtr = (UITextField *)nil;
        m_cObjAthleteDetailTextFieldPtr = [[UITextField alloc] init];
       m_cObjAthleteDetailTextFieldPtr.autocorrectionType = UITextAutocorrectionTypeNo;
       m_cObjAthleteDetailTextFieldPtr.autocapitalizationType = UITextAutocapitalizationTypeNone;
        m_cObjAthleteDetailTextFieldPtr.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_cObjAthleteDetailTextFieldPtr.font = [UIFont fontWithName:@"Helvetica" size:17];
        m_cObjAthleteDetailTextFieldPtr.returnKeyType = UIReturnKeyNext;
        m_cObjAthleteDetailTextFieldPtr.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:m_cObjAthleteDetailTextFieldPtr];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lRect = CGRectZero;
        
    lRect = self.contentView.frame;
    lRect.size.width -= 10.0;
    NSLog(@"%f", lRect.size.width);
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.m_cObjAthleteDetailTextFieldPtr.frame = CGRectMake(5, 0, 215, 43.5);
    }
    else
    {
        self.m_cObjAthleteDetailTextFieldPtr.frame = lRect;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)dealloc
{
    SAFE_RELEASE(m_cObjAthleteDetailTextFieldPtr)
    [super dealloc];
    
}


@end
