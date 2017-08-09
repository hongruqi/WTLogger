//
//  WTLoggerSQLUtility.m
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import "WTLoggerSQLUtility.h"
#import "WTLoggerDB.h"
#import "Reachability.h"

@implementation WTLoggerSQLUtility

//!创建表
+ (BOOL)createLogTable
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:LOGTABLE];
    if (!obj || ![obj boolValue]) {
        NSString *sqlString = [self getCreateSqlForTable:LOGTABLE];
        BOOL bSuccess = [[WTLoggerDB shareInstance] executeUpdateBySql:sqlString];
        [[NSUserDefaults standardUserDefaults] setObject:@(bSuccess) forKey:LOGTABLE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return bSuccess;
    }
    
    return [obj boolValue];
}

+ (BOOL)insertLogWithInfo:(NSData *)logInfo
{
    BOOL sqlResult = NO;
    if ([self createLogTable]) {
        NSString *sqlString = [self getInsertSqlForTable:LOGTABLE];
        sqlResult = [[WTLoggerDB shareInstance] executeUpdateBySql:sqlString withArgumentsInArray:@[logInfo]];
    }
    return sqlResult;
}

+ (NSArray *)readContentsFromDB
{
    NSArray *results = nil;
    NSString *sqlString = [self getQuerySqlForTable:LOGTABLE];
    if (sqlString) {
        results = [[WTLoggerDB shareInstance] executeQueryBySql:sqlString];
    }
    
    return results;
}

+ (BOOL)deleteRecords:(NSArray *)records
{
    BOOL bSuccess = NO;
    if (records && records.count > 0) {
        NSMutableString *conditionString = [NSMutableString stringWithFormat:@"("];
        for (int i = 0;i < records.count; i++) {
            id obj = records[i];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                int index = [[obj objectForKey:@"id"] intValue];
                if (i == records.count -1) {
                    [conditionString appendFormat:@"%d)",index];
                }
                else{
                    [conditionString appendFormat:@"%d,",index];
                }
            }
        }
        
        NSString *deleteString = [self getDeleteSqlForTable:LOGTABLE withCondition:conditionString];
        bSuccess = [[WTLoggerDB shareInstance] executeUpdateBySql:deleteString];
    }
    
    return bSuccess;
}

#pragma mark - sql string

+ (NSString *)getCreateSqlForTable:(NSString *)table
{
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement,logbody blob)",table];
}

+(NSString*)getInsertSqlForTable:(NSString*)table
{
    return [NSString stringWithFormat:@"insert into %@ (logbody) values (?)",table];
}

//!返回查询字符串；如果该字符串为nil，表示当前无网络
+ (NSString *)getQuerySqlForTable:(NSString *)table
{
    int count = 0;
    //这里判断网络情况，如果wifi：则读取10条；如果是非Wifi：则读取40条；
    NetworkStatus status = [[Reachability reachabilityForInternetConnection ] currentReachabilityStatus];
    //wifi网络
    if (status == ReachableViaWiFi){
        count = LOGCOUNTWITHWIFI;
    }else if (status == ReachableViaWWAN){
         //运营商网络
        count = LOGCOUNTWITHWWAN;
    }else{
        return nil;
    }
    
    return [NSString stringWithFormat:@"select id, logbody from %@ order by id asc limit %d",table,count];
}

//!删除指定记录
+ (NSString *)getDeleteSqlForTable:(NSString *)table withCondition:(NSString*)conditionString
{
    return [NSString stringWithFormat:@"delete from %@ where id in %@",table,conditionString];
}

@end
