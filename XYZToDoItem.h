//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by Kirill Skulkin on 16.03.14.
//
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
