# DEPD - Daily Wellness App

A clean, responsive Flutter application for daily wellness tracking with focus sessions, journaling, and profile management.

## 📋 Features

### Screens

#### 1. **Dashboard Screen**
- Greeting header with character avatar
- 2x2 grid layout for condition metrics:
  - Stress Level (24%)
  - Task Done (12)
  - Focus Time (103 min)
  - Rest Time (35 min)
- Large "Start Session" button for initiating focus sessions
- Journal section displaying recent entries with dates and descriptions

#### 2. **Timer/Focus Session Screen**
- Circular timer display with customizable durations (15m, 25m, 45m, 60m)
- Start/Pause and Reset controls
- Visual duration selector with active state indication
- Smooth animations and responsive layout

#### 3. **Profile Screen**
- Curved orange header with user avatar (Yukaa character)
- Personal information form with fields for:
  - Name
  - Date of Birth (with date picker)
  - Additional contact information fields
- Clean list-style layout with separators
- Save changes button

### Navigation
- Bottom navigation bar with 3 main sections:
  - Dashboard (home icon)
  - Timer/Focus (timer icon)
  - Profile (user icon)

## 🎨 Design System

### Color Palette
- **Primary Orange**: `#F16E24`
- **Primary Dark**: `#E05A0F`
- **Primary Light**: `#F69856`
- **Neutral Colors**: White, Black, Gray shades
- **Semantic Colors**: Success, Warning, Error, Info

### Typography
- Display Large: 32px, Bold
- Display Medium: 28px, Bold
- Headline Medium: 20px, Semi-Bold
- Title Large: 16px, Semi-Bold
- Body Large: 16px, Regular
- Body Medium: 14px, Regular

### Components
- **Cards**: 20px border radius, 2px elevation
- **Buttons**: 12px border radius, Full width options
- **Input Fields**: 12px border radius, Orange focus state
- **Lists**: Clean separators, proper spacing

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point & main navigation
├── constants/
│   ├── colors.dart          # Color definitions
│   └── theme.dart           # Theme configuration
└── screens/
    ├── dashboard_screen.dart # Dashboard & journal
    ├── timer_screen.dart     # Focus session timer
    └── profile_screen.dart   # User profile & settings
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK

### Installation

1. Navigate to project directory:
```bash
cd alp_depd
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Available Platforms
- Android
- iOS
- Web
- macOS
- Windows
- Linux

## 🔧 Configuration

### Theme Customization
Edit `lib/constants/theme.dart` to modify:
- Color scheme
- Typography styles
- Component styling (border radius, elevation, padding)

### Color Customization
Edit `lib/constants/colors.dart` to change:
- Primary brand color
- Neutral palette
- Semantic colors

## 📱 Responsive Design

The app uses Flutter's built-in responsive widgets:
- **SingleChildScrollView**: Handles overflow content
- **GridView**: Responsive 2-column grid for metrics
- **LayoutBuilder**: Adapts to different screen sizes
- **MediaQuery**: Responsive measurements

### Screen Sizes Supported
- Mobile (320px - 600px)
- Tablet (600px - 1000px)
- Desktop (1000px+)

## 🎯 Key Implementation Details

### Dashboard Grid Layout
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 1.0,
  ),
  ...
)
```

### Curved Header (Profile)
Uses custom `CustomClipper` with `quadraticBezierTo` for smooth curve effect.

### Bottom Navigation
Uses `IndexedStack` to maintain state while switching between screens.

## 📝 Future Enhancements

- [ ] Add character asset/images
- [ ] Implement actual timer with background notifications
- [ ] Add database for journal entries and user data
- [ ] Implement authentication
- [ ] Add statistics and analytics
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Push notifications

## 🐛 Known Issues

- Character images are placeholder-ready (add your SVG/PNG assets)
- Timer doesn't persist across app restarts
- Journal entries are hardcoded for demo

## 📄 License

This project is part of the DEPD course curriculum.

## 👨‍💻 Development Tips

1. **Hot Reload**: Press `r` while running to see changes instantly
2. **Hot Restart**: Press `R` to restart the app with full recompilation
3. **Debug Mode**: Use `flutter run -v` for verbose logging
4. **Device Selection**: Use `flutter devices` to list available targets

## 📚 References

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Dart Language](https://dart.dev/)
