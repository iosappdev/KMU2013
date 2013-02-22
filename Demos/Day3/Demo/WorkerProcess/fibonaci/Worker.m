//
//  Worker.m
//  fibonaci
//
//  Created by Simon Kim on 13. 2. 22..
//  Copyright (c) 2013년 KMU. All rights reserved.
//

#import "Worker.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation Worker

NSString * digestSHA1(NSString *inputString)
{
    NSString *result = nil;
    unsigned char digest[CC_SHA1_DIGEST_LENGTH+1];
    NSData *stringBytes = [inputString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        digest[CC_SHA1_DIGEST_LENGTH] = 0;
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *output = [NSMutableString string];
        for( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%X", digest[i]];
        }
        result = [output copy];
    }
    return result;
}

NSString * digestSHA1Loop(NSString *inputString, int count) {
    NSString *output;
    for( int i = 0; i < count; i++ ) {
        output = digestSHA1(inputString);
        inputString = output;
    }
    return output;
}

- (NSString *) process:(NSString *) input
{
    return digestSHA1Loop(input, 1000000);
}

@end
