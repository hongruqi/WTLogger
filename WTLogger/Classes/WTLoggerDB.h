//
//  WTLoggerDB.h
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface WTLoggerDB : NSObject

+ (WTLoggerDB *)shareInstance;

- (BOOL)executeUpdateBySql:(NSString*)sql;

- (BOOL)executeUpdateBySql:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;

- (NSArray *)executeQueryBySql:(NSString *)sql;

@end
