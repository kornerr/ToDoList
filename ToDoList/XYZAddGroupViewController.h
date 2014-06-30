//
//  XYZAddGroupViewController.h
//  ToDoList
//
//  Created by Kirill Skulkin on 18.03.14.
//
//

#import <UIKit/UIKit.h>
#import "XYZTGroupItem.h"

@interface XYZAddGroupViewController : UIViewController <UIPickerViewDelegate>

@property (strong) NSManagedObject *group;
@property NSInteger *selectedRow;

@end