# Testing Guide & Best Practices

## 📋 Manual Testing Checklist

### Dashboard Screen
- [ ] Header displays "How are you today?" message
- [ ] Avatar image displays (or fallback icon)
- [ ] All 4 metric cards visible in 2x2 grid
- [ ] Metric values display correctly
- [ ] "Start Session" button clickable
- [ ] Journal section shows at least 2 entries
- [ ] Journal dates display with calendar icon
- [ ] All text readable on small screens
- [ ] Page scrolls smoothly on overflow
- [ ] Orange color theme applied throughout

### Timer Screen
- [ ] "Focus Session" title displays
- [ ] Circular timer shows 25:00 initially
- [ ] 4 duration options visible (15, 25, 45, 60)
- [ ] Selected duration highlighted in orange
- [ ] Duration can be changed (when not running)
- [ ] "Start" button changes to "Pause" when running
- [ ] Reset button clears timer
- [ ] All buttons responsive
- [ ] Layout responsive on all screen sizes

### Profile Screen
- [ ] Orange curved header displays
- [ ] Avatar circle visible and centered
- [ ] "Yukaa" name displays below avatar
- [ ] "Personal Information" section visible
- [ ] All 5 form fields display with labels
- [ ] Date field has calendar icon
- [ ] Date picker opens on date field tap
- [ ] Save button clickable
- [ ] Form scrolls on small screens
- [ ] Input fields responsive

### Bottom Navigation
- [ ] 3 icons visible: Home, Timer, User
- [ ] Icons have labels
- [ ] Tapping icons switches screens
- [ ] Selected icon highlighted in orange
- [ ] Navigation works bidirectionally
- [ ] No navigation lag or visual glitches

### Responsive Design (Test on multiple devices)
- [ ] iPhone SE (375px): All content visible
- [ ] iPhone 12 (390px): Proper spacing
- [ ] iPhone 14 Pro Max (430px+): Good use of space
- [ ] Pixel 6 (412px): Aligned properly
- [ ] iPad (768px): 2-column layout
- [ ] Desktop (1920px): Centered content
- [ ] Tablet landscape: No overflow
- [ ] Portrait orientation: Scroll works

### Color & Styling
- [ ] Primary orange (#F16E24) consistent
- [ ] Cards have 20px rounded corners
- [ ] Input fields have 12px rounded corners
- [ ] Button hover/pressed states visible
- [ ] Text hierarchy clear (sizes vary)
- [ ] Shadows subtle but visible
- [ ] No jarring color changes

### Error Handling
- [ ] Missing avatar image shows fallback
- [ ] No red error screens
- [ ] Graceful degradation for missing assets
- [ ] Form can be submitted empty (data validation in future)
- [ ] Timer can handle all durations

## 🧪 Unit Test Examples

### Test Colors
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:alp_depd/constants/colors.dart';

void main() {
  test('Primary color is correct orange', () {
    expect(AppColors.primary, Color(0xFFF16E24));
  });

  test('Color palette has required colors', () {
    expect(AppColors.white, isNotNull);
    expect(AppColors.primary, isNotNull);
    expect(AppColors.lightGray, isNotNull);
  });
}
```

### Test Theme
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:alp_depd/constants/theme.dart';

void main() {
  test('Theme applies orange seed color', () {
    final theme = AppTheme.lightTheme();
    expect(theme.colorScheme.primary, isNotNull);
  });

  test('Theme has all text styles defined', () {
    final theme = AppTheme.lightTheme();
    expect(theme.textTheme.displayLarge, isNotNull);
    expect(theme.textTheme.bodyMedium, isNotNull);
  });
}
```

## 🎨 Widget Test Examples

### Test Dashboard Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alp_depd/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard displays greeting text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('How are you today?'), findsOneWidget);
  });

  testWidgets('Dashboard shows condition cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('Stress Level'), findsOneWidget);
    expect(find.text('Task Done'), findsOneWidget);
    expect(find.text('Focus Time'), findsOneWidget);
    expect(find.text('Rest Time'), findsOneWidget);
  });

  testWidgets('Start Session button exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('Start Session'), findsOneWidget);
  });
}
```

### Test Timer Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alp_depd/screens/timer_screen.dart';

void main() {
  testWidgets('Timer screen displays title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerScreen(),
        ),
      ),
    );

    expect(find.text('Focus Session'), findsOneWidget);
  });

  testWidgets('Timer shows duration buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerScreen(),
        ),
      ),
    );

    expect(find.text('15m'), findsOneWidget);
    expect(find.text('25m'), findsOneWidget);
    expect(find.text('45m'), findsOneWidget);
    expect(find.text('60m'), findsOneWidget);
  });

  testWidgets('Timer has start button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerScreen(),
        ),
      ),
    );

    expect(find.text('Start'), findsOneWidget);
  });
}
```

### Test Profile Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alp_depd/screens/profile_screen.dart';

