//
//  DBHandler.m
//  GCN Combine
//
//  Created by DP Samantrai on 01/12/12.
//  Copyright (c) 2012 DP Samantrai. All rights reserved.
//

#import "DBHandler.h"
#import <pthread.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppDelegate.h"
#import "Macros.h"
#import "Tests.h"

@implementation DBHandler


-(id)init
{
    self = [super init];
    if (nil != self) {
        pthread_mutex_init(&m_cMutex,NULL);
        
        
        m_cDatabaseNamePtr = @"Athlete.sqlite";
        NSArray     *lObjLibraryPathsPtr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString    *lObjLibraryDirPtr = [lObjLibraryPathsPtr objectAtIndex:0];
        m_cDatabasePathPtr = [lObjLibraryDirPtr stringByAppendingPathComponent:m_cDatabaseNamePtr];
        
        
        [self checkAndCreateDatabase];
        [self initializeDatabase:m_cDatabasePathPtr];
    }
    return self;
}

-(void) checkAndCreateDatabase
{
	pthread_mutex_lock(&m_cMutex);
    
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:m_cDatabasePathPtr];
	
	// If the database already exists then return without doing anything
	if(success)
	{
		pthread_mutex_unlock(&m_cMutex);
		return;
	}
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:m_cDatabaseNamePtr];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:m_cDatabasePathPtr error:nil];
    
    //Its not allocated or retained
	pthread_mutex_unlock(&m_cMutex);
}

-(void)initializeDatabase:(NSString *)pDBPath
{
	pthread_mutex_lock(&m_cMutex);
    NSString *lObjFkPtr = @"PRAGMA foreign_keys=ON";
    sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
    
	if(sqlite3_open([pDBPath UTF8String], &m_cDatabase) != SQLITE_OK)
	{
		// Even though the open failed, call close to properly clean up resources.
        sqlite3_close(m_cDatabase);
        DSLog(@"Failed to open database with message '%s'.", sqlite3_errmsg(m_cDatabase));
		m_cDatabase = nil;
	}
    else
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjFkPtr UTF8String],
										   -1, &lObjCompiledStatementPtr, NULL))
		{
			if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
				DSLog(@"Success");
		}
        
    }
    
	pthread_mutex_unlock(&m_cMutex);
}

-(NSMutableArray *)getAllAthletes
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	Athlete		    *lObjAthletePtr = nil;
	NSMutableArray	*lObjAthletesArrayPtr = nil;
    lObjAthletesArrayPtr = [[NSMutableArray alloc] init];
    
	sqlStatement = @"Select * from Athlete";
	
	if(nil != m_cDatabase)
	{
		if(sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				lObjAthletePtr = [[Athlete alloc] init];
				
                if(nil != sqlite3_column_text(compiledStatement, 0))
                    lObjAthletePtr.m_cAthleteId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				if(nil != sqlite3_column_text(compiledStatement, 1))
					lObjAthletePtr.m_cObjFirstNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if(nil != sqlite3_column_text(compiledStatement, 2))
					lObjAthletePtr.m_cObjLastNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                if(nil != sqlite3_column_text(compiledStatement, 3))
					lObjAthletePtr.m_cObjEmailIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                if(nil != sqlite3_column_text(compiledStatement, 4))
					lObjAthletePtr.m_cObjPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                if(nil != sqlite3_column_text(compiledStatement, 5))
					lObjAthletePtr.m_cObjAddressPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                if(nil != sqlite3_column_text(compiledStatement, 6))
					lObjAthletePtr.m_cPhotoNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				lObjAthletePtr.isFavouriteAthlete = sqlite3_column_int(compiledStatement, 7);
                if(nil != sqlite3_column_text(compiledStatement, 8))
					lObjAthletePtr.m_cObjSportsPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                if(nil != sqlite3_column_text(compiledStatement, 9))
					lObjAthletePtr.m_cObjSchoolNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                if(nil != sqlite3_column_text(compiledStatement, 10))
					lObjAthletePtr.m_cObjTeamNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                if(nil != sqlite3_column_text(compiledStatement, 11))
					lObjAthletePtr.m_cObjPositionPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                if(nil != sqlite3_column_text(compiledStatement, 12))
					lObjAthletePtr.m_cObjSchoolYearPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                if(nil != sqlite3_column_text(compiledStatement, 13))
					lObjAthletePtr.m_cObjCityNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                if(nil != sqlite3_column_text(compiledStatement, 14))
					lObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                if(nil != sqlite3_column_text(compiledStatement, 15))
					lObjAthletePtr.m_cObjZipCodePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                if(nil != sqlite3_column_text(compiledStatement, 16))
					lObjAthletePtr.m_cObjNickNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                if(nil != sqlite3_column_text(compiledStatement, 17))
					lObjAthletePtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                if(nil != sqlite3_column_text(compiledStatement, 18))
					lObjAthletePtr.m_cObjCellPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                if(nil != sqlite3_column_text(compiledStatement, 19))
					lObjAthletePtr.m_cObjTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];
                if(nil != sqlite3_column_text(compiledStatement, 20))
					lObjAthletePtr.m_cObjFB_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 20)];
                if(nil != sqlite3_column_text(compiledStatement, 21))
					lObjAthletePtr.m_cObjTwit_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 21)];
                if(nil != sqlite3_column_text(compiledStatement, 22))
					lObjAthletePtr.m_cObjPersonal_InfoPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 22)];
                if(nil != sqlite3_column_text(compiledStatement, 23))
					lObjAthletePtr.m_cObjSchoolCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 23)];
                if(nil != sqlite3_column_text(compiledStatement, 24))
					lObjAthletePtr.m_cObjClubCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 24)];
                if(nil != sqlite3_column_text(compiledStatement, 25))
					lObjAthletePtr.m_cObjBirthDatePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 25)];
                if(nil != sqlite3_column_text(compiledStatement, 26))
					lObjAthletePtr.m_cObjHeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 26)];
                if(nil != sqlite3_column_text(compiledStatement, 27))
					lObjAthletePtr.m_cObjWeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 27)];
                if(nil != sqlite3_column_text(compiledStatement, 28))
					lObjAthletePtr.m_cObjWingSpanPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 28)];
                if(nil != sqlite3_column_text(compiledStatement, 29))
					lObjAthletePtr.m_cObjReachPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 29)];
                if(nil != sqlite3_column_text(compiledStatement, 30))
					lObjAthletePtr.m_cObjShoeSizePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 30)];
                if(nil != sqlite3_column_text(compiledStatement, 31))
					lObjAthletePtr.m_cObjU_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 31)];
                if(nil != sqlite3_column_text(compiledStatement, 32))
					lObjAthletePtr.m_cObjActivePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 32)];
               
                lObjAthletePtr.m_cIsAddedinOfflineMode = sqlite3_column_int(compiledStatement,33);
                lObjAthletePtr.m_cIsPhotoAddedInOfflineMode = sqlite3_column_int(compiledStatement, 34);
                
                if(nil != sqlite3_column_text(compiledStatement, 35))
					lObjAthletePtr.m_cObjGenderPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 35)];
	
                
                [lObjAthletesArrayPtr addObject:lObjAthletePtr];
                            
                SAFE_RELEASE(lObjAthletePtr)
                
			}
			success = YES;
		}
		else
			DSLog(@"Error: failed to prepare statement for table Athlete with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
    
	if (success)
	{
		return [lObjAthletesArrayPtr autorelease];
	}
	else 
	{
       SAFE_RELEASE(lObjAthletesArrayPtr)
       return nil;
	}
}
//Narasimhaiah added to store the Combine ID List 28-2-13 - start
-(NSInteger)searchForCombineId:(NSInteger)pCombineID
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && pCombineID  != -1)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from CombineTestID where CombineID = %d",
							   pCombineID];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
    }
    pthread_mutex_unlock(&m_cMutex);
    return lRowCount;
}
-(BOOL)insertCombineIDData:(CombineData *)pObjCombineDataPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
    
	sqlStatement = [NSString stringWithFormat:@"Insert into CombineTestID (CombineID, CombineName, sportstype, StartDate, EndDate, Status) Values (?, ?, ?, ?, ?, ?)"];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
