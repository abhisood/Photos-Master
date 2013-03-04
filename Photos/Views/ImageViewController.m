//
//  ImageViewController.m
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import "ImageViewController.h"
#import "FlikrPhoto.h"

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize photo;
@synthesize imageView,titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.photo = nil;
    self.imageView = nil;
    self.titleLabel = nil;
    [_activityIndicator release];
    
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
    // Do any additional setup after loading the view from its nib.
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_activityIndicator] autorelease];
    _activityIndicator.hidden =YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.titleLabel.text = self.photo.title;
    if (photo.image) {
        self.imageView.image = photo.image;
        _activityIndicator.hidden =YES;
    }else{
        self.imageView.image = photo.thumbnail;
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
        [self performSelectorInBackground:@selector(getImage) withObject:nil];
    }
}

-(void)getImage{
    [photo loadImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = self.photo.image;
        _activityIndicator.hidden = YES;
        [_activityIndicator stopAnimating];
    });
}

@end
