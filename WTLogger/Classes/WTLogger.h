//
//  WTLogger.h
//  Pods
//
//  Created by walter on 09/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface WTLogger : NSObject

+ (WTLogger *)shareInstance;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
