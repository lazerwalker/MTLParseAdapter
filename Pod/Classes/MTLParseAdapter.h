//
//  MTLParseAdapter.h
//  Pods
//
//  Created by Michael Walker on 2/6/15.
//
//

#import <Foundation/Foundation.h>

@class PFObject;
@class MTLModel;
@protocol MTLJSONSerializing;

@interface MTLParseAdapter : NSObject

+ (PFObject *)parseObjectFromModel:(MTLModel <MTLJSONSerializing> *)model;
+ (MTLModel<MTLJSONSerializing> *)modelOfClass:(Class)modelClass
                               fromParseObject:(PFObject *)object;

+ (NSArray *)parseObjectsFromModels:(NSArray *)models;
+ (NSArray *)modelsOfClass:(Class)modelClass
          fromParseObjects:(NSArray *)models;

@end