//            sqlite3_bind_text(compiledStatement, 1, [pObjCombineDataPtr.m_cObjCombineIDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 1, pObjCombineDataPtr.m_cObjCombineId);
            sqlite3_bind_text(compiledStatement, 2, [pObjCombineDataPtr.m_cObjCombineName UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 3, [pObjCombineDataPtr.sportstype UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 3, pObjCombineDataPtr.sportstype);
            sqlite3_bind_text(compiledStatement, 4, [pObjCombineDataPtr.m_cObjStartDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [pObjCombineDataPtr.m_cObjEndDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [pObjCombineDataPtr.m_cObjStatusPtr UTF8String], -1, SQLITE_TRANSIENT);
            
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Combine Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Combine table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));

//			DSLog(@"Error: failed to prepare Combine table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
-(BOOL)updateCombineIDData:(CombineData *)pObjCombineDataPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from CombineTestID where CombineID = %d",pObjCombineDataPtr.m_cObjCombineId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.

            //"Insert into CombineTestID (CombineID, CombineName, sportstype, StartDate, EndDate, Status) Values (?, ?, ?, ?, ?, ?)"
            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update CombineTestID set\
								   CombineID= ?, CombineName = ?, sportstype = %d , StartDate = ?, EndDate = ?, Status = ? where CombineID = %d",pObjCombineDataPtr.sportstype,pObjCombineDataPtr.m_cObjCombineId];

            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					//            sqlite3_bind_text(compiledStatement, 1, [pObjCombineDataPtr.m_cObjCombineIDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 1, pObjCombineDataPtr.m_cObjCombineId);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjCombineDataPtr.m_cObjCombineName UTF8String], -1, SQLITE_TRANSIENT);
                    //            sqlite3_bind_text(compiledStatement, 3, [pObjCombineDataPtr.sportstype UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 3, pObjCombineDataPtr.sportstype);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 4, [pObjCombineDataPtr.m_cObjStartDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 5, [pObjCombineDataPtr.m_cObjEndDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 6, [pObjCombineDataPtr.m_cObjStatusPtr UTF8String], -1, SQLITE_TRANSIENT);
                    
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
-(BOOL)insertCombineTests:(Tests *)pObjCombineTestListPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
	sqlStatement = [NSString stringWithFormat:@"Insert into Tests (TestID, CombineID, TestName, TestType, TestDataType, TestAttempts,TestSequence) Values (?, ?, ?, ?, ?, ?, ?)"];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
            
            sqlite3_bind_int(compiledStatement, 1, pObjCombineTestListPtr.m_cObjTestId);
            sqlite3_bind_int(compiledStatement, 2, pObjCombineTestListPtr.m_cObjCombineId);
//            sqlite3_bind_text(compiledStatement, 2, [pObjCombineTestListPtr.m_cObjCombineIdPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [pObjCombineTestListPtr.m_cObjTestNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [pObjCombineTestListPtr.m_cObjTestTypePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [pObjCombineTestListPtr.m_cObjTestDataTypePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [pObjCombineTestListPtr.m_cObjTestAttemptsPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 7, pObjCombineTestListPtr.m_cObjTestSequence);
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Athlete Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Athlete table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
//Narasimhaiah added to get Combines
-(NSMutableArray *)getCombineIds
{
    NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    NSMutableArray      *lObjCombineIdArrayPtr = (NSMutableArray *)nil;
    

      lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from CombineTestID"];
    
    if((NSString *)nil != lObjSqlStatementPtr)
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
        {
            //Get the number of records.
            if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
                lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
             SAFE_RELEASE(lObjSqlStatementPtr)
        }
        else{
            DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    }
    if (lRowCount > 0) {
        
        lObjCombineIdArrayPtr = [[NSMutableArray alloc] init];
        
        lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select CombineID from CombineTestID"];
        
        if((NSString *)nil != lObjSqlStatementPtr)
        {
            if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
            {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    NSString *lObjtempIdPtr = (NSString *)nil;
                    
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,0))
                        lObjtempIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,0)];
                    
                    [lObjCombineIdArrayPtr addObject:lObjtempIdPtr];
                  
                }
                lRetVal = YES;
            }
            else
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
        }
         SAFE_RELEASE(lObjSqlStatementPtr)
    }
    else
    {
        lRetVal = NO;
     }
    
    pthread_mutex_unlock(&m_cMutex);
    
    if (lRetVal)
    {
        return [lObjCombineIdArrayPtr autorelease];
    }
    else
    {
        SAFE_RELEASE(lObjCombineIdArrayPtr)
        return nil;
    }
    return nil;
}
-(NSMutableDictionary *)getCombineIdAndNames
{
    NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    NSMutableDictionary *lObjCombineIdAndNamesDictPtr = (NSMutableDictionary *)nil;
    lObjCombineIdAndNamesDictPtr = [NSMutableDictionary dictionary];

    lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from CombineTestID"];
    
    if((NSString *)nil != lObjSqlStatementPtr)
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
        {
            //Get the number of records.
            if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
                lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
        else{
            DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    }
    if (lRowCount > 0) {
        
        
        lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select CombineID,CombineName from CombineTestID"];
        
        if((NSString *)nil != lObjSqlStatementPtr)
        {
            if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
            {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    NSString *lObjtempIdPtr = (NSString *)nil;
                    NSString *lObjtempNamePtr = (NSString *)nil;
                    
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,0))
                        lObjtempIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,0)];
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,0))
                        lObjtempNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,1)];
                    
                    [lObjCombineIdAndNamesDictPtr setObject:lObjtempNamePtr forKey:lObjtempIdPtr];
                }
                lRetVal = YES;
            }
            else
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
        }
        SAFE_RELEASE(lObjSqlStatementPtr)
    }
    else
    {
        lRetVal = NO;
    }
    pthread_mutex_unlock(&m_cMutex);
    
    if (lRetVal)
    {
        return lObjCombineIdAndNamesDictPtr;
    }
    else
    {
//        SAFE_RELEASE(lObjCombineIdAndNamesArrayPtr)
        return nil;
    }
    
    return nil;
}
-(NSMutableArray *)getCombineTests :(NSInteger )pObjCombineId 
                        CombineName:(NSString *)pObjCombineName
{
    NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
    NSMutableArray      *lObjCombineTestsArrayPtr = (NSMutableArray *)nil;
    lObjCombineTestsArrayPtr = [[NSMutableArray alloc] init];
        
        lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * From Tests Where CombineID = %d",pObjCombineId];
        
        if((NSString *)nil != lObjSqlStatementPtr)
        {
            if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
            {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    Tests *lObjTestsPtr = (Tests *)nil;
                    lObjTestsPtr = [[Tests alloc] init];
                    
                    lObjTestsPtr.m_cObjTestId = sqlite3_column_int(lObjCompiledStatementPtr, 0);
                    lObjTestsPtr.m_cObjCombineId = sqlite3_column_int(lObjCompiledStatementPtr, 1);
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,2))
                        lObjTestsPtr.m_cObjTestNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,2)];
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,3))
                        lObjTestsPtr.m_cObjTestTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,3)];
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,4))
                        lObjTestsPtr.m_cObjTestDataTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,4)];
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,5))
                        lObjTestsPtr.m_cObjTestAttemptsPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,5)];
                    lObjTestsPtr.m_cObjTestSequence = sqlite3_column_int(lObjCompiledStatementPtr, 6);
                    
                    [lObjCombineTestsArrayPtr addObject:lObjTestsPtr];
                    SAFE_RELEASE(lObjTestsPtr)
                    
                }
                lRetVal = YES;
            }
            else
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    return lObjCombineTestsArrayPtr;
}
//Narasimhaiah added to store the Combine ID List 28-2-13 - end

-(NSMutableArray *)getAllAthletesAddedInOfflineMode
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	Athlete		    *lObjAthletePtr = nil;
	NSMutableArray	*lObjAthletesArrayPtr = nil;
    lObjAthletesArrayPtr = [[NSMutableArray alloc] init];

	
	sqlStatement = @"Select * from Athlete where IsAddedInOfflineMode = 1";
	
	if(nil != m_cDatabase)
	{
		if(sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				lObjAthletePtr = [[Athlete alloc] init];
				
                if(nil != sqlite3_column_text(compiledStatement, 0))
                    lObjAthletePtr.m_cAthleteId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				if(nil != sqlite3_column_text(compiledStatement, 1))
					lObjAthletePtr.m_cObjFirstNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if(nil != sqlite3_column_text(compiledStatement, 2))
					lObjAthletePtr.m_cObjLastNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                if(nil != sqlite3_column_text(compiledStatement, 3))
					lObjAthletePtr.m_cObjEmailIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                if(nil != sqlite3_column_text(compiledStatement, 4))
					lObjAthletePtr.m_cObjPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                if(nil != sqlite3_column_text(compiledStatement, 5))
					lObjAthletePtr.m_cObjAddressPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                if(nil != sqlite3_column_text(compiledStatement, 6))
					lObjAthletePtr.m_cPhotoNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				lObjAthletePtr.isFavouriteAthlete = sqlite3_column_int(compiledStatement, 7);
                if(nil != sqlite3_column_text(compiledStatement, 8))
					lObjAthletePtr.m_cObjSportsPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                if(nil != sqlite3_column_text(compiledStatement, 9))
					lObjAthletePtr.m_cObjSchoolNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                if(nil != sqlite3_column_text(compiledStatement, 10))
					lObjAthletePtr.m_cObjTeamNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                if(nil != sqlite3_column_text(compiledStatement, 11))
					lObjAthletePtr.m_cObjPositionPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                if(nil != sqlite3_column_text(compiledStatement, 12))
					lObjAthletePtr.m_cObjSchoolYearPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                if(nil != sqlite3_column_text(compiledStatement, 13))
					lObjAthletePtr.m_cObjCityNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                if(nil != sqlite3_column_text(compiledStatement, 14))
					lObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                if(nil != sqlite3_column_text(compiledStatement, 15))
					lObjAthletePtr.m_cObjZipCodePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                if(nil != sqlite3_column_text(compiledStatement, 16))
					lObjAthletePtr.m_cObjNickNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                if(nil != sqlite3_column_text(compiledStatement, 17))
					lObjAthletePtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                if(nil != sqlite3_column_text(compiledStatement, 18))
					lObjAthletePtr.m_cObjCellPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                if(nil != sqlite3_column_text(compiledStatement, 19))
					lObjAthletePtr.m_cObjTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];
                if(nil != sqlite3_column_text(compiledStatement, 20))
					lObjAthletePtr.m_cObjFB_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 20)];
                if(nil != sqlite3_column_text(compiledStatement, 21))
					lObjAthletePtr.m_cObjTwit_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 21)];
                if(nil != sqlite3_column_text(compiledStatement, 22))
					lObjAthletePtr.m_cObjPersonal_InfoPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 22)];
                if(nil != sqlite3_column_text(compiledStatement, 23))
					lObjAthletePtr.m_cObjSchoolCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 23)];
                if(nil != sqlite3_column_text(compiledStatement, 24))
					lObjAthletePtr.m_cObjClubCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 24)];
                if(nil != sqlite3_column_text(compiledStatement, 25))
					lObjAthletePtr.m_cObjBirthDatePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 25)];
                if(nil != sqlite3_column_text(compiledStatement, 26))
					lObjAthletePtr.m_cObjHeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 26)];
                if(nil != sqlite3_column_text(compiledStatement, 27))
					lObjAthletePtr.m_cObjWeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 27)];
                if(nil != sqlite3_column_text(compiledStatement, 28))
					lObjAthletePtr.m_cObjWingSpanPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 28)];
                if(nil != sqlite3_column_text(compiledStatement, 29))
					lObjAthletePtr.m_cObjReachPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 29)];
                if(nil != sqlite3_column_text(compiledStatement, 30))
					lObjAthletePtr.m_cObjShoeSizePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 30)];
                if(nil != sqlite3_column_text(compiledStatement, 31))
					lObjAthletePtr.m_cObjU_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 31)];
                if(nil != sqlite3_column_text(compiledStatement, 32))
					lObjAthletePtr.m_cObjActivePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 32)];
                
                lObjAthletePtr.m_cIsAddedinOfflineMode = sqlite3_column_int(compiledStatement,33);
                lObjAthletePtr.m_cIsPhotoAddedInOfflineMode = sqlite3_column_int(compiledStatement,34);
                
                if(nil != sqlite3_column_text(compiledStatement, 35))
					lObjAthletePtr.m_cObjGenderPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 35)];

                
                [lObjAthletesArrayPtr addObject:lObjAthletePtr];
                
                
                SAFE_RELEASE(lObjAthletePtr)
            }
			success = YES;
		}
		else
			DSLog(@"Error: failed to prepare statement for table Athlete with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
    
	if (success)
	{
		return [lObjAthletesArrayPtr autorelease];
	}
	else
	{
        SAFE_RELEASE(lObjAthletesArrayPtr)
        return nil;
	}
}

