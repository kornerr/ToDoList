//
//  Notes.h
//  ToDoList
//
//  Created by Kirill Skulkin on 16.04.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Groups;

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * describtion;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * noteName;
@property (nonatomic, retain) Groups *fromNotesToGroups;

@end
