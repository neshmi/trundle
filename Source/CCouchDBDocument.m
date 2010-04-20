//
//  CCouchDBDocument.m
//  CouchTest
//
//  Created by Jonathan Wight on 02/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBDocument.h"

#import "CCouchDBDatabase.h"

@implementation CCouchDBDocument

@synthesize database;
@synthesize identifier;
@synthesize revision;
@dynamic encodedIdentifier;
@dynamic URL;
@synthesize content;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
if ([key isEqualToString:@"asJSONDictionary"])
	return([NSSet setWithObjects:@"identifier", @"revision", @"content", NULL]);
else
	{
	return(NULL);
	}
}

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase;
{
if ((self = [self init]) != NULL)
	{
	database = inDatabase;
	}
return(self);
}

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase identifier:(NSString *)inIdentifier
{
if ((self = [self initWithDatabase:inDatabase]) != NULL)
	{
	identifier = [inIdentifier copy];
	}
return(self);
}

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase identifier:(NSString *)inIdentifier revision:(NSString *)inRevision;
{
if ((self = [self initWithDatabase:inDatabase identifier:inIdentifier]) != NULL)
	{
	revision = [inRevision copy];
	}
return(self);
}

- (void)dealloc
{
database = NULL;
[identifier release];
identifier = NULL;
[revision release];
revision = NULL;
[content release];
content = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (id:%@ rev:%@ %@)", [super description], self.identifier, self.revision, self.content]);
}

#pragma mark -

- (NSString *)identifier
{
@synchronized(self)
	{
	if (identifier == NULL && self.content != NULL)
		{
		return([self.content objectForKey:@"_id"]);
		}
	return(identifier);
	}
}

- (void)setIdentifier:(NSString *)inIdentifier
{
@synchronized(self)
	{
	if (self.content == NULL)
		{
		if (identifier != inIdentifier)
			{
			[identifier release];
			identifier = [inIdentifier copy];
			}
		}
	else
		{
		if (identifier != NULL)
			{
			[identifier release];
			identifier = NULL;
			}
		
		NSMutableDictionary *theContent = [NSMutableDictionary dictionaryWithDictionary:self.content];
		[theContent setObject:inIdentifier forKey:@"_id"];
		self.content = theContent;
		}
	}
}

- (NSString *)revision
{
@synchronized(self)
	{
	if (revision == NULL && self.content != NULL)
		{
		return([self.content objectForKey:@"_rev"]);
		}
	return(revision);
	}
}

- (void)setRevision:(NSString *)inRevision
{
@synchronized(self)
	{
	if (self.content == NULL)
		{
		if (revision != inRevision)
			{
			[revision release];
			revision = [inRevision copy];
			}
		}
	else
		{
		if (revision != NULL)
			{
			[revision release];
			revision = NULL;
			}
		
		NSMutableDictionary *theContent = [NSMutableDictionary dictionaryWithDictionary:self.content];
		[theContent setObject:inRevision forKey:@"_rev"];
		self.content = theContent;
		}
	}
}

- (NSString *)encodedIdentifier
{
return([(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.identifier, NULL, CFSTR("/"), kCFStringEncodingUTF8) autorelease]);
}

- (NSURL *)URL
{
return([NSURL URLWithString:self.encodedIdentifier relativeToURL:self.database.URL]);
}

- (void)populateWithJSONDictionary:(NSDictionary *)inDictionary
{
self.content = inDictionary;
}

- (NSDictionary *)asJSONDictionary
{
if (self.content)
	{
	return(self.content);
	}
else
	{
	return([NSDictionary dictionaryWithObjectsAndKeys:
		self.identifier, @"_id",
		self.revision, @"_rev",
		NULL]);
	}
}

#pragma mark -

//- (BOOL)beginContentAccess;
//- (void)endContentAccess;
//- (void)discardContentIfPossible;
//- (BOOL)isContentDiscarded;

@end