-(NSMutableArray *)getAthletePhotoAddedInOfflineMode
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	Athlete		    *lObjAthletePtr = nil;
	NSMutableArray	*lObjAthletesArrayPtr = nil;
    lObjAthletesArrayPtr = [[NSMutableArray alloc] init];
    
	
	sqlStatement = @"Select * from Athlete where IsPhotoAddedInOfflineMode = 1";
	
	if(nil != m_cDatabase)
	{
		if(sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				lObjAthletePtr = [[Athlete alloc] init];
				
                if(nil != sqlite3_column_text(compiledStatement, 0))
                    lObjAthletePtr.m_cAthleteId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				if(nil != sqlite3_column_text(compiledStatement, 1))
					lObjAthletePtr.m_cObjFirstNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if(nil != sqlite3_column_text(compiledStatement, 2))
					lObjAthletePtr.m_cObjLastNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                if(nil != sqlite3_column_text(compiledStatement, 3))
					lObjAthletePtr.m_cObjEmailIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                if(nil != sqlite3_column_text(compiledStatement, 4))
					lObjAthletePtr.m_cObjPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                if(nil != sqlite3_column_text(compiledStatement, 5))
					lObjAthletePtr.m_cObjAddressPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                if(nil != sqlite3_column_text(compiledStatement, 6))
					lObjAthletePtr.m_cPhotoNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				lObjAthletePtr.isFavouriteAthlete = sqlite3_column_int(compiledStatement, 7);
                if(nil != sqlite3_column_text(compiledStatement, 8))
					lObjAthletePtr.m_cObjSportsPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                if(nil != sqlite3_column_text(compiledStatement, 9))
					lObjAthletePtr.m_cObjSchoolNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                if(nil != sqlite3_column_text(compiledStatement, 10))
					lObjAthletePtr.m_cObjTeamNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                if(nil != sqlite3_column_text(compiledStatement, 11))
					lObjAthletePtr.m_cObjPositionPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                if(nil != sqlite3_column_text(compiledStatement, 12))
					lObjAthletePtr.m_cObjSchoolYearPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                if(nil != sqlite3_column_text(compiledStatement, 13))
					lObjAthletePtr.m_cObjCityNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                if(nil != sqlite3_column_text(compiledStatement, 14))
					lObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                if(nil != sqlite3_column_text(compiledStatement, 15))
					lObjAthletePtr.m_cObjZipCodePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                if(nil != sqlite3_column_text(compiledStatement, 16))
					lObjAthletePtr.m_cObjNickNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                if(nil != sqlite3_column_text(compiledStatement, 17))
					lObjAthletePtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                if(nil != sqlite3_column_text(compiledStatement, 18))
					lObjAthletePtr.m_cObjCellPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                if(nil != sqlite3_column_text(compiledStatement, 19))
					lObjAthletePtr.m_cObjTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];
                if(nil != sqlite3_column_text(compiledStatement, 20))
					lObjAthletePtr.m_cObjFB_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 20)];
                if(nil != sqlite3_column_text(compiledStatement, 21))
					lObjAthletePtr.m_cObjTwit_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 21)];
                if(nil != sqlite3_column_text(compiledStatement, 22))
					lObjAthletePtr.m_cObjPersonal_InfoPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 22)];
                if(nil != sqlite3_column_text(compiledStatement, 23))
					lObjAthletePtr.m_cObjSchoolCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 23)];
                if(nil != sqlite3_column_text(compiledStatement, 24))
					lObjAthletePtr.m_cObjClubCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 24)];
                if(nil != sqlite3_column_text(compiledStatement, 25))
					lObjAthletePtr.m_cObjBirthDatePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 25)];
                if(nil != sqlite3_column_text(compiledStatement, 26))
					lObjAthletePtr.m_cObjHeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 26)];
                if(nil != sqlite3_column_text(compiledStatement, 27))
					lObjAthletePtr.m_cObjWeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 27)];
                if(nil != sqlite3_column_text(compiledStatement, 28))
					lObjAthletePtr.m_cObjWingSpanPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 28)];
                if(nil != sqlite3_column_text(compiledStatement, 29))
					lObjAthletePtr.m_cObjReachPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 29)];
                if(nil != sqlite3_column_text(compiledStatement, 30))
					lObjAthletePtr.m_cObjShoeSizePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 30)];
                if(nil != sqlite3_column_text(compiledStatement, 31))
					lObjAthletePtr.m_cObjU_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 31)];
                if(nil != sqlite3_column_text(compiledStatement, 32))
					lObjAthletePtr.m_cObjActivePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 32)];
                
                lObjAthletePtr.m_cIsAddedinOfflineMode = sqlite3_column_int(compiledStatement,33);
                lObjAthletePtr.m_cIsPhotoAddedInOfflineMode = sqlite3_column_int(compiledStatement,34);
                
                if(nil != sqlite3_column_text(compiledStatement, 35))
					lObjAthletePtr.m_cObjGenderPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 35)];
                
                [lObjAthletesArrayPtr addObject:lObjAthletePtr];
                
                
                SAFE_RELEASE(lObjAthletePtr)
            }
			success = YES;
		}
		else
			DSLog(@"Error: failed to prepare statement for table Athlete with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
    
	if (success)
	{
		return [lObjAthletesArrayPtr autorelease];
	}
	else
	{
        SAFE_RELEASE(lObjAthletesArrayPtr)
        return nil;
	}
}

