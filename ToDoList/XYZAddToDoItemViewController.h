

#import <UIKit/UIKit.h>


@interface XYZAddToDoItemViewController : UIViewController
 
@property (strong) NSManagedObject *note;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;


@end

