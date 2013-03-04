//
//  ImageThumbnailViewController.m
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import "ImageThumbnailViewController.h"
#import "ThumbnailTableViewCell.h"
#import "FlikrPhoto.h"
#import "PhotoCache.h"
#import "ImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageThumbnailViewController ()

@end

@implementation ImageThumbnailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)dealloc{
    [_queue cancelAllOperations];
    [_queue release];
    [super dealloc];
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    
    _rowHeight = 100;
    _numberOfImagesPerRow = ceil(self.view.bounds.size.width/_rowHeight);
    _queue = [NSOperationQueue new];
    [_queue setMaxConcurrentOperationCount:20];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.allowsSelection = NO;
    [self requestMorePages];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"Photos";
}

-(void)refresh:(id)sender{
    if (self.photoCache.photoCount>0) {
        [[self tableView] reloadData];
    }else{
        [self requestMorePages];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

#pragma mark - Table view data source

-(NSUInteger)totalRowsForImages{
    return ceil((float)self.photoCache.photoCount/_numberOfImagesPerRow);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self totalRowsForImages];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowHeight;
}

-(NSArray*)getPhotosForIndexPath:(NSIndexPath*)indexPath{
    NSMutableArray* arr = [[NSMutableArray new] autorelease];
    int start = indexPath.row * _numberOfImagesPerRow;
    for(int i =start;i< start+_numberOfImagesPerRow;i++){
        if (i >= self.photoCache.photoCount) {
            break;
        }
        [arr addObject:[self.photoCache photoForIndex:i]];
    }
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    static int CellIndex = 1;
    ThumbnailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[ThumbnailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.numberOfImages = _numberOfImagesPerRow;
        cell.rowHeight = _rowHeight;
        cell.delegate = self;
//        NSLog(@"New cell created %d",CellIndex++);
    }
    //    [cell.activityIndicator startAnimating];
    //    cell.activityIndicator.hidden = NO;
    [cell setImages:nil];
    NSArray* photos = [self getPhotosForIndexPath:indexPath];
    
    int i = 0;
    
    for (FlikrPhoto* photo in photos) {
        NSBlockOperation* oldOperation = nil;
        if (i < cell.loadImageOperations.count) {
            oldOperation = [[[cell.loadImageOperations objectAtIndex:i] retain] autorelease];
            [oldOperation cancel];
        }
        UIImageView* imgView = [cell imageViewForIndex:i];
        imgView.hidden = YES;
        if (photo.thumbnail) {
            imgView.image = photo.thumbnail;
            imgView.hidden = NO;
            imgView.alpha = 1;
        }else{
            NSBlockOperation* operation = [[[NSBlockOperation alloc] init] autorelease];
            [cell.loadImageOperations setObject:operation atIndexedSubscript:i];
            
            __block NSBlockOperation* bOpr = operation;
            [operation addExecutionBlock:^{
                if (bOpr.isCancelled) return;
                [photo loadThumbnail];
                if (bOpr.isCancelled) return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.hidden = NO;
                    imgView.alpha = 0;
                    imgView.image = photo.thumbnail;
                    [UIView animateWithDuration:0.3f animations:^{
                        imgView.alpha = 1;
                    }];
                });
            }];
            if(oldOperation && !oldOperation.isFinished){
                [operation addDependency:oldOperation];
            }
            [_queue addOperation:operation];
        }
        i++;
    }
    cell.indexPath = indexPath;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self totalRowsForImages] -1) {
        [self requestMorePages];
    }
}

-(void)requestMorePages{
    if (requestSent || !self.photoCache.hasMorePagesToLoad) return;
    
    requestSent = YES;
    [self.photoCache loadNextPageWithSuccessBlock:^{
        [self.tableView reloadData];
        requestSent = NO;
    } andErrorBlock:^(NSError *error) {
        NSLog(@"%@", [error description]);
        requestSent = NO;
    }];
}

#pragma mark - ThumbnailTableViewCellDelegate

-(void)thumbnailCell:(ThumbnailTableViewCell *)cell didSelectImageAtIndex:(NSUInteger)index{
    int photoIndex = _numberOfImagesPerRow * cell.indexPath.row + index;
    ImageViewController* imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    imageVC.photo = [self.photoCache photoForIndex:photoIndex];
    imageVC.title = [NSString stringWithFormat:@"Photo %d of %d",photoIndex,self.photoCache.photoCount];

    [self.navigationController pushViewController:imageVC animated:YES];
    [imageVC release];
}


@end
