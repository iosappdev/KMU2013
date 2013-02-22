//
//  PhotoStore.m
//  REST
//
//  Created by Simon Kim on 13. 2. 19..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import "PhotoStore.h"

@implementation PhotoStore

+ (NSString *) newUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return CFBridgingRelease(string);
}

- (NSArray *) loadDataList
{
    
    NSMutableArray *dataList = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    NSString *documentsDir = [URL path];
    NSDirectoryEnumerator *denum = [fileManager enumeratorAtPath:documentsDir];
    NSString *file;
    while( file = [denum nextObject]) {
        if ( [[file pathExtension] isEqualToString:@"pho"]) {
            NSDictionary *object = [NSDictionary dictionaryWithContentsOfFile:[documentsDir stringByAppendingPathComponent:file]];
            [dataList addObject:object];
        }
    }
    return [dataList copy];
}

- (void) saveObject:(NSDictionary *) dataObject done:(void (^)(id key)) done
{
    id result = nil;    // file name upon success
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    NSString *documentsDir = [URL path];

    NSString *file = [[[self class] newUUID] stringByAppendingPathExtension:@"pho"];
    
    if ([dataObject writeToFile:[documentsDir stringByAppendingPathComponent:file] atomically:YES]) {
        result = file;
    }
    done(result);
}

- (NSDictionary *) loadObjectForKey:(id) key
{
    NSString *file = (NSString *) key;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    NSString *documentsDir = [URL path];
    
    NSDictionary *object = [NSDictionary dictionaryWithContentsOfFile:[documentsDir stringByAppendingPathComponent:file]];
    return object;
}

@end
