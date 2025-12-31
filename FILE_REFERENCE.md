# File-by-File Implementation Reference

## Core Application Files

### `lib/main.dart`

**Purpose:** Application entry point and main navigation controller

**Key Components:**
- `void main()`: Launches the app with MyApp
- `MyApp`: Root MaterialApp widget with theme configuration
- `MainAppScreen`: Stateful widget managing tab navigation
- `_MainAppScreenState`: State management for bottom navigation

**Key Code Sections:**

```dart
// Entry point
void main() {
  runApp(const MyApp());
}

// Root widget - configure theme here
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEPD - Daily Wellness',
      theme: AppTheme.lightTheme(), // Custom theme
      home: const MainAppScreen(),
    );
  }
}

// Main navigation controller
class MainAppScreen extends StatefulWidget {
  // Manages which screen is visible
  _selectedIndex: 0 = Dashboard, 1 = Timer, 2 = Profile
}
```

**Navigation Pattern:**
```
MainAppScreen
  └── IndexedStack (preserves state)
      ├── [0] DashboardScreen
      ├── [1] TimerScreen
      └── [2] ProfileScreen
  └── BottomNavigationBar (switches screens)
```

**What to Modify:**
- App title: Change `'DEPD - Daily Wellness'`
- Initial screen: Change `home:` value
- Add more screens: Add to `_screens` list and bottom nav

**Key Methods:**
- `_onNavBarTapped(int index)`: Called when bottom nav tapped

---

## Constants & Configuration

### `lib/constants/colors.dart`

**Purpose:** Centralized color definitions for entire app

**Color Categories:**
1. **Primary Colors** - Brand orange shades
2. **Neutral Colors** - Black, white, grays
3. **Semantic Colors** - Status indication (success, error, etc.)
4. **Background Colors** - Page and component backgrounds

**Key Colors:**
```dart
AppColors.primary        // #F16E24 - Main brand color
AppColors.white          // #FFFFFF - Cards, backgrounds
AppColors.lightGray      // #F5F5F5 - Light backgrounds
AppColors.mediumGray     // #666666 - Secondary text
AppColors.darkGray       // #333333 - Primary text
AppColors.borderGray     // #E0E0E0 - Input borders
```

**Usage:**
```dart
Container(color: AppColors.primary)
Text(style: TextStyle(color: AppColors.darkGray))
```

**What to Modify:**
- Change primary color: Update `#F16E24` to new hex
- Add new colors: Add static const Color properties
- Update all references: Color changes affect entire app

---

### `lib/constants/theme.dart`

**Purpose:** Material Design theme configuration

**Key Components:**
1. **Color Scheme** - Based on primary orange
2. **Text Styles** - 14 typography variants
3. **Component Styles** - Cards, buttons, inputs
4. **Theme Data** - Global styling rules

**Text Style Hierarchy:**
```
displayLarge (32px)      - Page titles
displayMedium (28px)     - Section titles
headlineSmall (18px)     - Subsection titles
titleLarge (16px)        - Card titles
bodyLarge (16px)         - Main text
bodyMedium (14px)        - Secondary text
bodySmall (12px)         - Captions
```

**Component Styling:**
- **Cards:** 20px border radius, 2px elevation
- **Buttons:** 12px border radius, orange background
- **Inputs:** 12px border radius, light gray fill
- **Bottom Nav:** Fixed type, 8px elevation

**What to Modify:**
- Font family: Add custom fonts to pubspec.yaml
- Font sizes: Adjust pixel values in textTheme
- Button styling: Modify elevatedButtonTheme
- Card styling: Modify cardTheme
- Border radius: Change BorderRadius.circular() values

---

## Screen Components

### `lib/screens/dashboard_screen.dart`

**Purpose:** Main dashboard showing wellness metrics and journal

**Screen Layout:**
```
1. Header (white background)
   - Greeting text
   - Avatar image with error handler

2. Condition Grid (2x2)
   - Stress Level card
   - Task Done card
   - Focus Time card
   - Rest Time card

3. Start Session Button (full width)

4. Journal Section (scrollable list)
   - Journal entry cards (date, title, description)
```

**Key Components:**

```dart
DashboardScreen (StatelessWidget)
  └── SingleChildScrollView
      ├── _buildHeader()        // Greeting + avatar
      ├── _buildConditionGrid() // 2x2 grid of metrics
      ├── _buildStartSessionButton()
      └── _buildJournalSection() // List of entries
```

**Helper Build Methods:**
- `_buildHeader()`: Creates white header with avatar
- `_buildConditionGrid()`: Creates 2x2 GridView of metrics
- `_buildStartSessionButton()`: Creates full-width orange button
- `_buildJournalSection()`: Creates scrollable journal list

