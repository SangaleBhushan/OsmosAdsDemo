# OsmosAdsDemo

A native iOS demo application that integrates the OSMOS Ads SDK to fetch, render, and track display banner advertisements.

This project was created as part of the iOS Developer Assignment to demonstrate API-driven ad rendering, impression tracking, click tracking, error handling, reusable components, and production-oriented iOS architecture.

## Features

- Native iOS application using Swift and SwiftUI
- OSMOS SDK integration
- AU-based display ad fetching
- Multiple banner ads in a scrollable feed
- Dynamic image rendering
- Banner aspect-ratio handling using API-provided width and height
- 50% visibility-based impression tracking
- Impression deduplication
- OSMOS click tracking
- Destination URL handling
- Loading state
- Empty/fallback state
- Network error handling
- SDK initialization failure handling
- Invalid/missing field handling
- Retry mechanism
- Pull-to-refresh
- Lightweight analytics/logging layer
- MVVM architecture
- Repository abstraction
- Dependency injection
- Reusable visibility tracking component

## Assignment Objective

The objective of this project is to build a native iOS application that fetches, renders, and tracks display banner advertisements using the OSMOS Ads system.

The implementation focuses on:

- API-driven ad responses
- Dynamic banner rendering
- Correct impression tracking
- Correct click tracking
- Graceful failure handling
- Reusable production-oriented components
- Native iOS development

## OSMOS Configuration

The application uses the configuration provided in the assignment:

```
clientId       = 10088010
productAdsHost = demo.o-s.io
displayAdsHost = demo-ba.o-s.io
```

The display ad request uses:

```
cliUbid  = Any
pageType = demo_page
adUnit   = banner_ads
```

## Setup

### Requirements

- Xcode
- iOS Simulator or physical iOS device
- Swift
- SwiftUI
- Native iOS environment

### Installation

1. Clone the repository.
2. Open `OsmosAdsDemo.xcodeproj` in Xcode.
3. Allow Swift Package Manager to resolve the OSMOS SDK dependency.
4. Select an iOS Simulator or connected device.
5. Build and run the application.

The application initializes the OSMOS SDK during app startup.

## OSMOS SDK

The OSMOS iOS SDK is integrated using Swift Package Manager. The project resolves the SDK dependency through Xcode's Swift Package Manager integration.

## How Ad Fetching Works

The application uses a layered architecture for fetching ads:

```
AdsView
    |
    v
AdsViewModel
    |
    v
AdRepository
    |
    v
OsmosAdRepository
    |
    v
OsmosSDKService
    |
    v
OSMOS SDK
    |
    v
Display Ad API
    |
    v
OsmosAdMapper
    |
    v
[Ad]
    |
    v
SwiftUI
```

The request is made through the OSMOS SDK using:

```
cliUbid  = Any
pageType = demo_page
adUnit   = banner_ads
```

The application requests multiple ads and renders the ads returned by the backend. The backend may return fewer ads than requested, so the application renders the actual returned collection instead of creating artificial ads.

## Ad Response Mapping

The OSMOS response contains banner ad information under `ads.banner_ads`.

The application extracts the following fields:

| Field | Description |
|---|---|
| `elements.value` | Banner image URL |
| `elements.destination_url` | Landing/destination URL |
| `impression_tracking_url` | Impression tracking information |
| `click_tracking_url` | Click tracking information |
| `uclid` | Unique ad tracking identifier |
| `rank` | Ad position |
| `elements.width` | Banner width |
| `elements.height` | Banner height |

The SDK response is converted into the application's strongly typed `Ad` model through `OsmosAdMapper`.

## Banner Rendering

Banner images are rendered manually using SwiftUI. The image URL comes from `elements.value`.

The API-provided dimensions are used to preserve the image's aspect ratio. For example:

```
width  = 200
height = 200
```

produces a `1:1` aspect ratio.

The renderer does not assume that every advertisement has the same dimensions.

## Multiple Ads

The application requests multiple display ads and renders the returned advertisements inside a scrollable feed.

Example from testing:

```
Request
    productCount = 5

OSMOS Response
    4 advertisements

UI
    Ad 1
    Ad 2
    Ad 3
    Ad 4
```

The number of advertisements returned is controlled by the OSMOS backend. The UI uses a `ScrollView` and `LazyVStack` so the application can render multiple banner advertisements efficiently.

