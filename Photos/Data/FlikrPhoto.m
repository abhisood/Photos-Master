//
//  FlikrPhoto.m
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import "FlikrPhoto.h"

//@interface FlikrPhoto ()
//
//@end

@implementation FlikrPhoto

@synthesize imageURLString,thumbnailURLString;
@synthesize image, thumbnail;
@synthesize title,imageId;

-(id)initWithID:(NSString *)imgID title:(NSString *)titleStr thumbnailURL:(NSString *)tURL andImageURL:(NSString *)iURL{
    self = [super init];
    if (self) {
        imageId = [imgID retain];
        title = [titleStr retain];
        imageURLString = [iURL retain];
        thumbnailURLString = [tURL retain];
    }
    return self;
}

- (void)dealloc
{
    [self.imageId release];
    [self.title release];
    [self.image release];
    [self.thumbnail release];
    [self.imageURLString release];
    [self.thumbnailURLString release];
    [super dealloc];
}

#pragma mark ServerCommunication methods

-(void)loadImage{
    if (_imageRequested) {
        return;
    }
    _imageRequested = YES;
    image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURLString]]] retain];
}

-(void)loadThumbnail{
    if (_thumbnailRequested) {
        return;
    }
    _thumbnailRequested = YES;
    thumbnail = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]]] retain];
}

@end
