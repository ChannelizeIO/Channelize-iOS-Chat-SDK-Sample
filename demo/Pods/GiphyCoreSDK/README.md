# Giphy Core SDK for Swift


The **Giphy Core SDK** is a wrapper around [Giphy API](https://github.com/Giphy/GiphyAPI).

[![Build Status](https://travis-ci.com/Giphy/giphy-ios-sdk-core.svg?token=ApviWy5Ne8UKNzA4xUNJ&branch=master)](https://travis-ci.com/Giphy/giphy-ios-sdk-core)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/GiphyCoreSDK.svg)]()
[![](https://img.shields.io/badge/OS%20X-10.12%2B-lightgrey.svg)]()
[![](https://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()
[![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)]()




[Giphy](https://www.giphy.com) is the best way to search, share, and discover GIFs on the Internet. Similar to the way other search engines work, the majority of our content comes from indexing based on the best and most popular GIFs and search terms across the web. We organize all those GIFs so you can find the good content easier and share it out through your social channels. We also feature some of our favorite GIF artists and work with brands to create and promote their original GIF content.

[![](https://media.giphy.com/media/5xaOcLOqNmWHaLeB14I/giphy.gif)]()

# Getting Started

### Supported Platforms

* iOS
* macOS
* tvOS
* watchOS

### Supported End-points

* [Search GIFs/Stickers](#search-endpoint)
* [Trending GIFs/Stickers](#trending-endpoint)
* [Translate GIFs/Stickers](#translate-endpoint)
* [Random GIFs/Stickers](#random-endpoint)
* [GIF by ID](#get-gif-by-id-endpoint)
* [GIFs by IDs](#get-gifs-by-ids-endpoint)
* [Categories for GIFs](#categories-endpoint)
* [Subcategories for GIFs](#sub-categories-endpoint)
* [GIFs for a Subcategory](#sub-category-content-endpoint)
* [Term Suggestions](#term-suggestions-endpoint)

### Advanced Usage

* [Filtering](#filtering-models)
* [User Dictionaries](#user-dictionaries)

# Setup

### CocoaPods Setup

Add the GiphyCoreSDK entry to your Podfile

```
pod 'GiphyCoreSDK'
```

Run pods to grab the GiphyCoreSDK framework

```bash
pod install
```

### Carthage Setup

Add the GiphyCoreSDK entry to your Cartfile

```
git "git@github.com:Giphy/giphy-ios-sdk-core.git" "master"
```

Run carthage update to grab the GiphyCoreSDK framework

```bash
carthage update
```

### Swift Package Manager Setup

* Add .package(url:"https://github.com/Giphy/giphy-ios-sdk-core", from: "1.2.0") to your package dependencies.
* Then add GiphyCoreSDK to your target dependencies. 

### Initialize Giphy SDK

```swift
// Configure your API Key
GiphyCore.configure(apiKey: "YOUR_API_KEY")
```

### Search Endpoint
Search all Giphy GIFs for a word or phrase. Punctuation will be stripped and ignored. 

```swift
/// Gif Search
let op = GiphyCore.shared.search("cats") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Results Found")
    }
}

/// Sticker Search
let op = GiphyCore.shared.search("dogs", media: .sticker) { (response, error) in
    //...
}
```

### Trending Endpoint
Fetch GIFs currently trending online. Hand curated by the Giphy editorial team. The data returned mirrors the GIFs showcased on the [Giphy](https://www.giphy.com) homepage.

```swift
/// Trending GIFs
let op = GiphyCore.shared.trending() { (response, error) in
    //...
}

/// Trending Stickers
let op = GiphyCore.shared.trending(.sticker) { (response, error) in
    //...
}
```

### Translate Endpoint
The translate API draws on search, but uses the Giphy "special sauce" to handle translating from one vocabulary to another. In this case, words and phrases to GIFs. Example implementations of translate can be found in the Giphy Slack, Hipchat, Wire, or Dasher integrations. Use a plus or url encode for phrases.

```swift
/// Translate to a GIF
let op = GiphyCore.shared.translate("cats") { (response, error) in
    //...
}

/// Translate to a Sticker
let op = GiphyCore.shared.translate("cats", media: .sticker) { (response, error) in
    //...
}
```

### Random Endpoint
Returns a random GIF, limited by tag. Excluding the tag parameter will return a random GIF from the Giphy catalog.

```swift
/// Random GIF
let op = GiphyCore.shared.random("cats") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data  {
        print(response.meta)
        print(data)
    } else {
        print("No Result Found")
    }
}

/// Random Sticker
let op = GiphyCore.shared.random("cats", media: .sticker) { (response, error) in
    //...
}
```

### Get GIF by ID Endpoint
Returns meta data about a GIF, by GIF id. In the below example, the GIF ID is "feqkVgjJpYtjy"

```swift
/// Gif by Id
let op = GiphyCore.shared.gifByID("feqkVgjJpYtjy") { (response, error) in
    //...
}
```

### Get GIFs by IDs Endpoint
A multiget version of the get GIF by ID endpoint. In this case the IDs are feqkVgjJpYtjy and 7rzbxdu0ZEXLy.

```swift
/// GIFs by Ids
let ids = ["feqkVgjJpYtjy", "7rzbxdu0ZEXLy"]

let op = GiphyCore.shared.gifsByIDs(ids) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Result Found")
    }
}
```

### Categories Endpoint
A multiget version of the get GIF by ID endpoint. In this case the IDs are feqkVgjJpYtjy and 7rzbxdu0ZEXLy.

```swift
/// Get top trending categories for GIFs.
let op = GiphyCore.shared.categoriesForGifs() { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Top Categories Found")
    }
}
```

### Sub-Categories Endpoint
Get Sub-Categories for GIFs given a cateory. You will need this sub-category object to pull GIFs for this category.

```swift
/// Sub-Categories for a given category.
let category = "actions"

let op = GiphyCore.shared.subCategoriesForGifs(category) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for subcategory in data {
            print(subcategory)
        }
    } else {
        print("No Result Found")
    }
}
```

### Sub-Category Content Endpoint
Get GIFs for a given Sub-Category. 

```swift
/// Sub-Category Content
let category = "actions"
let subCategory = "cooking"

let op = GiphyCore.shared.gifsByCategory(category, subCategory: subCategory) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No GIFs Found")
    }
}
```


### Term Suggestions Endpoint
Get term suggestions give a search term, or a substring.

```swift
/// Term Suggestions
let op = GiphyCore.shared.termSuggestions("carm") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data {
        print(response.meta)
        for term in data {
            print(term)
        }
    } else {
        print("No Terms Suggestions Found")
    }
}
```

# Advanced Usage

## Filtering Models

We added support for you to filter results of any models out during requests. Here are few use cases below in code:

```swift
GiphyCore.setFilter(filter: { obj in
            if let obj = obj as? GPHMedia {
                
                // Check to see if this Media object has tags
                // Say we only want GIFs/Stickers with tags, otherwise filter them out
                return obj.tags == nil
                
            } else if let obj = obj as? GPHChannel {
            
                // We only want channels which have featured Gifs
                return obj.featuredGif != false
            }
            
            // Otherwise this is a valid object, don't filter it out
            return true
        })
```

## User Dictionaries

We figured you might want to attach extra data to our models such us `GPHMedia` .. so now all our models have `userDictionary`
which you can attach any sort of object along with any of our models. 

```swift
/// Gif Search
let op = GiphyCore.shared.search("cats") { (response, error) in

    if let error = error as NSError? {
        ......
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        for result in data {
            result.userDictionary = ["Description" : "Results from Cats Search"]
        }
    } else {
        print("No Results Found")
    }
}
```






