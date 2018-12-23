//
//  main.m
//  NHBAVAssetTrimming
//
//  Copyright © 2018 nhb | fluthaus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVAsset+NHBAVAssetTrimming.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSArray<NSString*>* args = NSProcessInfo.processInfo.arguments;
		if (args.count == 3)
		{
			NSURL* srcURL = [NSURL fileURLWithPath:args[1].stringByStandardizingPath];
			NSURL* dstURL = [NSURL fileURLWithPath:args[2].stringByStandardizingPath];

			if (srcURL && dstURL && [@[ @"mov", @"mp4"] containsObject:dstURL.pathExtension.lowercaseString])
			{
				AVAsset* srcAsset = [AVURLAsset URLAssetWithURL:srcURL options:@{ AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];

				NSError* error = nil;
				AVAsset* dstAsset = [srcAsset NHBTrimmedComposition:&error];

				if (dstAsset)
				{
					AVAssetExportSession* exportSession = [AVAssetExportSession exportSessionWithAsset:dstAsset presetName:AVAssetExportPresetPassthrough];
					exportSession.videoComposition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:dstAsset];
					exportSession.outputURL = dstURL;
					exportSession.outputFileType = [dstURL.pathExtension.lowercaseString isEqualToString:@"mov"] ? AVFileTypeQuickTimeMovie : AVFileTypeMPEG4;

					unlink( [dstURL.path cStringUsingEncoding:NSUTF8StringEncoding]);

					dispatch_semaphore_t semaphore = dispatch_semaphore_create( 0);
					[exportSession exportAsynchronouslyWithCompletionHandler:
						^{
							if (exportSession.status == AVAssetExportSessionStatusFailed)
								NSLog( @"export failed: %@", exportSession.error);
							dispatch_semaphore_signal( semaphore);
						}];
					dispatch_semaphore_wait( semaphore, DISPATCH_TIME_FOREVER);
					exit(0);
				}
				else
				{
					NSLog(@"trimming failed: %@", error);
					exit(1);
				}
			}
		}

		printf( "Trims overhangs from tracks, whithout re-encoding.\nVersion 1.0. Copyright (c) 2018 nhb | fluthaus\nUsage:\n   trimMovie inputfile outputfile.(mov|mp4)\n");
	}
	return 0;
}
