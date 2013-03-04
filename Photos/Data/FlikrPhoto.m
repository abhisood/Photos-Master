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
    [imageId release];
    [title release];
    [image release];
    [thumbnail release];
    [imageURLString release];
    [thumbnailURLString release];
    [super dealloc];
}

#pragma mark ServerCommunication methods

-(void)loadImage{
    @synchronized(imageURLString){
        if (!image) {            
            image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURLString]]] retain];
        }
    }
}

-(void)loadThumbnail{
    @synchronized(thumbnailURLString){
        if (!thumbnail) {
            thumbnail = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]]] retain];
        }
    }
}

@end
