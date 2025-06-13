# Urbanmatch

A modern Flutter app for discovering and managing local events, featuring a beautiful map interface, event filtering, and a clean, responsive UI.

---

## Features

### 1. **Event Discovery with Map Integration**
- Interactive Google Map with custom dark styling.
- Each event is represented as a marker on the map.
- Markers are visually dynamic:  
  - When not selected or zoomed out, they appear as large orange dots.
  - When selected and zoomed in, they transform into location pins.
- Tapping an event in the list animates the map to the event's location with smooth camera movement.

### 2. **Event List with Filtering**
- Each event shows a relevant icon, name, and time.
- Filter events by **All**, **Upcoming**, or **Past** using the filter button at the top right.
- Selecting an event in the list highlights its marker on the map.

### 3. **Modern Bottom Navigation**
- Custom bottom navigation bar with three tabs.
- The first tab shows the event/map screen; the other two are placeholders for future features.
- Active tab is highlighted with an orange oval splash, matching the app's color scheme.

### 4. **State Management**
- Uses [GetX](https://pub.dev/packages/get) for efficient, reactive state management.
- All event data and loading states are managed via a dedicated `EventController`.

### 5. **API Integration**
- Fetches event data from a REST API using [Dio](https://pub.dev/packages/dio).
- Robust error handling for API requests.

### 6. **Theming and Design**
- Consistent color palette defined in `AppColors`.
- Responsive layouts and modern UI patterns.
- Custom map style for a dark, urban look.

---

## Project Structure

```
lib/
├── controllers/         # State management (GetX controllers)
│   └── event_controller.dart
├── model/               # Data models
│   └── eventl.dart
├── screen/              # UI screens
│   ├── event_screen.dart
│   └── empty_tab_screen.dart
├── services/            # API and data fetching
│   └── api_services.dart
├── utils/               # App-wide constants and colors
│   ├── app_const.dart
│   └── colors.dart
└── main.dart            # App entry point and navigation
```

---

## How It Works

### Event Flow
1. On launch, the app fetches events from the API.
2. Events are displayed as both map markers and in a list.
3. The user can:
   - Tap a marker or list item to focus on an event.
   - Filter events by time (All, Upcoming, Past).
   - Drag the event list up/down for more/less map view.

### Marker Logic
- Each event is assigned a random location (for demo purposes).
- Markers are big dots by default; the selected and zoomed-in marker becomes a location pin.

### Filtering
- The filter button (top right) lets you toggle between All, Upcoming, and Past events.
- The map and list update instantly to reflect the filter.

---

## How to Run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.7.0 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart)
- A device or emulator (iOS/Android)
- Internet connection (for API and map)

### Steps

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd urbanmatch
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

4. **(Optional) Configure Google Maps API Key:**
   - The app uses `google_maps_flutter`.  
   - For full map functionality, add your API key in the appropriate platform files (see [Google Maps Flutter setup](https://pub.dev/packages/google_maps_flutter)).

---

## Key Packages Used

- **[get](https://pub.dev/packages/get):** State management and dependency injection.
- **[dio](https://pub.dev/packages/dio):** HTTP client for API requests.
- **[google_maps_flutter](https://pub.dev/packages/google_maps_flutter):** Map integration.
- **[intl](https://pub.dev/packages/intl):** Date and time formatting.

---

## Code Highlights

- **State Management:**  
  All event data and loading states are managed with GetX (`EventController`).

- **API Service:**  
  `ApiService` fetches events from a REST endpoint and parses them into model objects.

- **Model:**  
  `Event` model with robust JSON parsing and error handling.

- **UI:**  
  - `EventScreen` combines map, list, and filter logic.
  - Custom marker logic for a polished map experience.
  - Responsive and modern navigation bar.

- **Theming:**  
  All colors are centralized in `AppColors` for easy updates and consistency.

---

## Customization

- To add more tabs, screens, or features, extend the `MainTabScaffold` in `main.dart`.
- To change the color scheme, update `lib/utils/colors.dart`.
- To use real event locations, update the event model and API to include latitude/longitude.

---

## Video Run down

[Flutter SDK](https://share.vidyard.com/watch/2t5hPVLCXCwWADfkq3iwiD) 

---

## Contact

For any questions or feedback, please contact [Apurv Jha] at [apurv.bmsit@gmail.com].

---

Good luck with your assignment submission! If you need a PDF version or want to add screenshots, let me know!
