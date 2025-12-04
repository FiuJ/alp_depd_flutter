# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Dependencies
```bash
cd alp_depd
flutter pub get
```

### Step 2: Choose Your Device
```bash
flutter devices
```

Select your target (Android emulator, iOS simulator, or physical device).

### Step 3: Run the App
```bash
flutter run
```

Or for a specific device:
```bash
flutter run -d <device_id>
```

### Step 4: Hot Reload While Developing
Press `r` to see changes instantly without restarting the app!

## 📱 App Navigation

The app has 3 main screens accessible via bottom navigation:

### Screen 1: Dashboard (Home Icon)
- Main landing page
- Shows daily wellness metrics
- Journal entries list
- Start session button

### Screen 2: Timer (Timer Icon)
- Pomodoro-style focus timer
- Customizable durations (15m, 25m, 45m, 60m)
- Start/Pause and Reset controls

### Screen 3: Profile (User Icon)
- User information editing
- Personal details form
- Name, date of birth, contact fields
- Save changes functionality

## 🎨 Visual Design Overview

### Color Scheme
- **Primary**: Orange (#F16E24)
- **Background**: Light gray (#FAFAFA)
- **Cards**: White with 20px rounded corners
- **Text**: Dark gray on light backgrounds

### Typography Hierarchy
- **Headings**: Large, bold, dark gray
- **Body Text**: Regular weight, medium gray
- **Labels**: Semi-bold, smaller than body

### Spacing Patterns
- **Padding**: 16-24px (horizontal), 12-32px (vertical)
- **Gaps**: 8-16px between elements
- **Card spacing**: 16px grid gap

## 💻 Code Structure at a Glance

```
lib/
├── main.dart                 ← Start here: App entry point
├── constants/
│   ├── colors.dart          ← Color palette
│   └── theme.dart           ← Theme configuration
└── screens/
    ├── dashboard_screen.dart ← Main dashboard
    ├── timer_screen.dart     ← Focus timer
    └── profile_screen.dart   ← User profile
```

## 🔄 Typical Development Workflow

### 1. **Modify Styling**
- Edit `lib/constants/colors.dart` or `lib/constants/theme.dart`
- Hot reload (press `r`)
- See changes instantly!

### 2. **Update a Screen**
- Edit the desired screen file in `lib/screens/`
- Hot reload
- Test on multiple devices

### 3. **Add a Feature**
- Create new widget in appropriate screen file
- Break it into helper methods (`_buildXxx()`)
- Use consistent styling from theme
- Test navigation

## 📊 Dashboard Features Explained

### Condition Grid
4 cards showing daily metrics:
- **Stress Level**: 24% - Indicates stress
- **Task Done**: 12 - Tasks completed this week
- **Focus Time**: 103 min - Total focus time
- **Rest Time**: 35 min - Total rest/break time

Each card displays:
- Icon representing the metric
- Large value in primary color
- Descriptive label below

### Journal Section
Shows recent journal entries with:
- Date created
- Entry title
- Preview of content (truncated)
- Interactive card (ready for detail view)

## ⏱️ Timer Features Explained

### Duration Selection
Swipe horizontally to pick session length:
- 15 minutes: Quick focus
- 25 minutes: Standard Pomodoro
- 45 minutes: Deep work
- 60 minutes: Extended session

### Timer Display
Large circular display showing:
- Remaining minutes and seconds
- Orange border with gradient background
- "Minutes" label below

### Controls
- **Start**: Begins countdown
- **Pause**: Pauses the timer
- **Reset**: Returns to initial duration

## 👤 Profile Features Explained

### Curved Header
- Orange background with smooth bottom curve
- White circular avatar with shadow
- User name ("Yukaa") centered below

### Personal Information Form
Editable fields for:
- Name
- Date of Birth (with date picker)
- Additional contact information

Each field has:
- Label above input
- Hint text (light gray placeholder)
- Orange focus state when editing
- Proper spacing and alignment

### Save Functionality
- "Save Changes" button at bottom
- Shows confirmation message on tap
- Ready for backend integration

## 🛠️ Common Customizations

### Change App Title
```dart
// in main.dart
MaterialApp(
  title: 'Your App Name',
  ...
)
```

### Change Primary Color
```dart
// in constants/colors.dart
static const Color primary = Color(0xFFYOURHEXCODE);
```

### Modify Journal Entries
```dart
// in dashboard_screen.dart
final journalItems = [
  {
    'date': 'Your Date',
    'title': 'Your Title',
    'description': 'Your Description',
  },
  // Add more...
];
```

### Add New Bottom Navigation Item
```dart
// in main.dart
bottomNavigationBar: BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    // Add new item here
  ],
)
```

## 🐛 Debugging Tips

### View Console Logs
```bash
flutter run -v  # Verbose mode shows all logs
```

### Check Widget Tree
Use Flutter DevTools:
```bash
flutter pub global activate devtools
devtools
```

### Common Issues & Fixes

**Issue**: "This widget does not repaint..."
- Use `setState()` to trigger rebuild
- Check if using `const` incorrectly

**Issue**: "Overflow errors on small screens"
- Wrap in `SingleChildScrollView`
- Check padding/margin values
- Use flexible widgets (Expanded, Flexible)

**Issue**: "Image not showing"
- Verify file path in `pubspec.yaml`
- Check file exists in `assets/` folder
- Run `flutter pub get`
- Check error handler fallback

## 📚 Learning Resources

### Flutter Docs
- [Flutter Widgets Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design Guide](https://material.io/design)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Key Concepts Used
- **Stateful vs Stateless Widgets**: When to use each
- **Build Context**: How Flutter builds the widget tree
- **State Management**: Using `setState()` for simple apps
- **Layout Widgets**: Column, Row, GridView, Stack
- **Custom Widgets**: ClipPath, CustomClipper for shapes

## ✅ Pre-Deploy Checklist

- [ ] All screens accessible via bottom navigation
- [ ] App runs on target platforms (Android/iOS/Web)
- [ ] No console errors
- [ ] Text readable on small screens
- [ ] Buttons and inputs responsive
- [ ] Images have fallback widgets
- [ ] All links/navigation functional
- [ ] Theme colors consistent
- [ ] App icon configured
- [ ] Splash screen configured (optional)

## 🎉 You're Ready to Go!

The app is production-ready with:
- ✅ Clean, modular code structure
- ✅ Responsive design
- ✅ Comprehensive theme system
- ✅ Error handling
- ✅ Material Design 3 compliance
- ✅ Full documentation

Start modifying and building upon this foundation!
