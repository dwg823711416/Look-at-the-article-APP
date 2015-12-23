//
//  ThitdCollectionModel+CoreDataProperties.h
//  
//
//  Created by qianfeng on 15/12/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ThitdCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThitdCollectionModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *dateTime;
@property (nullable, nonatomic, retain) NSNumber *id;

@end

NS_ASSUME_NONNULL_END
