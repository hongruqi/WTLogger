//
//  WTLoggerCache.h
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import <Foundation/Foundation.h>
#define LOGTABLE                        @"LogTable"
#define LOGCOUNTWITHWIFI                10
#define LOGCOUNTWITHWWAN                40

@interface WTLoggerSQLUtility : NSObject

/**
 write log info to table

 @param logInfo info
 @return yes or no
 */
+ (BOOL)insertLogWithInfo:(NSData*)logInfo;

/**
 read info from table

 @return yes or on
 */
+ (NSArray*)readContentsFromDB;

/**
 delete info from table

 @param records delete items
 @return yes or no
 */
+ (BOOL)deleteRecords:(NSArray*)records;

@end
