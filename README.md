# NHBAVAssetTrimming

AV-media files sometimes have video and audio tracks starting at different offsets, and with different durations - especially when recorded without post-processing. Usually these differences are small, but they can be noticeable in situations like looping assets.

`NHBAVAssetTrimming` is an Objective-C category for `AVAsset` with a single method that removes ("trims") these overhangs from tracks. It tries to preserve as much of the structure and the properties of the original asset as possible. Internally, it computes the intersection of the time ranges of the tracks, then copies this time range to an `AVMutableComposition`. The returned composition can be further processed, played or exported with the usual AVFoundation classes. 

The Xcode project builds a simple macOS command line utility for trimming av-media files without re-encoding; it prints usage information when run without parameters. If in doubt, please have look at the utility source code on how to use the category.

Licensed under BSD 3-Clause, see LICENSE.