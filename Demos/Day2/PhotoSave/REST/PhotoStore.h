//
//  PhotoStore.h
//  REST
//
//  Created by Simon Kim on 13. 2. 19..
//  Copyright (c) 2013년 DZPub.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoStore : NSObject
- (NSArray *) loadDataList;
- (void) saveObject:(NSDictionary *) dataObject done:(void (^)(id key)) done;
- (NSDictionary *) loadObjectForKey:(id) key;
@end
