//
//  ImageScrollViewController.m
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import "ImageScrollViewController.h"
#import "PhotoCache.h"
#import "FlikrPhoto.h"
#import "ImageCell.h"

@interface ImageScrollViewController ()

@end

#define kImageMargin 10

@implementation ImageScrollViewController
@synthesize photoCache;

- (void)dealloc
{
    [_queue cancelAllOperations];
    [_queue release];
    self.photoCache = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];
   
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoCache photoCount];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageCell";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSLog(@"========== new cell CREATED=========");
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    CGRect rect = cell.frame;
    rect.size = self.tableView.bounds.size;
    cell.frame = rect;
    cell.photoImageView.frame = CGRectMake(kImageMargin, kImageMargin, self.tableView.bounds.size.width - 2*kImageMargin, self.tableView.bounds.size.height - 2*kImageMargin);
    cell.photoImageView.backgroundColor = [UIColor redColor];
    FlikrPhoto* photo = [self.photoCache photoForIndex:indexPath.row];
    // Configure the cell...
    
    if (!photo.image) {
        [cell.activityIndicator startAnimating];
        cell.activityIndicator.hidden = NO;
        NSBlockOperation* operation = [[[NSBlockOperation alloc] init] autorelease];
        [operation addExecutionBlock:^{
            [photo loadImage];
            if (!photo.image) {
                return;
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSArray* visibleCells = [self.tableView indexPathsForVisibleRows];
                bool visble = NO;
                for (NSIndexPath* path in visibleCells) {
                    if (path.row == indexPath.row) {
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        NSLog(@"image set for %@",indexPath);
                        break;
                    }
                }
                if (!visble) {
                     NSLog(@"========== cell is NIL=========");
                }
             }];
        }];
        [_queue addOperation:operation];
    }else{
        cell.photoImageView.image = photo.image;
        [cell.activityIndicator stopAnimating];
        cell.activityIndicator.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:0 green:0.188235 blue:0.313725 alpha:1];
    
    ImageCell* c = (ImageCell*)cell;
    CGRect rect = c.photoImageView.frame;
    rect.size = CGSizeMake(c.bounds.size.height, c.bounds.size.width);
    c.photoImageView.frame = rect;
    c.photoImageView.center = c.center;
    c.photoImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
}

#pragma mark - Scroll view delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

@end
