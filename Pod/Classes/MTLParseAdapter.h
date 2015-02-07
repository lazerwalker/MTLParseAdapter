#import <Foundation/Foundation.h>

@class PFObject;
@class MTLModel;
@protocol MTLJSONSerializing;

@interface MTLParseAdapter : NSObject

#pragma mark - Single object methods
/**
 * @name Convert a single object
 */

/** Attempts to convert a model object into a PFObject
 * @param model The model to serialize
 * @return A PFObject representing the model, or nil if a parsing error occured.
 *
 * If the model object contains properties with the following names, they
 * will be set on the PFObject as their corresponding properties, rather than
 * being included in the key/value representation of the object:
 *
 * - objectId
 * - parseClassName
 * - createdAt
 * - updatedAt
 */
+ (PFObject *)parseObjectFromModel:(MTLModel <MTLJSONSerializing> *)model;

/** Attempts to convert a PFObject into a model object
 * @param modelClass The MTLModel subclass to convert into. This must conform to MTLJSONSerializing
 * @param parseObject The PFObject to convert
 *
 * @return An instance of `modelClass`, or nil if a parsing error occured.
 */
+ (MTLModel<MTLJSONSerializing> *)modelOfClass:(Class)modelClass
                               fromParseObject:(PFObject *)object;

/** Attempts to convert a PFObject into a model object
 * Instead of specifying a model class, this will try to infer the model class
 * from the `parseClassName` property of the PFObject
 * 
 * @see modelOfClass:fromParseObject
 */
+ (MTLModel<MTLJSONSerializing> *)modelFromParseObject:(PFObject *)object;

#pragma mark - Array methods
/**
 * @name Convert an array of objects
 */

/** Attempts to convert an array of model objects into PFObjects
 * @param models An array of models to serialize
 * @return An array of PFObjects, or nil if any parsing error occured.
 *
 * @see parseObjectFromModel:
 */
+ (NSArray *)parseObjectsFromModels:(NSArray *)models;


/** Attempts to convert an array of PFObjects into model objects
 * @param modelClass The MTLModel subclass to use to parse all models
 * @param objects An array of PFObjects to serialize
 * @return An array of `modelClass` objects, or nil if any parsing error occured.
 *
 * @see modelsFromParseObjects:
 */
+ (NSArray *)modelsOfClass:(Class)modelClass
          fromParseObjects:(NSArray *)objects;

/** Attempts to convert an array of PFObjects into model objects
 * Instead of specifying a model class, this will try to infer the model class
 * from the `parseClassName` property of each individual PFObject
 *
 * @see modelsOfClass:fromParseObjects:
*/
+ (NSArray *)modelsFromParseObjects:(NSArray *)models;

@end
