//
//  Document.h
//  CABlendingDoc
//
//  Created by Chiculita Alexandru on 10/21/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomView.h"

@interface Document : NSDocument

@property (weak) IBOutlet CustomView *view;
@property (strong) NSArray* sublayers;

@end
