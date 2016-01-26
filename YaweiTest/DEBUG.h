//
//  DEBUG.h
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/25.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#ifndef DEBUG_h
#define DEBUG_h

#define NSLog(format, ...) do {                                                                             \
                                fprintf(stderr, "<%s : %d> %s\n",                                           \
                                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
                                __LINE__, __func__);                                                        \
                                (NSLog)((format), ##__VA_ARGS__);                                           \
                                fprintf(stderr, "-------\n");                                               \
                            } while (0)

#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

#endif /* DEBUG_h */