-(BOOL)insertAthelete:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
	sqlStatement = [NSString stringWithFormat:@"Insert into Athlete (ID, FirstName, LastName,IsFavouriteAthlete) Values (?, ?, ?,%d)",pObjAthletePtr.isFavouriteAthlete];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
            sqlite3_bind_text(compiledStatement, 1, [pObjAthletePtr.m_cAthleteId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                       
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Athlete Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Athlete table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
-(BOOL)insertAtheletePhoto:(NSString *)pAthleteId AthPhotoname:(NSString *)pObjAthletePhotoName
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
 
	//sqlStatement = [NSString stringWithFormat:@"Update Athlete set PhotoName=? where ID=\"%@\"",pAthleteId];//sougat block this
      //NSLog(@"%@",pAthleteId);
    NSLog(@"%@",pObjAthletePhotoName);
    
    sqlStatement = [NSString stringWithFormat:@"Update Athlete set PhotoName = ? where ID=?"];

	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
			//sougata added this
            sqlite3_bind_text(compiledStatement, 1, [pAthleteId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 7, [pObjAthletePhotoName UTF8String], -1, SQLITE_TRANSIENT);
           //end

//            sqlite3_bind_text(compiledStatement, 1, [pObjAthletePhotoName UTF8String], -1, SQLITE_TRANSIENT);
           
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to update Athlete Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Athlete table update statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
-(BOOL)insertAtheleteDetail:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
        
    sqlStatement = [NSString stringWithFormat:@"Update Athlete set EmailAddress = ?, PhoneNumber = ?, Address = ?, IsFavouriteAthlete = %d, SportName = ?, SchoolName = ?, TeamName = ?, Position = ?, SchoolYear = ?, CityName = ?, StateName = ?,ZipCode = ?, NickName = ?, EmailPassword = ?, CellNumber = ?, Type = ?, FB_ID = ? , TWIT_ID = ? , PersonalInfo = ? , SchoolCoachName = ? , ClubCoachName = ? , BirthDate = ? , Height = ? , Weight = ? , WingSpan = ? , Reach = ? , ShoeSize = ? , U_ID = ? , Active = ?, GENDER = ?  where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cAthleteId];
	
    if((NSString *)nil != sqlStatement)
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String],-1, &compiledStatement, NULL))
        {
            sqlite3_bind_text(compiledStatement, 1, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 7, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 8, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 9, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 10, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 11, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 12, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 13, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 14, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 15, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 16, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 17, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 18, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 19, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 20, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 21, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 22, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 23, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 24, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 25, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 26, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 27, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 28, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 29, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 30, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
             sqlite3_bind_text(compiledStatement, 31, [pObjAthletePtr.m_cObjGenderPtr UTF8String], -1, SQLITE_TRANSIENT);
 
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Athlete Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Athlete table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}

-(BOOL)insertNewAthlete : (Athlete *)pObjAthletePtr
{
    
    if (NO == [gObjAppDelegatePtr isNetworkAvailable])
    {
        pObjAthletePtr.m_cIsAddedinOfflineMode = 1;

    }
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
	sqlStatement = [NSString stringWithFormat:@"Insert into Athlete (ID, FirstName, LastName , EmailAddress , PhoneNumber , Address , PhotoName , IsFavouriteAthlete,SportName , SchoolName , TeamName , Position , SchoolYear , CityName , StateName , ZipCode , NickName , EmailPassword , CellNumber , Type , FB_ID , TWIT_ID , PersonalInfo , SchoolCoachName , ClubCoachName , BirthDate , Height , Weight , WingSpan , Reach , ShoeSize , U_ID , Active, IsAddedInOfflineMode, IsPhotoAddedInOfflineMode, GENDER ) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?, ?, ?,? )"];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL)) 
		{
		 sqlite3_bind_text(compiledStatement, 1, [pObjAthletePtr.m_cAthleteId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 7, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 8, pObjAthletePtr.isFavouriteAthlete);
            sqlite3_bind_text(compiledStatement, 9, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 10, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 11, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 12, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 13, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 14, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 15, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 16, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 17, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 18, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 19, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 20, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 21, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 22, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 23, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 24, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 25, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 26, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 27, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 28, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 29, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 30, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 31, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 32, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 33, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 34, pObjAthletePtr.m_cIsAddedinOfflineMode);
            sqlite3_bind_int(compiledStatement, 35, pObjAthletePtr.m_cIsPhotoAddedInOfflineMode);
            sqlite3_bind_text(compiledStatement, 36, [pObjAthletePtr.m_cObjGenderPtr UTF8String], -1, SQLITE_TRANSIENT);
            

            NSLog(@"%d",pObjAthletePtr.m_cIsAddedinOfflineMode);
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Athlete Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Athlete table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;

}

-(BOOL)updateNewAthlete : (Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?, EmailAddress = ?, PhoneNumber = ?, Address = ?, PhotoName = ?, IsFavouriteAthlete = %d, SportName = ?, SchoolName = ?, TeamName = ?, Position = ?, SchoolYear = ?, CityName = ?, StateName = ?,ZipCode = ?, NickName = ?, EmailPassword = ?, CellNumber = ?, Type = ?, FB_ID = ? , TWIT_ID = ? , PersonalInfo = ? , SchoolCoachName = ? , ClubCoachName = ? , BirthDate = ? , Height = ? , Weight = ? , WingSpan = ? , Reach = ? , ShoeSize = ? , U_ID = ? , Active = ? ,IsAddedInOfflineMode = ?, IsPhotoAddedInOfflineMode = %d,GENDER = ? \
								   where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cIsPhotoAddedInOfflineMode,  pObjAthletePtr.m_cAthleteId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 3, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 4, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 5, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 6, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 7, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 8, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 9, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 10, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 11, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 12, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 13, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 14, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 15, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 16, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 17, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 18, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 19, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 20, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 21, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 22, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 23, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 24, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 25, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 26, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 27, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 28, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 29, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 30, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 31, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 32, pObjAthletePtr.m_cIsAddedinOfflineMode);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 33, [pObjAthletePtr.m_cObjGenderPtr UTF8String], -1, SQLITE_TRANSIENT);
                    
                    
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
-(NSInteger)searchForAthleteDetail:(NSString *)pAthleteID
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (NSString *)nil != pAthleteID)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   pAthleteID];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
    }
   pthread_mutex_unlock(&m_cMutex);
    return lRowCount;
}
-(BOOL)updateAthleteFNLNID:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
#if 0
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?, EmailAddress = ?, PhoneNumber = ?, Address = ?, PhotoName = ?, IsFavouriteAthlete = %d, SportName = ?, SchoolName = ?, TeamName = ?, Position = ?, SchoolYear = ?, CityName = ?, StateName = ?,ZipCode = ?, NickName = ?, EmailPassword = ?, CellNumber = ?, Type = ?, FB_ID = ? , TWIT_ID = ? , PersonalInfo = ? , SchoolCoachName = ? , ClubCoachName = ? , BirthDate = ? , Height = ? , Weight = ? , WingSpan = ? , Reach = ? , ShoeSize = ? , U_ID = ? , Active = ? ,IsAddedInOfflineMode = ? \
								   where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cAthleteId];
#else
            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?,IsFavouriteAthlete = %d where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cAthleteId];
#endif
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
#if 0
                    sqlite3_bind_text(lObjCompiledStatementPtr, 3, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 4, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 5, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 6, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 7, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 8, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 9, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 10, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 11, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 12, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 13, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 14, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 15, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 16, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 17, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 18, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 19, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 20, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 21, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 22, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 23, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 24, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 25, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 26, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 27, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 28, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 29, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 30, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 31, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 32, pObjAthletePtr.m_cIsAddedinOfflineMode);
                    
#endif
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}

-(BOOL)updateAthlete:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
#if 0
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?, EmailAddress = ?, PhoneNumber = ?, Address = ?, PhotoName = ?, IsFavouriteAthlete = %d, SportName = ?, SchoolName = ?, TeamName = ?, Position = ?, SchoolYear = ?, CityName = ?, StateName = ?,ZipCode = ?, NickName = ?, EmailPassword = ?, CellNumber = ?, Type = ?, FB_ID = ? , TWIT_ID = ? , PersonalInfo = ? , SchoolCoachName = ? , ClubCoachName = ? , BirthDate = ? , Height = ? , Weight = ? , WingSpan = ? , Reach = ? , ShoeSize = ? , U_ID = ? , Active = ? ,IsAddedInOfflineMode = ? \
								   where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cAthleteId];
#else
            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?,IsFavouriteAthlete = %d where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cAthleteId];
#endif
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
#if 0
                    sqlite3_bind_text(lObjCompiledStatementPtr, 3, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 4, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 5, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 6, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 7, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 8, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 9, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 10, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 11, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 12, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 13, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 14, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 15, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 16, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 17, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 18, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 19, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 20, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 21, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 22, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 23, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 24, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 25, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 26, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 27, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 28, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 29, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 30, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 31, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 32, pObjAthletePtr.m_cIsAddedinOfflineMode);
                    
#endif
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}

//Narasimhaiah added to update Athlete Id 13-2-13
-(BOOL)updateAthleteID :(Athlete *)pObjAthletePtr AthId:(NSString *)ptempAthId
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   ptempAthId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   ID= ?, PhotoName =?, IsAddedInOfflineMode = ?, IsPhotoAddedInOfflineMode =%d where ID = \"%@\"",1,ptempAthId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                  sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cAthleteId UTF8String], -1, SQLITE_TRANSIENT);
                  sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 3, 0);
                                      
                  if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
                        
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}

-(BOOL)updateAthleteFlagsForImage:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
            if (NO ==  [gObjAppDelegatePtr isNetworkAvailable])
            {
                pObjAthletePtr.m_cIsAddedinOfflineMode = 1;
            }
            
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   IsAddedInOfflineMode = %d, IsPhotoAddedInOfflineMode =%d where ID = \"%@\"",pObjAthletePtr.m_cIsAddedinOfflineMode,pObjAthletePtr.m_cIsPhotoAddedInOfflineMode,pObjAthletePtr.m_cAthleteId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                    
                    if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
                        
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;

}
//Narasimhaiah added to update image name 25-2-13 - start
-(BOOL)updateImageName :(Athlete *)pObjAthletePtr
                  Athid:(NSString *)ptempAthId
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   ptempAthId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   ID= ?, IsAddedInOfflineMode = ? where ID = \"%@\"",ptempAthId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                    sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cAthleteId UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr, 2, 0);
                    if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
                        
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
//Narasimhaiah added to update image name 25-2-13 - end
//Narasimhaiah added to update log table with athlete ids
-(BOOL)updateLogTableAthleteID :(Athlete *)pObjAthletePtr
                          AthId:(NSString *)ptempAthId
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\"",
							   ptempAthId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
    
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Log set AthleteID = ? where AthleteID = \"%@\"",ptempAthId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
                if(sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String], -1, &lObjCompiledStatementPtr, NULL) == SQLITE_OK)
                    {
                        
//                        // Loop through the results and add them to the feeds array
//                        while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
//                        {

                            sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cAthleteId UTF8String], -1, SQLITE_TRANSIENT);
                            if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
                            {
                                //Update Successful.
                                lRetVal = YES;
                            }