## Impression Tracking

### 50% Visibility Requirement

An impression is fired when at least 50% of an advertisement is visible on screen. The application uses a reusable `AdVisibilityTracker` component. The tracker observes the advertisement's position and calculates the visible portion of the ad.

The calculation is conceptually:

```
Visible Area
-------------
Total Area
```

The impression threshold is **50%**.

Examples:

| Ad visibility | Result |
|---|---|
| 30% | No impression |
| 50% | Impression fired |
| 75% | Impression fired |

The visibility tracker only determines whether the ad is visible. It does not directly communicate with the OSMOS SDK.

### Impression Deduplication

Each advertisement contains a unique `uclid`. The ViewModel maintains a set of already-tracked advertisements: `trackedImpressions`.

When an ad reaches the 50% visibility threshold:

```
Is this ad already tracked?
        |
        +---- YES ---> Do nothing
        |
        +---- NO ----> Fire impression
```

This prevents multiple impressions from being generated when the user scrolls away from an advertisement and later scrolls back to it.

### Impression Event Flow

```
Ad rendered
    |
    v
Visibility tracker
    |
    v
50% visible?
    |
    +---- NO ----> Continue observing
    |
    +---- YES
            |
            v
    AdsViewModel
            |
            v
    Already tracked?
            |
            +---- YES ----> Ignore
            |
            +---- NO
                    |
                    v
             AdEventTracker
                    |
                    v
               OSMOS SDK
                    |
                    v
             Impression Event
```

The application also records an application-level log:

```
Impression Fired - position X
```

## Click Handling

When the user taps an advertisement:

```
User taps ad
      |
      +----------------------+
      |                      |
      v                      v
Click tracking          Destination URL
      |                      |
      v                      v
OSMOS SDK               openURL()
```

The application performs two separate responsibilities:

1. Fire the OSMOS click event.
2. Open `elements.destination_url` when it is available.

The click tracking URL is not treated as the user's landing page.

## Destination URL Handling

The application reads the destination URL from `elements.destination_url`.

When a valid destination URL is present:

```
User tap
   |
   v
Click event is fired
   |
   v
Destination URL opened
```

If the destination URL is missing:

```
User tap
   |
   v
Click event is still tracked
   |
   v
No invalid URL is opened
   |
   v
Destination unavailable message
```

This allows the application to handle incomplete demo responses gracefully.

## Loading State

While the application is fetching advertisements, a loading/skeleton state is displayed. The loading state is controlled by `isLoading` in `AdsViewModel`.

## Error Handling

The application handles the following error scenarios.

### SDK Initialization Failure

If OSMOS SDK initialization fails, the application does not crash. The application transitions to a fallback state and displays the ad-unavailable UI.

### No Ads

If the OSMOS response contains no usable banner advertisements, `Ad not available` is displayed.

### Network Errors

Network or request failures are caught by the repository/service layer and passed to the ViewModel. The UI then displays a fallback/error state instead of crashing.

### Invalid or Missing Fields

The mapper safely handles malformed advertisements. Examples include:

- Missing elements
- Missing image URL
- Empty image URL
- Missing uclid
- Empty uclid
- Invalid JSON
- Missing destination URL

Advertisements that do not contain the required fields for rendering/tracking are skipped safely.

## Retry Mechanism

The application provides a retry action when ad loading fails. The user can select `Try Again` to initiate another fetch attempt.

Pull-to-refresh is also supported when the ad feed is already displayed.

### Preventing Duplicate Requests

The ViewModel maintains an `isLoading` state. Before starting a new request, `isLoading == true` prevents another request from being started concurrently.

Example:

```
Request A
   |
   +---- running

Request B
   |
   +---- ignored while A is running
```

This prevents multiple simultaneous ad fetch operations.

## Lifecycle and Rotation

The application uses SwiftUI lifecycle handling. When the application becomes active again, it only attempts to load advertisements automatically when no ads are currently available.

Screen layout changes, including rotation, cause the visibility tracker to recalculate the advertisement's visible area.

The impression set is retained so an already-tracked advertisement does not generate another impression simply because the layout changed.

## Logging and Analytics

A lightweight logging layer is used to capture important advertisement events. The application records:

- Ad Loaded
- Ad Failed
- Impression Fired
- Click Fired

Examples:

