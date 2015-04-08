//
//  AddAthleteDetailsTableViewCell.h
//  GCN Combine
//
//  Created by Debi Samantrai on 30/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAthleteDetailsTableViewCell : UITableViewCell
{
    UILabel          *m_cObjAthleteDetailLabelPtr;
    UITextField      *m_cObjAthleteTextFieldPtr;
    UIView           *m_cObjLineViewPtr;
    UITextView       *m_cObjAthleteTextViewPtr;
}

@property (nonatomic , retain) UILabel     *m_cObjAthleteDetailLabelPtr;
@property (nonatomic , retain)UITextField  *m_cObjAthleteTextFieldPtr;
@property (nonatomic , retain)UIView          *m_cObjLineViewPtr;
@property (nonatomic , retain) UITextView    *m_cObjAthleteTextViewPtr;

@end