//                        }
                    }
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}


-(BOOL)updateAthleteDetail:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    NSString            *lStatePtr = (NSString *)nil;
    
    if(pObjAthletePtr.m_cObjSportsPtr != (NSString *)nil)
    {
    NSInteger sportVal = [pObjAthletePtr.m_cObjSportsPtr integerValue];
        switch (sportVal) {
            case 1:
                pObjAthletePtr.m_cObjSportsPtr = @"General";
                break;
            case 2:
                pObjAthletePtr.m_cObjSportsPtr = @"Baseball";
                break;
            case 3:
                pObjAthletePtr.m_cObjSportsPtr = @"Basketball";
                break;
            case 4:
                pObjAthletePtr.m_cObjSportsPtr = @"Football";
                break;
            case 5:
                pObjAthletePtr.m_cObjSportsPtr = @"Lacrosse";
                break;
            case 6:
                pObjAthletePtr.m_cObjSportsPtr = @"Volleyball";  
                break;
            default:
                break;
        }
    }
    
    if(pObjAthletePtr.m_cObjStateNamePtr != (NSString *)nil)
       {
           if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"AL"])
           {
               lStatePtr = @"Alabama";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"AK"])
           {
               lStatePtr = @"Alaska";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"AZ"])
           {
               lStatePtr = @"Arizona";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"AR"])
           {
               lStatePtr = @"Arkansas";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"CA"])
           {
               lStatePtr = @"California";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"CO"])
           {
               lStatePtr = @"Colorado";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"CT"])
           {
               lStatePtr = @"Connecticut";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"DE"])
           {
               lStatePtr = @"Delaware";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"FL"])
           {
               lStatePtr = @"Florida";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"GA"])
           {
               lStatePtr = @"Georgia";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"HI"])
           {
               lStatePtr = @"Hawaii";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"ID"])
           {
               lStatePtr = @"Idaho";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"IL"])
           {
               lStatePtr = @"Illinois";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"IN"])
           {
               lStatePtr = @"Indiana";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"IN"])
           {
               lStatePtr = @"Indiana";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"IA"])
           {
               lStatePtr = @"Iowa";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"KS"])
           {
               lStatePtr = @"Kansas";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"KY"])
           {
               lStatePtr = @"Kentucky";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"LA"])
           {
               lStatePtr = @"Louisiana";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"ME"])
           {
               lStatePtr = @"Maine";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MD"])
           {
               lStatePtr = @"Maryland";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MA"])
           {
               lStatePtr = @"Massachusetts";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MI"])
           {
               lStatePtr = @"Michigan";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MN"])
           {
               lStatePtr = @"Minnesota";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MS"])
           {
               lStatePtr = @"Mississippi";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MO"])
           {
               lStatePtr = @"Missouri";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"MT"])
           {
               lStatePtr = @"Montana";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NE"])
           {
               lStatePtr = @"Nebraska";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NV"])
           {
               lStatePtr = @"Nevada";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NH"])
           {
               lStatePtr = @"New Hampshire";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NJ"])
           {
               lStatePtr = @"New Jersey";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NM"])
           {
               lStatePtr = @"New Mexico";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NY"])
           {
               lStatePtr = @"New York";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"NC"])
           {
               lStatePtr = @"North Carolina";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"ND"])
           {
               lStatePtr = @"North Dakota";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"OH"])
           {
               lStatePtr = @"Ohio";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"OK"])
           {
               lStatePtr = @"Oklahoma";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"OR"])
           {
               lStatePtr = @"Oregon";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"PA"])
           {
               lStatePtr = @"Pennsylvania";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"RI"])
           {
               lStatePtr = @"Rhode Island";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"SC"])
           {
               lStatePtr = @"South Carolina";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"SC"])
           {
               lStatePtr = @"South Carolina";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"SD"])
           {
               lStatePtr = @"South Dakota";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"TN"])
           {
               lStatePtr = @"Tennessee";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"TX"])
           {
               lStatePtr = @"Texas";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"UT"])
           {
               lStatePtr = @"Utah";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"VT"])
           {
               lStatePtr = @"Vermont";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"VA"])
           {
               lStatePtr = @"Virginia";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"WA"])
           {
               lStatePtr = @"Washington";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"WG"])
           {
               lStatePtr = @"West Virginia";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"WI"])
           {
               lStatePtr = @"Wisconsin";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
           else if([pObjAthletePtr.m_cObjStateNamePtr isEqualToString:@"WY"])
           {
               lStatePtr = @"Wyoming";
               pObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithFormat:@"%@(%@)",lStatePtr,pObjAthletePtr.m_cObjStateNamePtr];
           }
       }
       
    if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],
											   -1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set\
								   FirstName= ?, LastName = ?, EmailAddress = ?, PhoneNumber = ?, Address = ?, PhotoName = ?, IsFavouriteAthlete = %d, SportName = ?, SchoolName = ?, TeamName = ?, Position = ?, SchoolYear = ?, CityName = ?, StateName = ?,ZipCode = ?, NickName = ?, EmailPassword = ?, CellNumber = ?, Type = ?, FB_ID = ? , TWIT_ID = ? , PersonalInfo = ? , SchoolCoachName = ? , ClubCoachName = ? , BirthDate = ? , Height = ? , Weight = ? , WingSpan = ? , Reach = ? , ShoeSize = ? , U_ID = ? , Active = ?,  IsPhotoAddedInOfflineMode = %d,GENDER = ?\
								   where ID = \"%@\"",/*pObjAthletePtr.m_cAthleteAge,*/pObjAthletePtr.isFavouriteAthlete,pObjAthletePtr.m_cIsPhotoAddedInOfflineMode, pObjAthletePtr.m_cAthleteId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					sqlite3_bind_text(lObjCompiledStatementPtr, 1, [pObjAthletePtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(lObjCompiledStatementPtr, 2, [pObjAthletePtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 3, [pObjAthletePtr.m_cObjEmailIdPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 4, [pObjAthletePtr.m_cObjPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 5, [pObjAthletePtr.m_cObjAddressPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 6, [pObjAthletePtr.m_cPhotoNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 7, [pObjAthletePtr.m_cObjSportsPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 8, [pObjAthletePtr.m_cObjSchoolNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 9, [pObjAthletePtr.m_cObjTeamNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 10, [pObjAthletePtr.m_cObjPositionPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 11, [pObjAthletePtr.m_cObjSchoolYearPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 12, [pObjAthletePtr.m_cObjCityNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 13, [pObjAthletePtr.m_cObjStateNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 14, [pObjAthletePtr.m_cObjZipCodePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 15, [pObjAthletePtr.m_cObjNickNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 16, [pObjAthletePtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 17, [pObjAthletePtr.m_cObjCellPhoneNumberPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 18, [pObjAthletePtr.m_cObjTypePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 19, [pObjAthletePtr.m_cObjFB_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 20, [pObjAthletePtr.m_cObjTwit_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 21, [pObjAthletePtr.m_cObjPersonal_InfoPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 22, [pObjAthletePtr.m_cObjSchoolCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 23, [pObjAthletePtr.m_cObjClubCoachNamePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 24, [pObjAthletePtr.m_cObjBirthDatePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 25, [pObjAthletePtr.m_cObjHeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 26, [pObjAthletePtr.m_cObjWeightPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 27, [pObjAthletePtr.m_cObjWingSpanPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 28, [pObjAthletePtr.m_cObjReachPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 29, [pObjAthletePtr.m_cObjShoeSizePtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 30, [pObjAthletePtr.m_cObjU_IDPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 31, [pObjAthletePtr.m_cObjActivePtr UTF8String], -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_int(lObjCompiledStatementPtr, 32, pObjAthletePtr.m_cIsPhotoAddedInOfflineMode);
                    sqlite3_bind_text(lObjCompiledStatementPtr, 32, [pObjAthletePtr.m_cObjGenderPtr UTF8String], -1, SQLITE_TRANSIENT);

                    
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}

-(BOOL)deleteAthlete
{
    BOOL	lRetVal = NO;
    
	lRetVal = [self deleteRecords:@"Delete from Athlete"];
    return lRetVal;
}

-(NSMutableArray *)getAllFavouriteAthletes
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	Athlete		    *lObjAthletePtr = nil;
	NSMutableArray	*lObjFavouriteAthletesArrayPtr = nil;
	
	
	sqlStatement = @"Select * from Athlete where IsFavouriteAthlete = 1";
	
	if(nil != m_cDatabase)
	{
		if(sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) 
		{
			lObjFavouriteAthletesArrayPtr = [[NSMutableArray alloc] init];
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
			{
				lObjAthletePtr = [[Athlete alloc] init];
				
                if(nil != sqlite3_column_text(compiledStatement, 0))
                    lObjAthletePtr.m_cAthleteId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				if(nil != sqlite3_column_text(compiledStatement, 1))
					lObjAthletePtr.m_cObjFirstNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if(nil != sqlite3_column_text(compiledStatement, 2))
					lObjAthletePtr.m_cObjLastNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                if(nil != sqlite3_column_text(compiledStatement, 3))
					lObjAthletePtr.m_cObjEmailIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                if(nil != sqlite3_column_text(compiledStatement, 4))
					lObjAthletePtr.m_cObjPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                if(nil != sqlite3_column_text(compiledStatement, 5))
					lObjAthletePtr.m_cObjAddressPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                if(nil != sqlite3_column_text(compiledStatement, 6))
					lObjAthletePtr.m_cPhotoNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				lObjAthletePtr.isFavouriteAthlete = sqlite3_column_int(compiledStatement, 7);
                if(nil != sqlite3_column_text(compiledStatement, 8))
					lObjAthletePtr.m_cObjSportsPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                if(nil != sqlite3_column_text(compiledStatement, 9))
					lObjAthletePtr.m_cObjSchoolNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                if(nil != sqlite3_column_text(compiledStatement, 10))
					lObjAthletePtr.m_cObjTeamNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                if(nil != sqlite3_column_text(compiledStatement, 11))
					lObjAthletePtr.m_cObjPositionPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                if(nil != sqlite3_column_text(compiledStatement, 12))
					lObjAthletePtr.m_cObjSchoolYearPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                if(nil != sqlite3_column_text(compiledStatement, 13))
					lObjAthletePtr.m_cObjCityNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                if(nil != sqlite3_column_text(compiledStatement, 14))
					lObjAthletePtr.m_cObjStateNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                if(nil != sqlite3_column_text(compiledStatement, 15))
					lObjAthletePtr.m_cObjZipCodePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                if(nil != sqlite3_column_text(compiledStatement, 16))
					lObjAthletePtr.m_cObjNickNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                if(nil != sqlite3_column_text(compiledStatement, 17))
					lObjAthletePtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 17)];
                if(nil != sqlite3_column_text(compiledStatement, 18))
					lObjAthletePtr.m_cObjCellPhoneNumberPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 18)];
                if(nil != sqlite3_column_text(compiledStatement, 19))
					lObjAthletePtr.m_cObjTypePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 19)];
                if(nil != sqlite3_column_text(compiledStatement, 20))
					lObjAthletePtr.m_cObjFB_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 20)];
                if(nil != sqlite3_column_text(compiledStatement, 21))
					lObjAthletePtr.m_cObjTwit_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 21)];
                if(nil != sqlite3_column_text(compiledStatement, 22))
					lObjAthletePtr.m_cObjPersonal_InfoPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 22)];
                if(nil != sqlite3_column_text(compiledStatement, 23))
					lObjAthletePtr.m_cObjSchoolCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 23)];
                if(nil != sqlite3_column_text(compiledStatement, 24))
					lObjAthletePtr.m_cObjClubCoachNamePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 24)];
                if(nil != sqlite3_column_text(compiledStatement, 25))
					lObjAthletePtr.m_cObjBirthDatePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 25)];
                if(nil != sqlite3_column_text(compiledStatement, 26))
					lObjAthletePtr.m_cObjHeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 26)];
                if(nil != sqlite3_column_text(compiledStatement, 27))
					lObjAthletePtr.m_cObjWeightPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 27)];
                if(nil != sqlite3_column_text(compiledStatement, 28))
					lObjAthletePtr.m_cObjWingSpanPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 28)];
                if(nil != sqlite3_column_text(compiledStatement, 29))
					lObjAthletePtr.m_cObjReachPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 29)];
                if(nil != sqlite3_column_text(compiledStatement, 30))
					lObjAthletePtr.m_cObjShoeSizePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 30)];
                if(nil != sqlite3_column_text(compiledStatement, 31))
					lObjAthletePtr.m_cObjU_IDPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 31)];
                if(nil != sqlite3_column_text(compiledStatement, 32))
					lObjAthletePtr.m_cObjActivePtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 32)];
                
                lObjAthletePtr.m_cIsAddedinOfflineMode = sqlite3_column_int(compiledStatement,33);
                lObjAthletePtr.m_cIsPhotoAddedInOfflineMode = sqlite3_column_int(compiledStatement, 34);
                
                if(nil != sqlite3_column_text(compiledStatement, 35))
					lObjAthletePtr.m_cObjGenderPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 35)];

                
				[lObjFavouriteAthletesArrayPtr addObject:lObjAthletePtr];
                        
                SAFE_RELEASE(lObjAthletePtr)
            }
			success = YES;
		}
		else
			DSLog(@"Error: failed to prepare statement for table Athlete with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
    
	if (success)
	{
		return [lObjFavouriteAthletesArrayPtr autorelease];
	}
	else 
	{
      
        SAFE_RELEASE(lObjFavouriteAthletesArrayPtr)
        return nil;
	}

}

