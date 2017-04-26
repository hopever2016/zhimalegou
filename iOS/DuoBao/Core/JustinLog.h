//
//  JustinLog.h
//  Luxy
//
//  Created by justin on 4/7/15.
//  Copyright (c) 2015 robyzhou. All rights reserved.
//

#ifndef Luxy_JustinLog_h
#define Luxy_JustinLog_h

#pragma mark - Developer

#if DEBUG

#define JustinTest 1

#else

#define JustinTest 0

#endif


#if JustinTest
#define XLog(...) NSLog(__VA_ARGS__)
#define JustinPrintSendMessage 1
#else
#define XLog(...) {}
#define JustinPrintSendMessage 0
#endif

#endif
