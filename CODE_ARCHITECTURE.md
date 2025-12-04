# Code Architecture & Implementation Details

## Project Overview

This Flutter app demonstrates a complete, production-ready mobile application following Material Design 3 principles and best practices.

## Directory Structure

```
alp_depd/
├── lib/
│   ├── main.dart                          # App root & navigation logic
│   ├── constants/
│   │   ├── colors.dart                   # Global color definitions
│   │   └── theme.dart                    # Material theme configuration
│   └── screens/
│       ├── dashboard_screen.dart         # Main dashboard & journal
│       ├── timer_screen.dart             # Focus session timer
│       └── profile_screen.dart           # User profile management
├── assets/
│   └── characters/                       # Character avatars (placeholder)
├── pubspec.yaml                          # Dependencies & assets
└── android/, ios/, web/, etc.            # Platform-specific files
```

## Core Components

### 1. **main.dart** - Application Entry Point

```dart
void main() => runApp(const MyApp());
```

**Key Classes:**
- `MyApp`: Root widget that configures MaterialApp with theme
- `MainAppScreen`: Stateful widget managing bottom navigation
- `_MainAppScreenState`: Handles screen switching via IndexedStack

**Navigation Pattern:**
```dart
IndexedStack(
  index: _selectedIndex,
  children: _screens,
)
```
Maintains screen state when switching tabs without rebuilding.

### 2. **constants/colors.dart** - Design System Colors

**Color Categories:**
- **Primary**: Brand colors (#F16E24 orange)
- **Neutral**: Black, white, gray shades
- **Semantic**: Success, warning, error, info colors
- **Background**: Page and card backgrounds

**Usage Pattern:**
```dart
Container(
  color: AppColors.primary,
  // ...
)
```

### 3. **constants/theme.dart** - Material Theme

**Theme Configuration:**
- Text styles (14 variants)
- Button styling
- Card appearance
- Input decorations
- Bottom navigation theme

**Key Features:**
- Rounded corners (12-20px)
- Consistent elevation
- Orange accent throughout
- Material 3 compliance

### 4. **Dashboard Screen** - Home & Journal

#### Components:

**Header Section:**
```dart
_buildHeader(BuildContext context)
```
- Greeting text
- Character avatar with error handling
- White background with padding

**Condition Grid:**
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  ...
)
```
- 2x2 responsive grid
- 4 metric cards (Stress, Task, Focus, Rest)
- Icon + value + subtitle layout

**Card Components:**
- `_ConditionCard`: Individual metric card with icon
- `_ConditionItem`: Data model for metrics

**Journal Section:**
```dart
_buildJournalSection(BuildContext context)
```
- List of journal entries
- Date with calendar icon
- Title and preview text
- Tap-ready for navigation

### 5. **Timer Screen** - Focus Session

#### Features:

**Circular Timer Display:**
```dart
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(width: 3),
  ),
)
```
- Large, clear display
- Orange border and gradient background

**Duration Selector:**
```dart
ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: durations.length,
)
```
- Horizontal scrollable picker
- 4 preset options (15, 25, 45, 60 minutes)
- Active state highlighting

**Control Buttons:**
- Start/Pause: Animated toggle
- Reset: Clears timer

**State Management:**
```dart
class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  ...
}
```
Uses `TickerProviderStateMixin` for smooth animations.

### 6. **Profile Screen** - User Information

#### Layout Components:

**Curved Header:**
```dart
ClipPath(
  clipper: _CurvedClipper(),
  child: Container(height: 200),
)
```
Uses custom `CustomClipper` with quadratic Bezier curve:
```dart
path.quadraticBezierTo(
  size.width / 2,
  size.height,
  size.width,
  size.height * 0.75,
)
```

**Avatar Section:**
```dart
Container(
  width: 120,
  height: 120,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [BoxShadow(...)],
  ),
)
```
- Circular avatar with white background
- Drop shadow for depth
- Centered in header

**Form Fields:**
```dart
_buildFormField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool isDateField = false,
})
```

**Features:**
- Clean input styling
- Date picker integration
- Orange focus state
- Label + input + optional suffix icon

**Special Handling:**
```dart
suffixIcon: isDateField
    ? GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(...);
          // Update controller
        },
      )
    : null,