```
Ad Loaded - 4 ad(s)
Ad Failed - Empty response
Impression Fired - position 2
Click Fired - position 2
```

OSMOS SDK responses and errors are also logged for debugging purposes.

## Architecture

The project follows a modular MVVM + Repository architecture.

```
OsmosAdsDemo
│
├── App
│   ├── OsmosAdsDemoApp.swift
│   ├── AppContainer.swift
│   ├── OsmosSDKConfiguration.swift
│   └── OsmosSDKState.swift
│
├── Core
│   ├── DesignSystem
│   │   ├── AppColors.swift
│   │   ├── AppTypography.swift
│   │   ├── AppSpacing.swift
│   │   └── AppRadius.swift
│   │
│   ├── Extensions
│   │   └── View+Extensions.swift
│   │
│   └── Logging
│       └── AppLogger.swift
│
├── Features
│   └── Ads
│       ├── Models
│       │   └── Ad.swift
│       │
│       ├── Views
│       │   ├── AdsView.swift
│       │   ├── AdCardView.swift
│       │   ├── AdStatsView.swift
│       │   ├── AdHeaderView.swift
│       │   ├── AdLoadingView.swift
│       │   └── AdEmptyView.swift
│       │
│       ├── ViewModels
│       │   └── AdsViewModel.swift
│       │
│       ├── Components
│       │   ├── PrimaryButton.swift
│       │   ├── StatCard.swift
│       │   ├── ShimmerView.swift
│       │   └── AdVisibilityTracker.swift
│       │
│       ├── Repository
│       │   ├── AdRepository.swift
│       │   ├── MockAdRepository.swift
│       │   ├── FailedAdRepository.swift
│       │   └── OsmosAdRepository.swift
│       │
│       └── Services
│           ├── OsmosSDKService.swift
│           ├── OsmosSDKError.swift
│           ├── OsmosAdMapper.swift
│           └── AdEventTracker.swift
│
└── Resources
```

### Component Responsibilities

**AdsView**
Responsible for:
- Presenting the ad feed
- Presenting loading/error states
- Handling user interaction
- Opening the destination URL
- Connecting the UI to the ViewModel

**AdCardView**
Responsible for:
- Rendering the advertisement banner
- Rendering sponsored information
- Presenting the CTA
- Handling user taps

The card does not contain OSMOS-specific networking logic.

**AdsViewModel**
Responsible for:
- Loading state
- Advertisement collection
- Error state
- Impression deduplication
- Click counting
- Coordinating tracking actions

**AdRepository**
Provides an abstraction over the ad data source and allows the ViewModel to remain independent from the OSMOS SDK implementation.

**OsmosAdRepository**
Connects the repository abstraction to the OSMOS SDK service.

**OsmosSDKService**
Responsible for OSMOS-specific ad fetching. The SDK-specific implementation remains outside the SwiftUI presentation layer.

**OsmosAdMapper**
Converts the SDK response into the strongly typed application `Ad` model. It also handles malformed or incomplete banner entries safely.

**AdEventTracker**
Encapsulates OSMOS impression and click events. This keeps event tracking separate from the ViewModel and UI.

**AdVisibilityTracker**
A reusable SwiftUI modifier used to calculate whether an advertisement has reached the 50% visibility threshold.

**AppContainer**
Provides dependencies to the application. This keeps dependency construction separate from the views and supports testing.

## Testing

The project includes unit-test coverage for important ad parsing and ViewModel behavior.

Important scenarios include:

- Valid ad response
- Empty banner response
- Missing elements
- Missing image
- Empty image
- Missing uclid
- Empty uclid
- Missing destination URL
- Invalid JSON
- Valid + malformed ads
- Successful ad loading
- Empty response
- Network failure
- Impression tracked only once
- Multiple clicks
- Refresh failure

The tests focus on business logic and response parsing rather than testing the OSMOS SDK itself.

Run the tests from **Product → Test** in Xcode.

## Assumptions

**Backend determines the number of returned ads**
The application requests multiple ads, but the OSMOS backend determines how many are actually returned. The application renders the advertisements returned by the SDK.

**Destination URL may be missing**
The application assumes that some demo advertisements may not provide a destination URL. The advertisement can still be rendered and its click can still be tracked.

**Tracking URL and destination URL are separate**
The application treats `click_tracking_url` as tracking information. The application treats `destination_url` as the user-facing landing page.

