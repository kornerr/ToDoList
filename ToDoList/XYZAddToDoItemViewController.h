//
//  XYZAddToDoItemViewController.h
//  ToDoList
//
//  Created by Kirill Skulkin on 15.03.14.
//
//

#import <UIKit/UIKit.h>


@interface XYZAddToDoItemViewController : UIViewController
@property (strong) NSManagedObject *note;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@end
 