//
//  AboutViewController.h
//  GCN Combine
//
//  Created by DP Samantrai on 29/11/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController 
{

    UIToolbar *m_cObjToolBarPtr;

    
}

@property (nonatomic,retain)UIToolbar *m_cObjToolBarPtr;


-(void)createLabels;
-(void)createToolbar;
-(id)initWithTabBar;

@end
