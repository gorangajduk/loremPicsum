# Lorem Picsum iOS App

A modern iOS application built with SwiftUI that displays a gallery of photos from the [Lorem Picsum API](https://picsum.photos/). The app features infinite scrolling, pull-to-refresh, and detailed photo views.

## Features

- 📱 **Photo Grid**: Browse photos in a responsive 2-column grid layout
- ♾️ **Infinite Scrolling**: Automatically loads more photos as you scroll
- 🔄 **Pull to Refresh**: Refresh the photo list with a simple pull gesture
- 🖼️ **Photo Details**: View full-size images with author, dimensions, and source information
- 🎨 **Modern UI**: Clean SwiftUI interface with smooth animations
- ⚡ **Error Handling**: Graceful error states with retry functionality
- 📭 **Empty States**: Informative UI when no photos are available
- 🧪 **Comprehensive Testing**: Full unit and UI test coverage

## Dependencies

- [Kingfisher](https://github.com/onevcat/Kingfisher) - Async image loading and caching

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/lorem-picsum-ios.git
cd lorem-picsum-ios
```

2. Install dependencies using Swift Package Manager (SPM):
   - Open `LoremPicsum.xcodeproj` in Xcode
   - Dependencies will be automatically resolved

3. Build and run the project in Xcode (⌘R)

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:
```
LoremPicsum/
├── Models/
│   └── Photo.swift                 # Photo data model
├── Services/
│   ├── PhotoServiceProtocol.swift  # Service abstraction
│   ├── PhotoService.swift          # API service implementation
│   └── MockPhotoService.swift      # Mock services for testing
├── ViewModels/
│   └── PhotoListViewModel.swift    # Business logic and state management
├── Views/
│   ├── PhotoListView.swift         # Main photo grid view
│   ├── PhotoGridCell.swift         # Individual photo cell
│   ├── PhotoDetailView.swift       # Photo detail screen
│   └── ImageFailureView.swift      # Error state component
└── Tests/
    ├── PhotoServiceTests.swift     # Unit tests for service layer
    └── PhotoListViewUITests.swift  # UI tests for main features
```

### Key Components

#### PhotoService
Handles all network requests to the Lorem Picsum API with:
- Pagination support (page and limit parameters)
- Comprehensive error handling
- Type-safe error types
- Protocol-based design for testability

#### PhotoListViewModel
Manages the state of the photo list:
- Loading, success, failure, and empty states
- Pagination logic with automatic loading
- Pull-to-refresh functionality
- Observable pattern using `@Observable` macro

#### Views
- **PhotoListView**: Main screen with grid layout and state management
- **PhotoGridCell**: Reusable cell component with Kingfisher image loading
- **PhotoDetailView**: Full-screen photo view with metadata
- **ImageFailureView**: Reusable error state component

## Testing

The project includes comprehensive test coverage:

### Unit Tests
```bash
# Run unit tests
⌘U in Xcode
```

Unit tests cover:
- ✅ Successful photo fetching
- ✅ Pagination with correct URL parameters
- ✅ HTTP error handling (404, 500, etc.)
- ✅ JSON decoding errors
- ✅ Network errors
- ✅ Empty response handling

### UI Tests
UI tests cover:
- ✅ Photo grid display
- ✅ Navigation to detail view
- ✅ Pull-to-refresh functionality
- ✅ Infinite scrolling
- ✅ Error states with retry
- ✅ Empty states
- ✅ Detail view content display
```bash
# Run UI tests
⌘U in Xcode (with UI Testing scheme selected)
```

### Test Coverage
The project uses MockURLProtocol to intercept network calls, ensuring tests are:
- Fast (no real network requests)
- Reliable (consistent results)
- Isolated (no external dependencies)

## API

The app uses the [Lorem Picsum API](https://picsum.photos/):

**Endpoint**: `https://picsum.photos/v2/list`

**Parameters**:
- `page`: Page number (default: 1)
- `limit`: Number of photos per page (default: 30)

**Response**: Array of photo objects with:
- `id`: Unique photo identifier
- `author`: Photo author name
- `width`: Photo width in pixels
- `height`: Photo height in pixels
- `url`: Original photo source URL
- `download_url`: Direct download URL

## Error Handling

The app handles various error scenarios:

1. **Network Errors**: Displayed with retry button
2. **Server Errors**: Shows HTTP status code with retry option
3. **Image Loading Failures**: Shows placeholder with error message
4. **Empty Results**: Informative empty state with pull-to-refresh hint

## Features in Detail

### Infinite Scrolling
- Automatically loads the next page when scrolling near the bottom (last 5 items)
- Prevents duplicate requests with loading state management
- Detects end of pagination when fewer photos are returned

### Pull to Refresh
- Resets to page 1 and clears existing photos
- Native iOS refresh control
- Works on all screens with scrollable content

### Image Caching
- Powered by Kingfisher for efficient memory and disk caching
- Automatic image download cancellation on scroll
- Progressive loading with placeholder indicators

## Contributing

This is a technical assignment, so contributions are not expected. However, feel free to explore the codebase.

## Acknowledgments

- [Lorem Picsum](https://picsum.photos/) for the photo API
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading
- [Unsplash](https://unsplash.com/) for the original photos
