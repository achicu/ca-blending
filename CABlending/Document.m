//
//  Document.m
//  CABlendingDoc
//
//  Created by Chiculita Alexandru on 10/21/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "Document.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    NSArray* cloneSublayers = [self.view.layer.sublayers copy];
    for (CALayer* layer in cloneSublayers)
        [layer removeFromSuperlayer];
    for (CALayer* layer in self.sublayers)
        [self.view.layer addSublayer:layer];
    self.sublayers = nil;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.view.layer.sublayers];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.sublayers = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return YES;
}

@end
