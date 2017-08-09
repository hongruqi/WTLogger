//
//  WTLoggerDB.m
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import "WTLoggerDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define LOGSTORAGE_FOLDER_PATH            @"WTLogStorage"
#define LOGSTORAGE_DATABASE_NAME          @"WTLogger.db"

@interface WTLoggerDB()

@property (nonatomic, strong) FMDatabaseQueue *fmdbQueue;

@end

@implementation WTLoggerDB

+ (WTLoggerDB *)shareInstance
{
    static dispatch_once_t onceToken;
    static WTLoggerDB *shareInstance;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[WTLoggerDB alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *path = [self databasePath];
        _fmdbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    }
    
    return self;
}

-(void)dealloc
{
    [self.fmdbQueue close];
}

- (NSString *)databasePath
{
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LOGSTORAGE_FOLDER_PATH];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    NSString *dbPath = [folderPath stringByAppendingPathComponent:LOGSTORAGE_DATABASE_NAME];
    return dbPath;
}

- (BOOL)executeUpdateBySql:(NSString*)sql
{
    __block BOOL result = NO;
    [_fmdbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    return result;
}

- (BOOL)executeUpdateBySql:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
{
    __block BOOL result = NO;
    [_fmdbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql withArgumentsInArray:arguments];
    }];
    return result;
}

- (NSArray *)executeQueryBySql:(NSString *)sql
{
    __block NSArray *array = nil;
    [_fmdbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        array = [self parseFMResultSet:rs];
    }];
    return array;
}

- (NSArray *)parseFMResultSet:(FMResultSet *)rs {
    NSMutableArray *array = [NSMutableArray array];
    int columnCount = [rs columnCount];
    while ([rs next]) {
        id ojb = nil;
        NSString *name = nil;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < columnCount; i++) {
            ojb = [rs objectForColumnIndex:i];
            name = [rs columnNameForIndex:i];
            [dict setObject:ojb forKey:name];
        }
        [array addObject:dict];
    }
    [rs close];
    if (array.count > 0) {
        return array;
    }
    return nil;
}
@end
