//
//  DBHandler.h
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Athlete.h"
#import "AthleteLog.h"
#import "UserInfo.h"
#import "Tests.h"
#import "CombineData.h"

@interface DBHandler : NSObject
{
    NSString            *m_cDatabaseNamePtr;
    NSString            *m_cDatabasePathPtr;
    sqlite3             *m_cDatabase;
    pthread_mutex_t     m_cMutex;
}


-(void)checkAndCreateDatabase;
-(void)initializeDatabase:(NSString *)pDBPath;

-(NSMutableArray *)getAllAthletes;
-(BOOL)insertAthelete: (Athlete *)pObjAthletePtr;
-(NSMutableArray *)getAllFavouriteAthletes;
-(BOOL) insertToFavourites : (Athlete *)pObjAthletePtr;
-(BOOL)removeFromFavourites:(Athlete *)pObjAthletePtr;
-(BOOL) deleteAthlete;
-(NSInteger)searchForAthleteDetail:(NSString *)pAthleteID;
-(BOOL)insertAtheleteDetail:(Athlete *)pObjAthletePtr;
-(BOOL)updateAthleteDetail:(Athlete *)pObjAthletePtr;
-(BOOL)updateAthlete:(Athlete *)pObjAthletePtr;
-(BOOL)insertNewAthlete : (Athlete *)pObjAthletePtr;
-(BOOL)updateNewAthlete : (Athlete *)pObjAthletePtr;


-(NSMutableArray *)getAthleteLogs: (NSString *)pAthleteId
                        CombineId:(NSInteger )pObjCombineId;
-(BOOL)insertAtheletePhoto :(NSString *)pAthleteId AthPhotoname:(NSString *)pObjAthletePhotoName;



-(BOOL) deleteAthleteLog : (NSString *)pAthleteId;
-(BOOL) deleteAthleteLog;


-(BOOL) insertLoginInfo : (UserInfo *)pObjLoginPtr;
-(BOOL) deleteLoginInfo;

-(void) clearAllRecords;
-(BOOL) deleteRecords : (NSString *)pObjSqlStatementPtr;
-(BOOL)clearLocalDB;



 -(NSMutableArray *)getAllAthletesAddedInOfflineMode;
-(UserInfo *)getUserInfo;
-(UserInfo *)getUserDetail;
-(NSMutableArray *)getAthleteLogsAddedinOfflineMode;
-(BOOL)UpdateLoginInfo;
-(BOOL)updateAthleteID :(Athlete *)pObjAthletePtr AthId:(NSString *)ptempAthId;
-(BOOL)updateLogTableAthleteID :(Athlete *)pObjAthletePtr AthId:(NSString *)ptempAthId;
-(BOOL)updateLogTableOfflineModeValue:(NSString *)pObjAthleteIdPtr :(NSInteger)pTestId;
-(NSMutableArray *)getAthletePhotoAddedInOfflineMode;


-(BOOL)deleteAthleteAddedInOfflinemode :(NSString *)pObjAthId;
-(BOOL)updateImageName :(Athlete *)pObjAthletePtr Athid:(NSString *)ptempAthId;
-(BOOL)updateAthleteFNLNID:(Athlete *)pObjAthletePtr;
-(BOOL)updateAthleteFlagsForImage: (Athlete *)pObjAthletePtr;


-(NSInteger)searchForCombineId:(NSInteger)pCombineID;
-(BOOL)insertCombineIDData:(CombineData *)pObjCombineDataPtr;
-(BOOL)insertCombineTests:(Tests *)pObjCombineTestListPtr;
-(NSMutableArray *)getCombineIds;
-(BOOL)updateTestResult :(AthleteLog *)pObjAthleteLogPtr Test:(Tests *)pObjTestPtr;
-(BOOL) insertTestResult :(AthleteLog *)pObjAthleteLogPtr Tests:(Tests *)pObjTestPtr;
-(BOOL)updateCombineIDData:(CombineData *)pObjCombineDataPtr;
-(int)CountRecordForTable:(NSString *)name;//sougata added this on 14 aug.
-(int)RetriveCountWithQuery:(NSString *)pQuery;



-(NSMutableDictionary *)getCombineIdAndNames;
//-(NSMutableArray *)getCombineTests:(NSString *)pObjCombineId:(NSString *)pObjCombineName;
-(NSMutableArray *)getCombineTests :(NSInteger)pObjCombineId CombineName:(NSString *)pObjCombineName;

-(NSMutableArray *)getAthleteLogsAddedinOfflineModeforAthlete:(NSString *)pObjAthleteIdPtr;
//-(NSInteger)CountRecordFromEachTable;//sougata added this on 14 aug.

@end
