//
//  AthleteDetailTableViewCell.h
//  GCN Combine
//
//  Created by Debi Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleteDetailTableViewCell : UITableViewCell
{
    UIImageView *m_cAthleteImageViewPtr;
    UILabel     *m_cAthleteNamePtr;
}

@property (nonatomic,retain) UIImageView *m_cAthleteImageViewPtr;
@property (nonatomic,retain) UILabel     *m_cAthleteNamePtr;

@end
