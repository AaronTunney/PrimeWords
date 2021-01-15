# Prime Words

Written by Aaron Tunney

[![Build status](https://build.appcenter.ms/v0.1/apps/88ca5698-ecfd-4c69-9436-e24b043ed4a7/branches/main/badge)](https://appcenter.ms)

## Task:

The test is as follows:

Given a book in a text file ([The Railway Children](http://www.loyalbooks.com/download/text/Railway-Children-by-E-Nesbit.txt) for example)

1. Write an application that outputs the individual words that appear in the book, and how many times that word appears in the text file.
1. The second part is also output whether the number of times each word appears is a prime number.

The following assumptions can be made:
 - Ignore punctuation and capitalisation

### It would be beneficial to consider/use

The tech stack we use is:
- MVVM-C clean architecture
- Swift 5.x
- RxSwift & RxCocoa
- Realm
- Views in code, we don’t use Storyboards or Nibs
- XCTest and XCUI for testing
- Scalability and performance

If time permits, use local DB as a cache (optional)

Comments and rationale for the chosen solution

## Solution

The ideal solution to this task would be a [share extension](https://developer.apple.com/design/human-interface-guidelines/ios/extensions/sharing-and-actions/) that can be accessed directly through Safari. Given the time contraints, this project instead only performs the task on text files bundled with the app.

The architecture of the solution is as follows:

- MVVM-C clean architecture
- Swift 5.3
- Combine (i.e. Apple's native equivalent of RxSwift)
- Realm
- No storyboards or nibs
- XCTests unit tests only for now
- SFSymbols
- Support for dark mode, accessibility and localization

## Assumptions

- All words, including the table of contents are to be read.

## What's missing due to time constraints

- Surfacing errors to the user
- Network-based text file selection
- iCloud drive support
- Separating the Book Analyzer into its own framework/Swift package
- Reporting book analysis progress (thankfully it's quick enough to not be an major issue)
- Realm migration support
- RxSwift/RxCocoa (_I'm still learning!_)
- XCUI tests
- Support for < iOS 13

## Roadmap

### General

- [x] Basic app structure

### Interface

- [x] List of files view
- [x] Progress view
- [x] Results view
- [ ] Display primes

### Engine

- [x] Analyse chunk
- [x] Read whole book
