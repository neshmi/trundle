//
//  CCouchDBView.h
//  CouchpadAdministrator
//
//  Created by Marty Schoch on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCouchDBView : NSObject {
    
}

@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, retain) NSMutableArray *rows;


@end
