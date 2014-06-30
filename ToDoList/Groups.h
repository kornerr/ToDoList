//
//  Groups.h
//  ToDoList
//
//  Created by Kirill Skulkin on 16.04.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notes;

@interface Groups : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSSet *fromGroupsToNotes;
@end

@interface Groups (CoreDataGeneratedAccessors)

- (void)addFromGroupsToNotesObject:(Notes *)value;
- (void)removeFromGroupsToNotesObject:(Notes *)value;
- (void)addFromGroupsToNotes:(NSSet *)values;
- (void)removeFromGroupsToNotes:(NSSet *)values;

@end
