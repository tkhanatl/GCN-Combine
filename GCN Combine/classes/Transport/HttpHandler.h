//
//  HttpController.h
//  GCN Combine
//
//  Created by DP Samantrai on 06/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "Athlete.h"
#import "AthleteLog.h"
#import "UserInfo.h"
#import "ServerTransactionDelegate.h"
#import "Tests.h"
 

@interface HttpHandler : NSObject
{
    NSMutableData           *responseData;
    NSString                *base64formatImagePtr;
    NSInteger               requestisFor;
    NSMutableArray          *lObjAthleteArrayPtr;
    Athlete                 *m_cObjAthletePtr;
    BOOL                    IsUpdateSuccess;
    BOOL                    ISUploadlogSuccess;
    
    
    
    NSURLConnection				*m_cObjURLConnectionPtr;
	NSMutableURLRequest			*m_cObjURLRequestPtr;
	NSMutableData				*m_cObjWebDataPtr;
    NSMutableArray              *m_cObjRequestHeadersPtr;
	NSString                    *m_cObjServerUrlPtr;
	NSString					*m_cObjErrorMessagePtr;
    
    
    NSString                    *m_cObjPhotoPathPtr;
    NSString                    *m_cAthleteId;
	NSString					*m_cObjErrorStrPtr;
    NSInteger                   m_cErrorCode;
    BOOL                        m_cSuccess;
    BOOL                        isPhotoDownloadSucceed;
    
    
    
    NSString                    *m_cObjLogpostURLPtr;
    NSString                    *m_cObjAddAthleteURLPtr;
    NSString                    *m_cObjDownloadAthListURLPtr;
    
    NSString                    *m_cObjDownloadAthDetailPtr;
    NSString                    *m_cObjLoginRequestURLPtr;
    NSString                    *m_cObjDownloadImageURLPtr;
    
    NSString                    *m_cObjDownloadCombineIDsURLPtr;
    NSString                    *m_cObjDownloadCombineTestsURLPtr;
    NSString                    *m_cObjUploadImageURLPtr;
//    NSString                    *m_cObjCombineIdPtr;
    NSInteger                    m_cObjCombineIdPtr;
    //sougat added this on 28/8/13
     NSString                    *m_cObjDownloadAthListURLForCombineIdPtr;
    NSArray                    *m_cObjAthleteListPtr;
    NSMutableDictionary                                 *m_cObjResponseArray; 
   
    
    id<ServerTransactionDelegate>			m_cObjServerTransactionDelegatePtr;
}
@property(nonatomic,retain)    NSURLConnection				*m_cObjURLConnectionPtr;
//@property (nonatomic,copy)    NSString                    *m_cObjCombineIdPtr;
@property (nonatomic,assign)    NSInteger                   m_cObjCombineIdPtr;
@property (nonatomic,copy)    NSString                    *m_cObjUploadImageURLPtr;
@property (nonatomic,copy)    NSString                    *m_cObjDownloadCombineIDsURLPtr;
@property (nonatomic,copy)    NSString                    *m_cObjDownloadCombineTestsURLPtr;
@property (nonatomic,copy)    NSString                    *m_cObjDownloadImageURLPtr;
@property (nonatomic,copy)    NSString                    *m_cObjLoginRequestURLPtr;
@property (nonatomic,copy)    NSString                    *m_cObjLogpostURLPtr,*m_cObjAddAthleteURLPtr,*m_cObjDownloadAthListURLPtr,*m_cObjDownloadAthDetailPtr;
@property (nonatomic)    BOOL                        isPhotoDownloadSucceed;
@property(nonatomic, assign) id<ServerTransactionDelegate>  m_cObjServerTransactionDelegatePtr;
@property (nonatomic,retain) NSMutableArray      *lObjAthleteArrayPtr;
@property (nonatomic,retain) Athlete             *m_cObjAthletePtr;
@property (nonatomic)        BOOL                IsUpdateSuccess;
@property (nonatomic)        BOOL                ISUploadlogSuccess;
@property (nonatomic,copy)   NSString            *m_cObjPhotoPathPtr;
@property (nonatomic,copy) NSString             *m_cAthleteId;
//sougat added this 28/8/13
@property (nonatomic,copy)NSString                    *m_cObjDownloadAthListURLForCombineIdPtr;
@property(nonatomic,retain) NSArray                    *m_cObjAthleteListPtr;
@property(nonatomic,retain)NSMutableDictionary                                 *m_cObjResponseArray; 

 
-(NSString *)base64forData:(NSData *)data;
-(NSData *)base64DataFromString: (NSString *)string;


-(void)loginRequest:(UserInfo *)pObjUserInfoPtr deviceId:(NSString *)pObjDeviceIdPtr;
#if 0
-(void)handleLogin;
#endif
-(void)cancelDownload;
-(void)handleUpload;


-(void)downloadRequest:(UserInfo *)pObjUserInfoPtr;
-(void)handleDownloadAthleteList;

 

-(void)handleUpdateAthlete;
-(void)handleUpdateLog;
 
 

-(void)runWithRequest:(NSString *)pObjURL requestString:(NSString *)pObjRequestBodyPtr requestMethod:(NSString *)pObjrqstMethod;
-(void)uploadRequest :(Athlete *)pObjAthletePtr isNewAthlete:(BOOL)isForNewAthlete;
#if 0
-(void)uploadLog:(AthleteLog *)pObjAthleteLogPtr:(NSInteger)logIndex:(NSString *)pAthleteId;
#else
-(void)uploadLog :(AthleteLog *)pObjAthleteLogPtr Tests:(Tests *)pObjTestsPtr;
#endif
#if 0
-(void)uploadImage;
#endif
#if 0
-(void)handleUploadImage;
#endif

 
-(void)downloadAthleteImage :(NSString *)pObjAthleteId AthImageName:(NSString *)pObjAthleteImageNamePtr;
 

-(void)handleAthletePhotoDownload;
-(void)downloadAthleteInformation:(Athlete *)pObjAthletePtr;
-(void)informAthleteDetailDownloadNotificationToDelegate;
-(void)handleAthletePhotoUpload;

-(void)handleAthleteDetailDownload;


-(void)downloadCombineIds;
-(void)downloadCombineTests:(NSInteger )pObjCombineIDPtr;
-(void)uploadImage:(Athlete *)pObjAthletePtr;
-(void)savePhoto:(NSString *)pObjPhotoUrlPtr;

- (void)initializeControlText;


@end
