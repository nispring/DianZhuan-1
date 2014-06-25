//
//  SINGLETON_GCD.h
//  MiJia
//
//  Created by 时代合盛 on 14-5-19.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}

#endif