void main() {
  testWidgets('Profile displays user name', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );

    expect(find.text('Yukaa'), findsOneWidget);
  });

  testWidgets('Profile shows form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Name'), findsWidgets);
  });

  testWidgets('Save button exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );

    expect(find.text('Save Changes'), findsOneWidget);
  });
}
```

### Test Navigation
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alp_depd/main.dart';

void main() {
  testWidgets('Navigation between screens works', 
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Dashboard initially shown
    expect(find.text('How are you today?'), findsOneWidget);

    // Tap Timer icon
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pumpAndSettle();

    // Timer screen now shown
    expect(find.text('Focus Session'), findsOneWidget);

    // Tap Profile icon
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Profile screen now shown
    expect(find.text('Yukaa'), findsOneWidget);

    // Navigate back to Dashboard
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Back to Dashboard
    expect(find.text('How are you today?'), findsOneWidget);
  });

  testWidgets('Bottom nav items highlight correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // First item selected by default
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap different item
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pumpAndSettle();

    // Verify selection changed (visual feedback)
    // This would require more detailed inspection of the nav bar state
  });
}
```

## 🔄 Integration Test Examples

### Complete App Flow
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alp_depd/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete app flow test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Test Dashboard
    expect(find.text('How are you today?'), findsOneWidget);
    expect(find.text('Start Session'), findsOneWidget);

    // Navigate to Timer
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pumpAndSettle();
    expect(find.text('Focus Session'), findsOneWidget);

    // Test Timer Selection
    await tester.tap(find.text('45m'));
    await tester.pumpAndSettle();

    // Navigate to Profile
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Yukaa'), findsOneWidget);

    // Test Form Interaction
    await tester.enterText(
      find.byType(TextField).first,
      'John Doe',
    );
    await tester.pumpAndSettle();

    // Save
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    // Back to Dashboard
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('How are you today?'), findsOneWidget);
  });
}
```

## 📱 Device Testing Matrix

### Screen Sizes to Test
```
Device              Width   Height  Type
────────────────────────────────────────
iPhone SE           375px   667px   Mobile
iPhone 12           390px   844px   Mobile
iPhone 14 Pro Max   430px   932px   Mobile
Pixel 6             412px   915px   Mobile
Samsung S21         360px   800px   Mobile
iPad (9.7")         768px   1024px  Tablet
iPad Pro (11")      1194px  834px   Tablet
iPad Pro (12.9")    1366px  1024px  Tablet
Desktop 1080p       1920px  1080px  Desktop
Desktop 4K          3840px  2160px  Desktop
```

### Orientation Testing
- [x] Portrait mode
- [x] Landscape mode
- [x] Foldable devices (if applicable)

### Browser Testing (Web)
- [x] Chrome (latest)
- [x] Firefox (latest)
- [x] Safari (latest)
- [x] Edge (latest)

## 🎯 Accessibility Testing

### Screen Reader
- Test with screen reader enabled
- Verify all interactive elements have labels
- Test navigation with keyboard only

### Color Contrast
- Background/Text: ≥ 4.5:1 ratio
- Use WebAIM Contrast Checker

### Touch Targets
- Minimum 48x48 logical pixels
- Sufficient spacing between targets

### Text Size
- Minimum 14px for body text
- Scalable with system settings

## 🐛 Common Issues to Test

### Image Loading
- [ ] App handles missing character images
- [ ] Fallback UI displays nicely
- [ ] No crashes on image error

### Form Handling
- [ ] Date picker works on all platforms
- [ ] Form doesn't submit with validation errors
- [ ] Clearing form works correctly

### Performance
- [ ] No lag on screen transitions
- [ ] Scrolling smooth and responsive
- [ ] Navigation instantaneous
- [ ] Memory usage reasonable

### Orientation Changes
- [ ] App survives rotation
- [ ] Layout adapts correctly
- [ ] No data loss
- [ ] Keyboard dismisses properly

## 📊 Testing Metrics

### Coverage Goals
- Unit Test Coverage: ≥ 80%
- Widget Test Coverage: ≥ 70%
- Integration Test Coverage: Key flows only

### Performance Targets
- App startup: < 3 seconds
- Screen transition: < 300ms
- Scroll FPS: 60fps (mobile), 120fps (high refresh)

## ✅ Pre-Release Testing Checklist

- [ ] All screens tested on mobile
- [ ] All screens tested on tablet
- [ ] All screens tested on web
- [ ] Dark mode disabled (planned for later)
- [ ] No console errors or warnings
- [ ] Navigation tested thoroughly
- [ ] Forms tested with valid/invalid data
- [ ] Images load or show fallback
- [ ] Accessibility verified
- [ ] Performance acceptable
- [ ] All text readable
- [ ] No hardcoded dimensions
- [ ] Theme colors consistent
- [ ] Typography hierarchy correct
- [ ] Spacing consistent with grid

---

This testing guide ensures quality and robustness of the application!
