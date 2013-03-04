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
    }else{
        self.imageView.image = photo.thumbnail;
        [self performSelectorInBackground:@selector(getImage) withObject:nil];
    }
}

-(void)getImage{
    [photo loadImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = self.photo.image;
    });
}

@end
