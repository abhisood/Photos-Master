//
//  ViewController.h
//  Photos
//
//  Created by Farhad Noorzay on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    @private
    IBOutlet UIScrollView *scrollView_;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView_;

- (IBAction)refresh:(id)sender;

@end