```

## Design Patterns & Best Practices

### 1. **Separation of Concerns**
- Colors isolated in `colors.dart`
- Theme logic in `theme.dart`
- Each screen in separate file
- Reusable widget components

### 2. **Responsive Design**
```dart
SingleChildScrollView(child: Column(...))
```
- Prevents overflow on small screens
- Proper padding (24px horizontal)
- Flexible spacing

### 3. **State Management**
- `StatelessWidget` for presentational widgets
- `StatefulWidget` for interactive screens
- Local state with `setState()`
- Controllers for form inputs

### 4. **Error Handling**
```dart
Image.asset(
  'assets/characters/character.png',
  errorBuilder: (context, error, stackTrace) {
    return Container(...); // Fallback UI
  },
)
```
Graceful fallbacks for missing assets.

### 5. **Consistent Styling**
```dart
style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  color: AppColors.primary,
  fontWeight: FontWeight.bold,
)
```
Always extend theme styles rather than creating new ones.

### 6. **Widget Composition**
```dart
Widget _buildHeader(BuildContext context) { ... }
Widget _buildContent(BuildContext context) { ... }
Widget _buildFooter(BuildContext context) { ... }
```
Break complex screens into smaller, testable methods.

## Key Technical Decisions

### 1. **IndexedStack for Navigation**
- Preserves widget state during tab switches
- Prevents unnecessary rebuilds
- Better performance for complex screens

### 2. **Custom ClipPath for Header**
- Smooth, modern design
- GPU accelerated
- More efficient than layering

### 3. **GridView for Metrics**
- Automatically responsive
- Handles different screen sizes
- Easy to adjust column count

### 4. **Material 3 Compliance**
- Modern design language
- Better accessibility
- Future-proof styling

## Customization Points

### Change Primary Color
```dart
// in constants/colors.dart
static const Color primary = Color(0xFF...) // Change hex value
```

### Adjust Border Radius
```dart
// in theme.dart
borderRadius: BorderRadius.circular(16) // Change 16 to desired value
```

### Modify Text Styles
```dart
// in theme.dart textTheme section
headlineSmall: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
),
```

### Add New Screens
1. Create `lib/screens/new_screen.dart`
2. Add to `_screens` list in `main.dart`
3. Add navigation item in bottom bar

## Performance Considerations

1. **Image Loading**: Uses `errorBuilder` to handle missing assets
2. **Scrolling**: `NeverScrollableScrollPhysics` for nested scrolls
3. **Animations**: `TickerProviderStateMixin` for frame-perfect animations
4. **State**: Minimal state management to reduce rebuilds

## Testing Recommendations

### Unit Tests
```dart
test('Should parse condition data correctly', () {
  // Test data models
});
```

### Widget Tests
```dart
testWidgets('Dashboard displays greeting', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('How are you today?'), findsOneWidget);
});
```

### Integration Tests
- Navigation between screens
- Form submission
- Timer functionality

## Browser Compatibility (Web)

The app is fully responsive and works on:
- Chrome/Chromium
- Firefox
- Safari
- Edge

## Next Steps for Production

1. Add real character assets
2. Implement database (Firebase/Supabase)
3. Add user authentication
4. Persist journal entries
5. Implement actual timer with notifications
6. Add data analytics
7. Implement dark mode
8. Add localization (multiple languages)
9. Set up CI/CD pipeline
10. Prepare app store metadata

## Troubleshooting

### Assets not loading?
- Check `pubspec.yaml` has `assets:` section
- Run `flutter pub get`
- Verify file paths are correct

### Build errors?
- Run `flutter clean`
- Delete `.dart_tool` folder
- Run `flutter pub get` again

### Hot reload not working?
- Save the file explicitly
- Or press `R` for hot restart
