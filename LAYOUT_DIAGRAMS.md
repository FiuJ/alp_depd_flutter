# UI Layout Diagrams & Component Breakdown

## Dashboard Screen Layout

```
┌──────────────────────────────────────┐
│          Header Section              │ <- SingleChildScrollView
│  "How are you today?"                │
│      [Avatar Image]                  │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   "Your Condition Result"            │
├──────────────┬──────────────┐        │
│   [Card 1]   │   [Card 2]   │        │ <- 2x2 GridView
│   Stress     │   Task Done  │        │
│    24%       │      12      │        │
├──────────────┼──────────────┤        │
│   [Card 3]   │   [Card 4]   │        │
│  Focus Time  │  Rest Time   │        │
│   103min     │    35min     │        │
└──────────────┴──────────────┘        │

┌──────────────────────────────────────┐
│    [Start Session Button]            │ <- Full width button
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│       "Your Journal"                 │
├──────────────────────────────────────┤
│  📅 12 November 2025                 │
│  My day looks nice                   │ <- Journal Card 1
│  It is a long established fact...    │
├──────────────────────────────────────┤
│  📅 11 November 2025                 │
│  Feeling great today                 │ <- Journal Card 2
│  Had a productive day with lots...   │
└──────────────────────────────────────┘
```

### Component Hierarchy
```
DashboardScreen (StatelessWidget)
├── SingleChildScrollView
│   └── Column
│       ├── _buildHeader()
│       │   └── White Container
│       │       ├── Text("How are you today?")
│       │       └── Image.asset() [with errorBuilder]
│       ├── _buildConditionGrid()
│       │   └── Container
│       │       ├── Text("Your Condition Result")
│       │       └── GridView.builder()
│       │           └── _ConditionCard (x4)
│       │               ├── Icon
│       │               ├── Text(value)
│       │               └── Text(subtitle)
│       ├── _buildStartSessionButton()
│       │   └── ElevatedButton
│       └── _buildJournalSection()
│           └── ListView.builder()
│               └── _JournalCard (x2)
│                   ├── Row[Icon + Date]
│                   ├── Text(title)
│                   └── Text(description)
└── BottomNavigationBar
```

## Timer Screen Layout

```
┌──────────────────────────────────────┐
│        "Focus Session"               │
│  Stay focused and productive         │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│                                      │
│         ╭─────────────╮              │
│         │   25:00     │              │ <- Circular timer
│         │   Minutes   │              │
│         ╰─────────────╯              │
│                                      │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  [15m]  [25m]  [45m]  [60m]         │ <- Duration selector
│           ▲ Selected                 │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  ┌──────────┐      ┌──────────┐     │
│  │  Start   │      │  Reset   │     │ <- Control buttons
│  └──────────┘      └──────────┘     │
└──────────────────────────────────────┘
```

### Component Hierarchy
```
TimerScreen (StatefulWidget)
└── _TimerScreenState (with TickerProviderStateMixin)
    ├── AnimationController
    └── Column
        ├── Container [Header]
        │   ├── Text("Focus Session")
        │   └── Text("Stay focused...")
        ├── Expanded
        │   └── Column
        │       ├── _buildTimerCircle()
        │       │   └── Container
        │       │       └── Column
        │       │           ├── Text(duration)
        │       │           └── Text("Minutes")
        │       ├── _buildDurationSelector()
        │       │   └── ListView.builder()
        │       │       └── GestureDetector
        │       │           └── Duration button (x4)
        │       └── _buildControlButtons()
        │           └── Row
        │               ├── ElevatedButton(Start/Pause)
        │               └── OutlinedButton(Reset)
        └── BottomNavigationBar
```

## Profile Screen Layout

```
┌──────────────────────────────────────┐
│        [Orange Curved Header]        │
│            Curves down               │
│          [Avatar Circle]             │
│            Yukaa                     │
└───────────────────┬──────────────────┘
                    │ Curves down here

┌──────────────────────────────────────┐
│  Personal Information                │
│                                      │
│  Name                                │
│  ┌──────────────────────────────────┐│
│  │ Enter your full name             ││
│  └──────────────────────────────────┘│
│                                      │
│  Date of Birth                       │
│  ┌──────────────────────────────────┐│
│  │ Select your date of birth    📅   ││
│  └──────────────────────────────────┘│
│                                      │
│  Name                                │
│  ┌──────────────────────────────────┐│
│  │ Enter information                 ││
│  └──────────────────────────────────┘│
│                                      │
│  Name                                │
│  ┌──────────────────────────────────┐│
│  │ Enter information                 ││
│  └──────────────────────────────────┘│
│                                      │
│  Name                                │
│  ┌──────────────────────────────────┐│
│  │ Enter information                 ││
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│
│  │     Save Changes                  ││
│  └──────────────────────────────────┘│
└──────────────────────────────────────┘
```

### Component Hierarchy
```
ProfileScreen (StatefulWidget)
└── _ProfileScreenState
    ├── TextEditingController (x5)
    └── SingleChildScrollView
        └── Column
            ├── _buildCurvedHeader()
            │   └── Stack
            │       ├── ClipPath(_CurvedClipper)
            │       │   └── Container [Orange]
            │       └── Padding
            │           └── Column
            │               ├── Text("Profile")
            │               ├── Container [Avatar Circle]
            │               │   └── Image.asset()
            │               └── Text("Yukaa")
            └── _buildPersonalInfoForm()
                └── Column
                    ├── Text("Personal Information")
                    ├── _buildFormField() [Name]
                    ├── _buildFormField() [DOB]
                    ├── _buildFormField() [Contact 1-3]
                    └── ElevatedButton(Save)
        └── BottomNavigationBar
```

