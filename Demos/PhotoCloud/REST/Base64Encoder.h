//
//  Base64Encoder.h
//  XMLRPCTest
//
//  Created by Simon Kim on 12. 3. 25..
//  Copyright (c) 2012년 DZPub.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Base64Encoder : NSObject
+ (NSUInteger) chunkSize;
+ (NSString *)base64StringFromData: (NSData *)data length: (int)length;
+ (NSData *)base64DataFromString: (NSString *)string;
@end