-(BOOL)insertToFavourites:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
        else
        {
        lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set IsFavouriteAthlete = %d where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete, pObjAthletePtr.m_cAthleteId];
        
        if((NSString *)nil != lObjSqlStatementPtr)
        {
            if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
            {
                if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
                {
                    //Update Successful.
                    lRetVal = YES;
                }
            }
            
            //Release the compiled statement from memory.
            sqlite3_finalize(lObjCompiledStatementPtr);
            
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    }
}
        pthread_mutex_unlock(&m_cMutex);
        return lRetVal;
}
-(BOOL)removeFromFavourites:(Athlete *)pObjAthletePtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (Athlete *)nil != pObjAthletePtr)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Athlete where ID = \"%@\"",
							   pObjAthletePtr.m_cAthleteId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			lRetVal = NO;
		}
        else
        {
            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Athlete set IsFavouriteAthlete = %d where ID = \"%@\"",pObjAthletePtr.isFavouriteAthlete, pObjAthletePtr.m_cAthleteId];
            
            if((NSString *)nil != lObjSqlStatementPtr)
            {
                if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
                {
                   if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
                    {
                        //Update Successful.
                        lRetVal = YES;
                    }
                }
                
                //Release the compiled statement from memory.
                sqlite3_finalize(lObjCompiledStatementPtr);
                
                SAFE_RELEASE(lObjSqlStatementPtr)
            }
        }
    }
    pthread_mutex_unlock(&m_cMutex);
    return lRetVal;
}
//Narasimhaiah added to update the test results 12-2-13 - start
#if 0
-(BOOL)updateTestLog:(AthleteLog *)pObjAthleteLogPtr :(NSString *)pAthleteId :(NSString *)pTestID
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (AthleteLog *)nil != pObjAthleteLogPtr && pAthleteId != (NSString *)nil)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\" AND TestID = \"%@\"",pAthleteId,pTestID];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
		  if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			pthread_mutex_unlock(&m_cMutex);
            
			//Record not found, insert the record.
			lRetVal = [self insertTestLog:pObjAthleteLogPtr :pAthleteId :pTestID];
            
			pthread_mutex_lock(&m_cMutex);
            
		}
		else
		{
			//Record found, update the record.
           
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Log set \
								   TestResult = \"%@\"\
								   where AthleteID = \"%@\" AND TestID = \"%@\"",pObjAthleteLogPtr.m_cPushupScore,pAthleteId,pTestID];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
-(BOOL)insertTestLog:(AthleteLog *)pObjAthleteLogPtr :(NSString *)pAthleteId :(NSString *)pTestID
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
	sqlStatement = [NSString stringWithFormat:@"Insert into Log (AthleteId, PushUpScore) Values (?, %d)",pObjAthleteLogPtr.m_cPushupScore];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
            sqlite3_bind_text(compiledStatement, 1, [pAthleteId UTF8String], -1, SQLITE_TRANSIENT);
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Log Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Log table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
#endif
//Narasimhaiah added to update the test results 12-2-13 - end




