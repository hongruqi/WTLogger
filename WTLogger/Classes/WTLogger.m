//
//  WTLogger.m
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import "WTLogger.h"
#import "WTLoggerInfo.h"
#import "WTLoggerSQLUtility.h"

#define WTMaxLogCapacityPerDayKey         @"MaxLogCapacityPerDayKey"
#define WTMaxLogCapacityPerDayValue       50*1024
#define WTCurrentDayInfoKey               @"CurrentDayInfoKey"

#define WT_BEHAVIOR_LOG_FILE @"WTLogger.dat"
#define WT_BEHAVIOR_LOG_ZIPFILE @"WTLogger.zip"

@interface WTLogger()

@property (nonatomic, strong) NSLock *writeFileLock;
@property (nonatomic, assign) BOOL enterForground;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, strong) NSMutableDictionary *header;

@end

@implementation WTLogger

+ (WTLogger *)shareInstance
{
    static dispatch_once_t onceToken;
    static WTLogger *shareInstance;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[WTLogger alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *logFolder = [self managerMainPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:logFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _writeFileLock = [[NSLock alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        _header = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    
    if (eventId.length > 0) {
        const char *eventChars = [eventId cStringUsingEncoding:NSUTF8StringEncoding];
        NSUInteger eventLen = strlen(eventChars);
        [bodyData appendBytes:&eventLen length:1];
        [bodyData appendBytes:eventChars length:eventLen];
        NSMutableData *dicData = [[NSMutableData alloc] initWithData:[NSJSONSerialization dataWithJSONObject:attributes options:0 error:nil]];

        if (dicData) {
            [bodyData appendData:dicData];
        }
        
        [WTLoggerSQLUtility insertLogWithInfo:bodyData];
    }
}

- (NSString*)managerMainPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WTLogger"];
}


@end
