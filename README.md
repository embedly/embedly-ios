# embedly-ios

[![Version](http://cocoapod-badges.herokuapp.com/v/embedly-ios/badge.png)](http://cocoadocs.org/docsets/embedly-ios)
[![Platform](http://cocoapod-badges.herokuapp.com/p/embedly-ios/badge.png)](http://cocoadocs.org/docsets/embedly-ios)

## Usage

The Embedly iOS library gives you access to all of Embedly's APIs, but there are two different ways to interact with the APIs:

- Embed, Extract, and legacy APIs are available through the call{EmbedlyApi,Embed,Extract,...} methods, which initiate an HTTP call which invokes the corresponding delegate method (embedly{Success,Failure}) upon completion.

- The Display API is different. The build{DisplayUrl,CroppedImageUrl,...} methods simply return an NSString containing the URL for the manipulated image via the Embedly Display API. You can use this URL wherever you would use any other image address (e.g. AFNetworking+UIImage).

The call{EmbedlyApi,Embed,...} methods use delegation to return the result of the API call, so your code will need to implement the EmbedlyDelegate protocol. The API response is returned in 'response', which can be accessed as an NSDictionary.

To make it simpler to cache API calls within your app, the call{EmbedlyApi,Embed,...} functions return a string containing the full Embedly API call. You can use this as a key to store API responses (e.g. in an NSDictionary). This return value is also useful in debugging an API call.

To make batch API calls (multiple URLs at the same time), you can use the callEmbedlyApi:withUrls:params: method, which takes an NSArray of NSStrings. In this case, the API response returned in 'response' can be accessed as an NSArray of NSDictionarys.

## Requirements

All of Embedly's products are free to use up to a limit, you just need to sign up for an API key at:

https://app.embed.ly/signup

Make sure to include your API key when you initialize the Embedly object.

If your app is doing well and you need more usage, you can learn more about our plans at:

http://embed.ly/api

## Installation

embedly-ios is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "embedly-ios"

To run the example project; clone the repo, and run `pod install` from the Example directory first. You will need to add your Embedly API key to the initWithKey:delegate: method (replace "mykey" with your API key).

## Author

@embedly

## License

embedly-ios is available under the MIT license. See the LICENSE file for more info.

