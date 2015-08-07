//
//  defines.h
//  londonCycles
//
//  Created by Giulio Zicchi on 30/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//
//---------------------------------------------------------

#define ZDEBUG

//---------------------------------------------------------

#ifdef ZDEBUG
#   define ZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define ZLog(...)
#endif

//---------------------------------------------------------


#ifndef londonCycles_defines_h
#define londonCycles_defines_h


#endif