-(BOOL)updateLogTableOfflineModeValue:(NSString *)pObjAthleteIdPtr :(NSInteger )pTestId
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && pObjAthleteIdPtr != (NSString *)nil)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\" And TestID = %d",pObjAthleteIdPtr,pTestId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
            //Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Log set IsAddedInOfflineMode = ? where AthleteID = \"%@\" AND TestID = %d",pObjAthleteIdPtr,pTestId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                    
                    sqlite3_bind_int(lObjCompiledStatementPtr,1, 0);
                    
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
    }
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
//Narasimhaiah added the methods for updating the Combine Id in the DB 1-3-13 - start
-(BOOL)updateTestResult :(AthleteLog *)pObjAthleteLogPtr
                    Test:(Tests *)pObjTestPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase && (AthleteLog *)nil != pObjAthleteLogPtr && pObjAthleteLogPtr.m_cObjAthleteIdPtr != (NSString *)nil)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\" And TestID = %d And CombineID= %d",pObjAthleteLogPtr.m_cObjAthleteIdPtr,pObjTestPtr.m_cObjTestId,pObjAthleteLogPtr.m_cObjCombineId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
		if(0 >= lRowCount)
		{
			pthread_mutex_unlock(&m_cMutex);
            //Record not found, insert the record.
			lRetVal = [self insertTestResult :pObjAthleteLogPtr Tests:pObjTestPtr];
            pthread_mutex_lock(&m_cMutex);
            
		}
		else
		{
			//Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Log set TestResult = ?,IsAddedInOfflineMode = ? where AthleteID = \"%@\" AND TestID = %d AND CombineID = %d",pObjAthleteLogPtr.m_cObjAthleteIdPtr,pObjTestPtr.m_cObjTestId,pObjTestPtr.m_cObjCombineId];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                    
                    sqlite3_bind_text(lObjCompiledStatementPtr,1, [pObjAthleteLogPtr.m_cObjTestResultPtr UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(lObjCompiledStatementPtr,2, pObjAthleteLogPtr.m_cIsAddedinOfflineMode);
                    
					if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                
				//Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
		}
	}
    pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
-(BOOL) insertTestResult :(AthleteLog *)pObjAthleteLogPtr
                    Tests:(Tests *)pObjTestPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
	sqlStatement = [NSString stringWithFormat:@"Insert into Log (AthleteId, TestID, TestResult, IsAddedInOfflineMode,CombineID) Values (?, ? ,? ,?, ?)"];
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL))
		{
            sqlite3_bind_text(compiledStatement, 1, [pObjAthleteLogPtr.m_cObjAthleteIdPtr UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 2, [pObjTestPtr.m_cObjTestIdPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, pObjTestPtr.m_cObjTestId);
            sqlite3_bind_text(compiledStatement, 3, [pObjAthleteLogPtr.m_cObjTestResultPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 4, pObjAthleteLogPtr.m_cIsAddedinOfflineMode);
//            sqlite3_bind_text(compiledStatement, 5, [pObjTestPtr.m_cObjCombineIdPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 5, pObjTestPtr.m_cObjCombineId);
            
            
            if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Log Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Log table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
-(NSMutableArray *)getAthleteLogsAddedinOfflineMode
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    AthleteLog          *lObjAthleteLogPtr = nil;
    NSMutableArray      *lObjAthleteLogArrayPtr = (NSMutableArray *)nil;
    lObjAthleteLogArrayPtr = [[NSMutableArray alloc] init];

	if((sqlite3 *)nil != m_cDatabase)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where IsAddedInOfflineMode = 1"];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			
		}
        //Release the compiled statement from memory.
        sqlite3_finalize(lObjCompiledStatementPtr);
        
        SAFE_RELEASE(lObjSqlStatementPtr)
        
		if(lRowCount > 0)
		{

            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Log where IsAddedInOfflineMode = 1"];
            if(sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String], -1, &lObjCompiledStatementPtr, NULL) == SQLITE_OK)
            {

                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    lObjAthleteLogPtr = [[AthleteLog alloc]init];
                    
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 0))
                        lObjAthleteLogPtr.m_cObjAthleteIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 0)];                
                    //                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 1))
                    //                        lObjAthleteLogPtr.m_cObjTestIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 1)];
                    lObjAthleteLogPtr.m_cObjTestId = sqlite3_column_int(lObjCompiledStatementPtr,1);
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 2))
                        lObjAthleteLogPtr.m_cObjTestResultPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 2)];
                    lObjAthleteLogPtr.m_cIsAddedinOfflineMode = sqlite3_column_int(lObjCompiledStatementPtr,3);
                    //                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 4))
                    //                        lObjAthleteLogPtr.m_cObjCombineIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 4)];
                    lObjAthleteLogPtr.m_cObjCombineId = sqlite3_column_int(lObjCompiledStatementPtr,4);

                    [lObjAthleteLogArrayPtr addObject:lObjAthleteLogPtr];

                    SAFE_RELEASE(lObjAthleteLogPtr)
                  }
                lRetVal = YES;
            }
            else
            {
                lRetVal = NO;
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            }
                // Release the compiled statement from memory
                sqlite3_finalize(lObjCompiledStatementPtr);
                SAFE_RELEASE(lObjSqlStatementPtr)
            
        }
    }
    pthread_mutex_unlock(&m_cMutex);
    
    if (lRetVal)
    {
        return [lObjAthleteLogArrayPtr autorelease];
    }
    else
    {
        SAFE_RELEASE(lObjAthleteLogPtr)
        return nil;
    }
}
//Narasimhaiah added to get the athletes added in offline mode 8-3-13 - start
-(NSMutableArray *)getAthleteLogsAddedinOfflineModeforAthlete:(NSString *)pObjAthleteIdPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    AthleteLog          *lObjAthleteLogPtr = nil;
    NSMutableArray      *lObjAthleteLogArrayPtr = (NSMutableArray *)nil;
    lObjAthleteLogArrayPtr = [[NSMutableArray alloc] init];
    
	if((sqlite3 *)nil != m_cDatabase)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\" And IsAddedInOfflineMode = 1",pObjAthleteIdPtr];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			
		}
        //Release the compiled statement from memory.
        sqlite3_finalize(lObjCompiledStatementPtr);
        
        SAFE_RELEASE(lObjSqlStatementPtr)
        
		if(lRowCount > 0)
		{
            
            lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Log where AthleteID = \"%@\" And IsAddedInOfflineMode = 1",pObjAthleteIdPtr];
            if(sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String], -1, &lObjCompiledStatementPtr, NULL) == SQLITE_OK)
            {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    lObjAthleteLogPtr = [[AthleteLog alloc]init];
                    
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 0))
                        lObjAthleteLogPtr.m_cObjAthleteIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 0)];
                    //                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 1))
                    //                        lObjAthleteLogPtr.m_cObjTestIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 1)];
                    lObjAthleteLogPtr.m_cObjTestId = sqlite3_column_int(lObjCompiledStatementPtr,1);
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 2))
                        lObjAthleteLogPtr.m_cObjTestResultPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 2)];
                    lObjAthleteLogPtr.m_cIsAddedinOfflineMode = sqlite3_column_int(lObjCompiledStatementPtr,3);
                    //                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr, 4))
                    //                        lObjAthleteLogPtr.m_cObjCombineIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr, 4)];
                    lObjAthleteLogPtr.m_cObjCombineId = sqlite3_column_int(lObjCompiledStatementPtr,4);

                    [lObjAthleteLogArrayPtr addObject:lObjAthleteLogPtr];
                    
                    SAFE_RELEASE(lObjAthleteLogPtr)
                }
                lRetVal = YES;
            }
            else
            {
                lRetVal = NO;
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            }
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
            
        }
    }
    pthread_mutex_unlock(&m_cMutex);
    
    if (lRetVal)
    {
        return [lObjAthleteLogArrayPtr autorelease];
    }
    else
    {
        SAFE_RELEASE(lObjAthleteLogPtr)
        return nil;
    }
}
//Narasimhaiah added to get the athletes added in offline mode 8-3-13 - end
-(NSMutableArray *)getAthleteLogs :(NSString *)pAthleteId
                         CombineId:(NSInteger )pObjCombineId
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    NSMutableArray      *lObAthleteLogsArrayPtr = (NSMutableArray *)nil;
    lObAthleteLogsArrayPtr = [[NSMutableArray alloc] init];

    AthleteLog          *lObjAthleteLogPtr = nil;
    
	if((sqlite3 *)nil != m_cDatabase && pAthleteId != (NSString *)nil)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select count(*) from Log where AthleteID = \"%@\" And CombineId = %d",pAthleteId,pObjCombineId];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
		}
        SAFE_RELEASE(lObjSqlStatementPtr)

		if(lRowCount > 0)
		{
          lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Log where AthleteID = \"%@\" AND CombineId = %d",pAthleteId,pObjCombineId];
            
            if(sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String], -1, &lObjCompiledStatementPtr, NULL) == SQLITE_OK) 
            {
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW) 
                {
                    lObjAthleteLogPtr = (AthleteLog *)nil;
                    lObjAthleteLogPtr = [[AthleteLog alloc]init];

                    lObjAthleteLogPtr.m_cObjTestId = sqlite3_column_int(lObjCompiledStatementPtr,1);
                    if(nil != sqlite3_column_text(lObjCompiledStatementPtr,2))
                        lObjAthleteLogPtr.m_cObjTestResultPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,2)];
                    lObjAthleteLogPtr.m_cIsAddedinOfflineMode = sqlite3_column_int(lObjCompiledStatementPtr,3);

                    lObjAthleteLogPtr.m_cObjCombineId = sqlite3_column_int(lObjCompiledStatementPtr,4);
                    
                    [lObAthleteLogsArrayPtr addObject:lObjAthleteLogPtr];
                    
                    SAFE_RELEASE(lObjAthleteLogPtr)

                }
                lRetVal = YES;
            }
            else
                DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
        else
        {
            lRetVal = NO;
        }
    }
        pthread_mutex_unlock(&m_cMutex);
        
        if (lRetVal)
        {
            return [lObAthleteLogsArrayPtr autorelease];
        }
        else 
        {
            SAFE_RELEASE(lObAthleteLogsArrayPtr)
            return nil;
        }
}

-(BOOL)deleteAthleteLog:(NSString *)pAthleteId
{
    BOOL	lRetVal = NO;
    NSString *lObjSqlStatementPtr = (NSString *)nil;
    lObjSqlStatementPtr = [[NSString alloc]initWithFormat:@"Delete from Log where AthleteId = \"%@\"",pAthleteId];
	lRetVal = [self deleteRecords:lObjSqlStatementPtr];
    SAFE_RELEASE(lObjSqlStatementPtr)
	return lRetVal;
}
-(BOOL)deleteAthleteAddedInOfflinemode :(NSString *)pObjAthId
{
    BOOL	lRetVal = NO;
    NSString *lObjSqlStatementPtr = (NSString *)nil;
    lObjSqlStatementPtr = [[NSString alloc]initWithFormat:@"Delete from Athlete where ID = \"%@\"",pObjAthId];
	lRetVal = [self deleteRecords:lObjSqlStatementPtr];
    SAFE_RELEASE(lObjSqlStatementPtr)
	return lRetVal;
}
-(BOOL)deleteRecords:(NSString *)pObjSqlStatementPtr
{
    pthread_mutex_lock(&m_cMutex);
    sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
    
    
	if((sqlite3 *)nil != m_cDatabase && (NSString *)nil != pObjSqlStatementPtr)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [pObjSqlStatementPtr UTF8String],
										   -1, &lObjCompiledStatementPtr, NULL))
		{
			if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
			{
				//Delete success.
				lRetVal = YES;
			}
		}
        
		//Release the compiled statement from memory.
		sqlite3_finalize(lObjCompiledStatementPtr);
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}

