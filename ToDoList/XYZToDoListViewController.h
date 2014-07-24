//
//  XYZToDoListViewController.h
//  ToDoList
//
//  Created by Kirill Skulkin on 15.03.14.
//
//

#import <UIKit/UIKit.h>
#import "XYZAddToDoItemViewController.h"

@interface XYZToDoListViewController : UITableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
 
@property (retain, nonatomic) XYZAddToDoItemViewController *add;

@end