## Curved Clipper Implementation

```
┌─────────────────────────────────────┐
│        Start Top (0, 0)              │
└─────────────────────────────────────┘

Line from (0, 0) to top-left corner


    Starting point for curve
         ↓
    ╔═══════╗
    ║ Quad  ║  Quadratic Bezier
    ║ Curve ║  From (0, y75%)
    ║ Down  ║  Control: (width/2, height)
    ║       ║  End: (width, y75%)
    ╚═══════╝
         ↑
    Smooth curve

┌─────────────────────────────────────┐
│     Curve ends at (width, y75%)      │
│  (Rest of container below this line) │
└─────────────────────────────────────┘

Path draws:
1. Line from (0,0) to (0, 75% height)
2. Quadratic Bezier to create smooth curve
3. Line down right side to (width, 75%)
4. Line back to (width, 0)
5. Line back to (0, 0) - close path
```

## Color Application Map

```
┌─ Primary Color Locations ───────────┐
│                                    │
│  🟠 Avatar background             │
│  🟠 Metric card values             │
│  🟠 Button backgrounds             │
│  🟠 Timer border                   │
│  🟠 Timer display text             │
│  🟠 Input focus borders            │
│  🟠 Selected navigation item       │
│  🟠 Curved header background       │
│                                    │
└────────────────────────────────────┘

┌─ White Locations ──────────────────┐
│                                    │
│  ⚪ Dashboard header               │
│  ⚪ Card backgrounds               │
│  ⚪ Input field backgrounds        │
│  ⚪ Bottom navigation background   │
│  ⚪ Avatar circle background       │
│                                    │
└────────────────────────────────────┘

┌─ Gray Locations ───────────────────┐
│                                    │
│  ⚫ Main body text                 │
│  ⚫ Section labels                 │
│  ⚫ Unselected nav items           │
│  ⚫ Input placeholder text         │
│  ⚫ Subtle text (dates, captions)  │
│  ⚫ Border colors                  │
│                                    │
└────────────────────────────────────┘
```

## Spacing Grid (8pt base)

```
Component Layout:
┌─────────────────────────────────────┐  24px padding
│  ┌─────────────────────────────────┐│
│  │  Content (16px horizontal)      ││
│  └─────────────────────────────────┘│
│         24px padding               │
└─────────────────────────────────────┘

Grid Layout:
┌──────────┐  16px gap  ┌──────────┐
│  Card 1  │            │  Card 2  │
└──────────┘            └──────────┘
    ↓
   16px
    ↓
┌──────────┐  16px gap  ┌──────────┐
│  Card 3  │            │  Card 4  │
└──────────┘            └──────────┘

Section Spacing:
├─ 32px ─┤
├─ 24px ─┤ Header
├─ 32px ─┤
├─ 16px ─┤ Section Title
├─ 16px ─┤ Content
├─ 32px ─┤
```

## Responsive Breakpoints

```
┌─ Mobile (≤ 600px) ─────────┐
│ Single column              │
│ Full width buttons         │
│ Stacked sections           │
└────────────────────────────┘

┌─ Tablet (600px - 1000px) ──┐
│ 2 column grid              │
│ Wider padding              │
│ Horizontal navigation ok   │
└────────────────────────────┘

┌─ Desktop (≥ 1000px) ───────┐
│ 4 column grid possible     │
│ Max width constraints      │
│ Centered content           │
└────────────────────────────┘
```

## State Flow Diagram

```
MyApp
  └── MaterialApp
      └── MainAppScreen (StatefulWidget)
          │
          ├── _selectedIndex (0-2)
          │
          └── Scaffold
              ├── Body: IndexedStack
              │   ├── [0] DashboardScreen
              │   ├── [1] TimerScreen
              │   └── [2] ProfileScreen
              │
              └── BottomNavigationBar
                  └── onTap: setState(_selectedIndex)
```

## Form State Management

```
ProfileScreen
  └── _ProfileScreenState
      │
      ├── _nameController
      ├── _dobController
      ├── _phone1Controller
      ├── _phone2Controller
      └── _phone3Controller
          │
          └── dispose() - Called on screen exit
              ├── _nameController.dispose()
              ├── _dobController.dispose()
              └── etc...
```

## Animation Flow (Timer)

```
Start Button Pressed
    ↓
setState() { _isRunning = true }
    ↓
_animationController.forward()
    ↓
AnimationController counts down
    ↓
Every frame updates display
    ↓
User sees countdown

Pause Button Pressed
    ↓
setState() { _isRunning = false }
    ↓
_animationController.stop()
    ↓
Timer paused

Reset Button Pressed
    ↓
_animationController.reset()
_isRunning = false
    ↓
Timer returns to initial value
```

## Accessibility Map

```
Touch Targets (Min 48x48px):
┌─────────────────┐
│   Button/Icon   │ 48px minimum
│                 │
└─────────────────┘

Text Sizes:
- Headlines: 20px+ (good for scanning)
- Body: 14-16px (readable)
- Labels: 12-14px (secondary info)

Color Contrast:
- Orange on White: ✅ 6.2:1 (AAA)
- Gray on White: ✅ 4.5:1+ (AA)

Interactive Elements:
- All buttons have labels
- All icons have text labels
- Focus states clearly visible
```

---

These diagrams provide visual understanding of:
- Screen layouts and component hierarchy
- Color distribution throughout the app
- Spacing and alignment system
- Responsive behavior
- State management flow
- Accessibility standards applied

