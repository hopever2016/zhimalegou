//
//  GA.m
//  Luxy
//
//  Created by robyzhou on 14/11/21.
//  Copyright (c) 2014年 robyzhou. All rights reserved.
//

#import "GA.h"

static NSString* GAID = @"UA-90463286-1";

@implementation GA

//GA的上报放在一个串行队列中进行
static dispatch_queue_t GASerialQueue;

+ (void)init
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    //关闭GA的crash收集功能，这样crasylytics才能收到
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:GAID];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [[GAI sharedInstance].defaultTracker set:kGAIAppVersion value:version];
//    [[GAI sharedInstance].defaultTracker set:kGAIClientId value:@"115214"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GASerialQueue = dispatch_queue_create("QASerialQueue", NULL);
    });
}

+ (void)enable
{
    [GAI sharedInstance].optOut = NO;
}

+ (void)disable
{
    [GAI sharedInstance].optOut = YES;
}

+ (void)test
{
#if DEBUG
    
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"Test"
                                            action:@"Test"
                                             label:@"Test"
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    GAIDictionaryBuilder *buider =
    [GAIDictionaryBuilder createTimingWithCategory:@"category"
                                          interval:@0
                                              name:@"name"
                                             label:nil];
    [buider set:@"10" forKey:kGAITimingVar];
    [buider set:@"20" forKey:kGAITimingVar];
    [buider set:@"home screen" forKey:kGAIScreenName];
    [[GAI sharedInstance].defaultTracker send:[buider build]];
    [[GAI sharedInstance] dispatch];
    
#endif

}

+ (void)testTimming
{
    GAIDictionaryBuilder *buider =
    [GAIDictionaryBuilder createTimingWithCategory:@"category"
                                          interval:@0
                                              name:@"name"
                                             label:nil];
    [buider set:@"10" forKey:kGAITimingVar];
    [buider set:@"20" forKey:kGAITimingVar];
    [buider set:@"home screen" forKey:kGAIScreenName];
    [[GAI sharedInstance].defaultTracker send:[buider build]];
    [[GAI sharedInstance] dispatch];
}

+ (void)reportEventWithCategory:(NSString*)category
                         action:(NSString*)action
                          label:(NSString*)label
                          value:(NSNumber*)value
{
    NSString *userId = [ShareManager userID];
    if (userId.length > 0) {
        [[GAI sharedInstance].defaultTracker set:kGAIUserId value:userId];
        [[GAI sharedInstance].defaultTracker set:kGAIClientId value:userId];
    }
    
    //只在GA没有被关闭的情况下才发送统计
    if (![GAI sharedInstance].optOut) {
        dispatch_async(GASerialQueue, ^{
            NSMutableDictionary *event =
            [[GAIDictionaryBuilder createEventWithCategory:category
                                                    action:action
                                                     label:label
                                                     value:value] build];
            [[GAI sharedInstance].defaultTracker send:event];
            [[GAI sharedInstance] dispatch];
        });
    }
}

@end
