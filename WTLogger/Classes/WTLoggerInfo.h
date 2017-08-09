//
//  WTLoggerInfo.h
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface WTLoggerInfo : NSObject

@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, copy) NSString *actionId;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSMutableArray *params;

@end
