//
//  AthleteDetailTableViewCell.m
//  GCN Combine
//
//  Created by Debi Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "AthleteDetailTableViewCell.h"
#import "Macros.h"
#import <QuartzCore/QuartzCore.h>

@implementation AthleteDetailTableViewCell
@synthesize m_cAthleteImageViewPtr,m_cAthleteNamePtr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Custom initialization
        m_cAthleteImageViewPtr = (UIImageView *)nil;
        m_cAthleteNamePtr = (UILabel *)nil;
        
        m_cAthleteImageViewPtr = [[UIImageView alloc] init];
		[self.contentView addSubview:m_cAthleteImageViewPtr];
        
        m_cAthleteImageViewPtr.layer.cornerRadius = 5.0;
        m_cAthleteImageViewPtr.layer.masksToBounds = YES;
        m_cAthleteImageViewPtr.layer.borderColor = [UIColor clearColor].CGColor;
        m_cAthleteImageViewPtr.layer.borderWidth = 1.0;
        
        m_cAthleteNamePtr = [[UILabel alloc] init];
		m_cAthleteNamePtr.backgroundColor = [UIColor clearColor];
		m_cAthleteNamePtr.textAlignment = UITextAlignmentLeft;
		m_cAthleteNamePtr.lineBreakMode = UILineBreakModeTailTruncation;
        m_cAthleteNamePtr.numberOfLines = 2;
		m_cAthleteNamePtr.textColor = [UIColor colorWithRed:(95.0/255.0) green:(94.0/255.0) blue:(95.0/255.0) alpha:1];
        m_cAthleteNamePtr.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
		[self.contentView addSubview:m_cAthleteNamePtr];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lContentRect = self.contentView.bounds;
	CGFloat lBoundsX = lContentRect.origin.x + 7;
	CGFloat lYOffSet = 7.0;    
        
     m_cAthleteImageViewPtr.frame = CGRectMake(lBoundsX ,lYOffSet, 30.0, 29.0);
    
    lYOffSet = 15.0;
    lBoundsX += (m_cAthleteImageViewPtr.frame.size.width +15.0);
    m_cAthleteNamePtr.frame = CGRectMake(lBoundsX ,lYOffSet, lContentRect.size.width - 50.0, 17.0);
    self.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16.0];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.textLabel.shadowColor = [UIColor clearColor];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)dealloc
{
    
    SAFE_RELEASE(m_cAthleteImageViewPtr)
    SAFE_RELEASE(m_cAthleteNamePtr)
    [super dealloc];
}



@end