-(BOOL)insertLoginInfo:(UserInfo *)pObjLoginPtr
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	
#if 0
	sqlStatement = [NSString stringWithFormat:@"Insert into Login (UserID, Password,LastTimeDownloaded,FirstName,LastName,Identifier) Values (?, ?, ?, ?, ?, ?)"];
#else
    sqlStatement = [NSString stringWithFormat:@"Insert into Login (UserID, Password,LastTimeDownloaded,FirstName,LastName,Identifier,IsAddedInOfflineMode) Values (?, ?, ?, ?, ?, ?, ?)"];
#endif
	
	if(nil != m_cDatabase)
	{
		if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL)) 
		{
			sqlite3_bind_text(compiledStatement, 1, [pObjLoginPtr.m_cObjUserIdPtr UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [pObjLoginPtr.m_cObjPasswordPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [pObjLoginPtr.m_cObjLastTimeDownloaded UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [pObjLoginPtr.m_cObjFirstNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [pObjLoginPtr.m_cObjLastNamePtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [pObjLoginPtr.m_cObjIdentifierPtr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 7, pObjLoginPtr.m_cIsAddedinOfflineMode);
            
			if(SQLITE_ERROR != sqlite3_step (compiledStatement))
			{
				success = YES;
			}
			else
				DSLog(@"Error: failed to insert into Login Table with message '%s'.", sqlite3_errmsg(m_cDatabase));
		}
		else
			DSLog(@"Error: failed to prepare Login table insert statement with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
	return success;
}
-(UserInfo *)getUserInfo
{
    NSString			*lObjSqlStatementPtr = nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    UserInfo            *lObjUserInforPtr = (UserInfo *)nil;
    
    lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Login where IsAddedInOfflineMode = 1"];
    
    if((NSString *)nil != lObjSqlStatementPtr)
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
        {
            //Get the number of records.
            if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
                lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
        }
        else{
            DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    }
    if (lRowCount > 0) {
        
        lObjUserInforPtr = [[UserInfo alloc] init];

        lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Login where IsAddedInOfflineMode = 1"];
        
        if((NSString *)nil != lObjSqlStatementPtr)
        {
           if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
            {
        
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(lObjCompiledStatementPtr) == SQLITE_ROW)
                {
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,0))
                        lObjUserInforPtr.m_cObjUserIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,0)];
                    if (nil != sqlite3_column_text(lObjCompiledStatementPtr,1))
                        lObjUserInforPtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(lObjCompiledStatementPtr,1)];
                }
                lRetVal = YES;
            }
           else
               DSLog(@"Error: failed to prepare statement for table Log with message '%s'.", sqlite3_errmsg(m_cDatabase));
            // Release the compiled statement from memory
            sqlite3_finalize(lObjCompiledStatementPtr);
            SAFE_RELEASE(lObjSqlStatementPtr)
        }
    }
    else
    {
        lRetVal = NO;
    }

    pthread_mutex_unlock(&m_cMutex);
    
    if (lRetVal)
    {
        return [lObjUserInforPtr autorelease];
    }
    else
    {
        SAFE_RELEASE(lObjUserInforPtr)
        return nil;
    }
    
    return nil;
}
//Narasimhaiah implementing to get user info 13-2-13 - start
-(UserInfo *)getUserDetail
{
    pthread_mutex_lock(&m_cMutex);
    
	BOOL			success = NO;
	sqlite3_stmt	*compiledStatement = nil;
	NSString		*sqlStatement = nil;
	UserInfo *lObjUserInfoPtr = (UserInfo *)nil;
	
	sqlStatement = @"Select * from Login";
	
	if(nil != m_cDatabase)
	{
		if(sqlite3_prepare_v2(m_cDatabase, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				lObjUserInfoPtr = [[UserInfo alloc] init];
                
                if(nil != sqlite3_column_text(compiledStatement, 0))
                    lObjUserInfoPtr.m_cObjUserIdPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				if(nil != sqlite3_column_text(compiledStatement, 1))
					lObjUserInfoPtr.m_cObjPasswordPtr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            }
            success = YES;
        }
        else
			DSLog(@"Error: failed to prepare statement for table Athlete with message '%s'.", sqlite3_errmsg(m_cDatabase));
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	
	pthread_mutex_unlock(&m_cMutex);
//    
//	if (success)
//	{
//		return [lObjUserInfoPtr autorelease];
//	}
//	else
//	{
//        SAFE_RELEASE(lObjUserInfoPtr)
//        return nil;
//	}
    return lObjUserInfoPtr;
}
//Narasimhaiah implementing to get user info 13-2-13 - end

-(BOOL)UpdateLoginInfo
{
    pthread_mutex_lock(&m_cMutex);
    
	NSString			*lObjSqlStatementPtr = (NSString *)nil;
	sqlite3_stmt		*lObjCompiledStatementPtr = (sqlite3_stmt *)nil;
	BOOL				lRetVal = NO;
	int					lRowCount = 0;
    
	if((sqlite3 *)nil != m_cDatabase)
	{
		lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Select * from Login where IsAddedInOfflineMode = 1"];
        
		if((NSString *)nil != lObjSqlStatementPtr)
		{
			if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
			{
				//Get the number of records.
				if(SQLITE_ROW == sqlite3_step(lObjCompiledStatementPtr))
					lRowCount = sqlite3_column_int(lObjCompiledStatementPtr, 0);
			}
            
			//Release the compiled statement from memory.
			sqlite3_finalize(lObjCompiledStatementPtr);
            
			SAFE_RELEASE(lObjSqlStatementPtr)
		}
        
            //Record found, update the record.
			lObjSqlStatementPtr = [[NSString alloc] initWithFormat:@"Update Login set IsAddedInOfflineMode =1"];
            
			if((NSString *)nil != lObjSqlStatementPtr)
			{
				if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [lObjSqlStatementPtr UTF8String],-1, &lObjCompiledStatementPtr, NULL))
				{
                    if(SQLITE_ERROR != sqlite3_step(lObjCompiledStatementPtr))
					{
						//Update Successful.
						lRetVal = YES;
					}
				}
                //Release the compiled statement from memory.
				sqlite3_finalize(lObjCompiledStatementPtr);
                
				SAFE_RELEASE(lObjSqlStatementPtr)
			}
	}
    
	pthread_mutex_unlock(&m_cMutex);
	return lRetVal;
}
-(BOOL)deleteLoginInfo
{
    BOOL	lRetVal = NO;
    
    lRetVal = [self deleteRecords:@"Delete from Login"];
    return lRetVal;
}

-(BOOL)deleteAthleteLog
{
    BOOL	lRetVal = NO;
    
    lRetVal = [self deleteRecords:@"Delete from Log"];
    return lRetVal;
}
-(BOOL)deleteCombineId
{
    BOOL	lRetVal = NO;
    
    lRetVal = [self deleteRecords:@"Delete from CombineTestID"];
    return lRetVal;
}
-(BOOL)deleteTests
{
    BOOL	lRetVal = NO;
    
    lRetVal = [self deleteRecords:@"Delete from Tests"];
    return lRetVal;
}
-(void)clearAllRecords
{
    [self deleteLoginInfo];
    [self deleteAthlete];
    [self deleteAthleteLog];
}

-(BOOL)clearLocalDB
{
    BOOL lRetval = NO;
    
    
    lRetval = [self deleteAthlete];
    if (lRetval) {
        lRetval = [self deleteAthleteLog];
    }
    if(lRetval)
    {
        lRetval = [self deleteCombineId];
    }
    if (lRetval) {
        lRetval = [self deleteTests];
    }
    return lRetval;
}
-(int)CountRecordForTable:(NSString *)name
{
	NSString		*sqlStatement = nil;
    sqlStatement =[NSString  stringWithFormat:@"SELECT COUNT(*) FROM %@",name];
    return [self RetriveCountWithQuery:sqlStatement];
}
- (int)RetriveCountWithQuery:(NSString *)pQuery
{
	pthread_mutex_lock(&m_cMutex);
    
    int             lRetVal = 0;
    sqlite3_stmt    *compiledStatement = (sqlite3_stmt *)nil;
    
    if((sqlite3 *)nil != m_cDatabase)
    {
        if(SQLITE_OK == sqlite3_prepare_v2(m_cDatabase, [pQuery UTF8String], -1, &compiledStatement, nil))
        {
            if(SQLITE_ERROR != sqlite3_step (compiledStatement))
            {
                lRetVal = sqlite3_column_int64(compiledStatement, 0);
            }
        }
        sqlite3_finalize(compiledStatement);
        pQuery = (NSString *)nil;
        compiledStatement = (sqlite3_stmt *)nil;
    }
    
   	pthread_mutex_unlock(&m_cMutex);
    return lRetVal;
}
- (void)dealloc
{
    sqlite3_free(m_cDatabase);
    [super dealloc];
}

@end
