//
//  ImageHandlerDelegate.h
//  GCN Combine
//
//  Created by DP Samantrai on 26/02/13.
//  Copyright (c) 2013 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageHandlerDelegate <NSObject>
@optional
-(void)InformPhotoDownloadSucceed;
-(void)InformPhotoDownloadFailed;
-(void)InformPhotoUploadSucceed;
-(void)InformPhotoUploadFailed;
@end
