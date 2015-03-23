//
//  ToDoItem.h
//  ToDoList
//
//  Created by Kapil Gowru on 12/25/14.
//  Copyright (c) 2014 Kapil Gowru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
