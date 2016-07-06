//
//  FKFlickrPrefsGetContentType.m
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPrefsGetContentType.h" 

@implementation FKFlickrPrefsGetContentType



- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 0;
}

- (NSString *) name {
    return @"flickr.prefs.getContentType";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPrefsGetContentTypeError_SSLIsRequired:
			return @"SSL is required";
		case FKFlickrPrefsGetContentTypeError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPrefsGetContentTypeError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPrefsGetContentTypeError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPrefsGetContentTypeError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPrefsGetContentTypeError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPrefsGetContentTypeError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPrefsGetContentTypeError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrPrefsGetContentTypeError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPrefsGetContentTypeError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPrefsGetContentTypeError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPrefsGetContentTypeError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPrefsGetContentTypeError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end