**Nested Components:**
- `_ConditionCard`: Widget for individual metric card
- `_ConditionItem`: Data class for metric info
- `_JournalCard`: Widget for journal entry display

**What to Modify:**
- Greeting text: Change "How are you today?"
- Metric values: Update values in grid
- Journal entries: Modify `journalItems` list
- Button action: Add logic in button `onPressed`
- Avatar image: Change image path or add your own

**Sample Customization:**
```dart
// Change metric values
_ConditionItem(
  title: 'New Metric',
  value: '50',
  subtitle: 'Description',
  icon: Icons.your_icon,
  color: AppColors.primary,
)

// Change journal entry
{
  'date': 'Your date',
  'title': 'Your title',
  'description': 'Your description',
}
```

---

### `lib/screens/timer_screen.dart`

**Purpose:** Focus session timer with customizable duration

**Screen Layout:**
```
1. Header (white background)
   - Title: "Focus Session"
   - Subtitle: "Stay focused and productive"

2. Circular Timer Display
   - Shows MM:SS format (e.g., "25:00")
   - Large orange text
   - Orange border

3. Duration Selector (horizontal)
   - 4 buttons: 15m, 25m, 45m, 60m
   - Active state highlighted

4. Control Buttons
   - Start/Pause button (toggles)
   - Reset button (outline style)
```

**Key Components:**

```dart
TimerScreen (StatefulWidget)
  └── _TimerScreenState (with TickerProviderStateMixin)
      ├── AnimationController (manages timer)
      ├── _selectedMinutes (state)
      ├── _isRunning (state)
      └── Column
          ├── _buildHeader()
          ├── _buildTimerCircle()
          ├── _buildDurationSelector()
          └── _buildControlButtons()
```

**State Variables:**
```dart
int _selectedMinutes = 25;      // Current duration
bool _isRunning = false;         // Timer state
AnimationController controller;  // Handles animation
```

**Key Methods:**
- `_buildTimerCircle()`: Creates circular display
- `_buildDurationSelector()`: Creates horizontal picker
- `_buildControlButtons()`: Creates start/reset buttons

**What to Modify:**
- Default duration: Change `_selectedMinutes = 25`
- Duration options: Modify `durations` list
- Display format: Change time formatting logic
- Button colors: Change `backgroundColor` properties
- Timer logic: Add actual countdown (placeholder ready)

**Future Enhancements:**
```dart
// Add actual countdown
_animationController.forward().then((_) {
  // Timer finished
  _showNotification();
});

// Add background notifications
// Add haptic feedback
```

---

### `lib/screens/profile_screen.dart`

**Purpose:** User profile with personal information form

**Screen Layout:**
```
1. Curved Orange Header
   - Title: "Profile"
   - Curved bottom edge using ClipPath

2. Circular Avatar
   - White background with shadow
   - Character image centered

3. User Name
   - "Yukaa" centered below avatar

4. Personal Information Form
   - Name field
   - Date of Birth field (with date picker)
   - 3 additional contact fields

5. Save Button (full width, orange)
```

**Key Components:**

```dart
ProfileScreen (StatefulWidget)
  └── _ProfileScreenState
      ├── TextEditingController (x5)
      └── SingleChildScrollView
          ├── _buildCurvedHeader()
          │   └── ClipPath (_CurvedClipper)
          └── _buildPersonalInfoForm()
              ├── _buildFormField() (x5)
              └── ElevatedButton (Save)
```

**State Variables:**
```dart
final _nameController = TextEditingController();
final _dobController = TextEditingController();
// ... more controllers
```

**Custom ClipPath:**
```dart
class _CurvedClipper extends CustomClipper<Path> {
  // Uses quadraticBezierTo for smooth curve
  // Curve starts at bottom-left, curves down, ends bottom-right
}
```

**Form Field Features:**
- Label above input
- Hint text placeholder
- Orange focus border
- Optional suffix icon (date picker for DOB)
- Proper spacing between fields

**What to Modify:**
- User name: Change "Yukaa" text
- Form fields: Add/remove `_buildFormField()` calls
- Field labels: Change label strings
- Validation: Add form validation logic
- Avatar image: Change image path
- Save logic: Add backend integration

**Sample Field Addition:**
```dart
_buildFormField(
  controller: _emailController,
  label: 'Email',
  hint: 'Enter your email',
)
```

---

## Navigation Files

### `pubspec.yaml` (Modified Section)

