//
//  ViewController.m
//  Photos
//
//  Created by Farhad Noorzay on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCache.h"
#import "FlikrPhoto.h"
#import "ImageScrollViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [_queue cancelAllOperations];
    [_queue release];
    [_photoCache release];
    [_imageScrollVC release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _photoCache = [[PhotoCache alloc] init];
    [self loadNextPage];
    _imageScrollVC = [[ImageScrollViewController alloc] initWithNibName:@"ImageScrollViewController" bundle:nil];
    _imageScrollVC.photoCache = _photoCache;
    [self addChildViewController:_imageScrollVC];
    _imageScrollVC.view.frame = self.referenceView.frame;
    [self.view addSubview:_imageScrollVC.view];
    [_imageScrollVC didMoveToParentViewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark networkLoading

-(void)loadNextPage{
    [_photoCache loadNextPageWithSuccessBlock:^{
        [_imageScrollVC.tableView reloadData];
    } andErrorBlock:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

-(void)refresh:(id)sender{
    [_imageScrollVC.tableView reloadData];
}
@end
