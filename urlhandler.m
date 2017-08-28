#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

int main(int argc, const char *argv[]) {
	if (argc < 2) {
		fprintf(stderr, "No scheme specified!\n");
		return 2;
	}

	NSString *scheme = [NSString stringWithUTF8String: argv[1]];
	NSArray *handlers = (__bridge NSArray *)LSCopyAllHandlersForURLScheme(
		(__bridge CFStringRef)scheme
	);

	if (argc < 3) {
		if (!handlers) {
			fprintf(stderr, "No handlers found for scheme: %s\n", [scheme UTF8String]);
			return 1;
		}

		NSString *defaultHandler = (__bridge NSString *)LSCopyDefaultHandlerForURLScheme(
			(__bridge CFStringRef)scheme
		);

		for (int i = 0; i < [handlers count]; i++) {
			NSString *handler = handlers[i];

			printf("%c%s\n", [handler isEqual: defaultHandler] ? '*' : ' ', [handler UTF8String]);
		}
	} else {
		NSString *handler = [NSString stringWithUTF8String: argv[2]];

		if ([handlers indexOfObjectPassingTest: ^ (id obj, NSUInteger idx, BOOL *stop) {
			return (BOOL)([handler caseInsensitiveCompare: obj] == NSOrderedSame);
		}] == NSNotFound) {
			fprintf(stderr, "Not a valid scheme %s handler: %s\n", [scheme UTF8String], [handler UTF8String]);
			return 2;
		}

		OSStatus status = LSSetDefaultHandlerForURLScheme(
			(__bridge CFStringRef)scheme,
			(__bridge CFStringRef)handler
		);
		if (status) {
			fprintf(stderr, "Error %d during an attempt to set scheme %s handler to: %s\n", status, [scheme UTF8String], [handler UTF8String]);
			return 1;
		}
	}

	return 0;
}