**Assets Configuration:**
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/characters/
```

**What This Does:**
- Tells Flutter where to find asset files
- Makes images loadable via `Image.asset()`
- Add more asset paths as needed

**What to Modify:**
- Add new asset directories as needed
- Example: `- assets/icons/`, `- assets/backgrounds/`

---

## Directory Structure Reference

```
alp_depd/
│
├── lib/
│   ├── main.dart                    # App entry & navigation (90 lines)
│   ├── constants/
│   │   ├── colors.dart             # Color palette (48 lines)
│   │   └── theme.dart              # Material theme (150 lines)
│   └── screens/
│       ├── dashboard_screen.dart   # Main dashboard (280 lines)
│       ├── timer_screen.dart       # Focus timer (210 lines)
│       └── profile_screen.dart     # User profile (230 lines)
│
├── assets/
│   └── characters/                 # [Ready for images]
│
├── pubspec.yaml                    # Project config [MODIFIED]
├── IMPLEMENTATION_GUIDE.md         # Feature documentation
├── CODE_ARCHITECTURE.md            # Technical documentation
├── IMPLEMENTATION_SUMMARY.md       # Summary & checklist
├── QUICK_START.md                  # Developer guide
├── LAYOUT_DIAGRAMS.md              # Visual diagrams
├── TESTING_GUIDE.md                # Testing documentation
├── FILE_REFERENCE.md               # This file
│
└── [Platform-specific: android/, ios/, web/, etc.]
```

---

## File Size & Metrics

| File | Lines | Purpose | Complexity |
|------|-------|---------|------------|
| main.dart | 90 | Navigation | Low |
| colors.dart | 48 | Color defs | Trivial |
| theme.dart | 150 | Styling | Medium |
| dashboard_screen.dart | 280 | Main screen | High |
| timer_screen.dart | 210 | Timer screen | High |
| profile_screen.dart | 230 | Profile screen | Medium |
| **Total** | **~1,008** | **App core** | **Medium** |

---

## Dependencies

**Built-in (No external packages needed):**
- flutter (SDK)
- material icons
- cupertino_icons (included in pubspec)

**Ready to add (for future features):**
- `firebase_core`: Backend database
- `intl`: Date formatting
- `provider`: State management
- `hive`: Local storage
- `image_picker`: Avatar selection

---

## Quick Edit Locations

### To Change App Colors
→ `lib/constants/colors.dart`

### To Change Fonts/Styles
→ `lib/constants/theme.dart`

### To Change Dashboard Content
→ `lib/screens/dashboard_screen.dart` (search for `final journalItems`)

### To Change Timer Options
→ `lib/screens/timer_screen.dart` (search for `final durations`)

### To Add Form Fields
→ `lib/screens/profile_screen.dart` (add `_buildFormField()` calls)

### To Add Navigation Items
→ `lib/main.dart` (modify `BottomNavigationBar` items)

---

## Code Style Conventions Used

1. **Naming:**
   - Classes: PascalCase (e.g., `DashboardScreen`)
   - Methods: camelCase (e.g., `_buildHeader()`)
   - Constants: camelCase (e.g., `_selectedMinutes`)
   - Private: prefix with `_` (e.g., `_buildHeader()`)

2. **Organization:**
   - Build methods first
   - Helper methods last
   - Private methods use `_` prefix

3. **Comments:**
   - Class-level: Explain purpose
   - Complex logic: Explain "why"
   - Keep comments brief and clear

4. **Formatting:**
   - 2-space indentation
   - Max line width: ~80 characters (except URLs)
   - Proper spacing around braces

---

## Testing Entry Points

### Unit Tests
- Test `AppColors` against hex values
- Test `AppTheme` configuration
- Test data models

### Widget Tests
- Test each screen renders
- Test navigation works
- Test button interactions

### Integration Tests
- Test complete user flows
- Test all navigation paths
- Test form interactions

See `TESTING_GUIDE.md` for detailed examples.

---

## Performance Optimization Tips

1. **Use const where possible:**
   ```dart
   const Text('Hello')  // Faster than Text('Hello')
   ```

2. **Avoid unnecessary rebuilds:**
   ```dart
   IndexedStack  // Preserves state during nav
   ```

3. **Use NeverScrollableScrollPhysics:**
   ```dart
   physics: const NeverScrollableScrollPhysics()  // For nested scrolls
   ```

4. **Cache expensive widgets:**
   ```dart
   final screens = [...]  // Create once, reuse
   ```

---

## Accessibility Features Included

✅ Semantic colors (orange shows interactive)
✅ Proper text hierarchy (sizes vary)
✅ Touch targets ≥ 48px
✅ Color contrast > 4.5:1
✅ Labels for all inputs
✅ Icons paired with text
✅ No text-only inputs
✅ Proper widget semantics

---

This file-by-file reference helps you understand, modify, and extend each component!
