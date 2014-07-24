//
//  Notes.h
//  ToDoList
//
//  Created by Кирилл on 21.07.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * describtion;
@property (nonatomic, retain) NSString * noteName;

@end