**Impression threshold**
The application considers an advertisement eligible for impression tracking when at least 50% of its visible area is on screen.

**Impression deduplication**
An advertisement is identified using its `uclid`. Only one impression is recorded for a given ad instance.

## Challenges Faced

**Parsing the OSMOS SDK response**

The OSMOS SDK returns a dictionary structure where the ad payload is contained inside a JSON string. The application therefore performs:

```
SDK response
     |
     v
response
     |
     v
data
     |
     v
JSON decoding
     |
     v
ads.banner_ads
     |
     v
Ad model
```

**50% Visibility Tracking**

SwiftUI does not provide a direct callback that says an arbitrary view is 50% visible. A reusable geometry-based visibility tracker was created to calculate the visible portion of each advertisement.

**Multiple Banner Sizes**

Different advertisements can have different width and height values. The renderer therefore uses the dimensions supplied by the API to preserve the creative's aspect ratio.

**Missing Destination URLs**

The demo API can return advertisements without a destination URL. The implementation keeps click tracking separate from navigation so that a missing destination does not result in an invalid URL being opened.

## How to Run the Demo

1. Open the Xcode project.
2. Resolve the Swift Package dependencies.
3. Select an iOS Simulator or physical device.
4. Run the application.
5. Wait for the advertisements to load.
6. Scroll through the feed.
7. Observe impressions being fired when an advertisement becomes at least 50% visible.
8. Tap an advertisement to test click tracking and destination handling.
9. Use the retry action to test failure recovery.

## Demo Recording

1. Application launch
2. Loading state
3. Advertisement loading
4. Multiple banner ads
5. Scrolling through advertisements
6. 50% visibility impression
7. Click tracking
8. Destination URL opening
9. No-destination handling
10. Error/fallback state
11. Retry action

## Screenshots
 <img width="280" height="600" alt="Screenshot iPhone 18 Pro 22-09-2026 at 2 06 21 PM" src="https://github.com/user-attachments/assets/289529d6-71f7-4982-a5e0-a50b9b530e93" />
 <img width="280" height="600" alt="Screenshot iPhone 18 Pro 22-09-2026 at 2 06 24 PM" src="https://github.com/user-attachments/assets/8d474870-622f-41c7-9e47-bce0a7af5cc1" />
 <img width="280" height="600" alt="Screenshot iPhone 18 Pro 22-09-2026 at 2 06 29 PM" src="https://github.com/user-attachments/assets/5f4dab4b-e359-4217-9d54-af1e7d6a7bfc" />
<img width="280" height="600" alt="Screenshot iPhone 18 Pro 22-09-2026 at 2 06 36 PM" src="https://github.com/user-attachments/assets/e5388950-b28d-47b0-8cb7-c67479c1eeb4" />
<img width="280" height="600" alt="Screenshot iPhone 18 Pro 22-09-2026 at 2 40 46 AM" src="https://github.com/user-attachments/assets/233d7524-55ea-4a42-86a4-634ff63a427c" />
## Demo Video


https://github.com/user-attachments/assets/53ad8598-ac3d-4a0a-be40-c3f87ccc017f




https://github.com/user-attachments/assets/e2082ec5-b5c3-499f-9dbf-a8a9d1db1767















## Final Notes

This project keeps the OSMOS SDK isolated behind service and repository abstractions while keeping the SwiftUI presentation layer focused on rendering and user interaction.

The implementation is designed to demonstrate:

- Native iOS development
- SwiftUI
- MVVM
- Repository pattern
- Dependency injection
- Swift concurrency
- API response parsing
- Visibility tracking
- Analytics/logging
- Resilient UI behavior
- Testable business logic

## Assignment Coverage

| Requirement | Status |
|---|---|
| SDK Integration | ✅ |
| AU-based Ad Fetching | ✅ |
| Manual Banner Rendering | ✅ |
| Multiple Ads | ✅ |
| Scrollable Feed | ✅ |
| 50% Impression Tracking | ✅ |
| Impression Deduplication | ✅ |
| Click Tracking | ✅ |
| Destination URL Handling | ✅ |
| Event Logging | ✅ |
| Loading State | ✅ |
| Error Handling | ✅ |
| Retry Mechanism | ✅ |
| Reusable Visibility Tracker | ✅ |
| Analytics/Logging Layer | ✅ |
| Modular Architecture | ✅ |
# OsmosAdsDemo
