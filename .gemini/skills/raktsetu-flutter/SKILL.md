---
name: raktsetu-flutter
description: Flutter development skill for RaktSetu — screen scaffolding patterns, package management, testing, building, and code generation.
---

# RaktSetu Flutter Development Skill

## Purpose
Standardized patterns for Flutter development in RaktSetu.

---

## Screen Scaffolding Pattern

Every new screen should follow this structure:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Title')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

### Checklist for new screens:
1. Create file in `lib/screens/<feature>/` directory
2. Add route in `lib/config/routes.dart`
3. Import in routes file
4. Use `const` constructors where possible
5. Use `GoogleFonts.inter()` for custom text styles
6. Use `RaktSetuTheme` colors, never hardcode colors

---

## State Management Pattern (Provider)

```dart
class FeatureProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> doSomething() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Business logic
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## Model Pattern (Firestore)

```dart
class ModelName {
  final String id;
  // ...fields

  factory ModelName.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ModelName(id: doc.id, /* ... */);
  }

  Map<String, dynamic> toFirestore() => { /* ... */ };
}
```

---

## Common Commands

### Run app
```bash
flutter run
flutter run -d chrome    # Web
flutter run -d emulator  # Android emulator
```

### Build
```bash
flutter build apk --release
flutter build ios --release
flutter build web
```

### Testing
```bash
flutter test
flutter test --coverage
flutter test test/specific_test.dart
```

### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Add Packages
```bash
flutter pub add <package_name>
flutter pub get
```

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
dart format lib/
```

---

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Files | `snake_case` | `donor_profile_screen.dart` |
| Classes | `PascalCase` | `DonorProfileScreen` |
| Variables | `camelCase` | `bloodGroup` |
| Constants | `camelCase` | `primaryRed` |
| Directories | `snake_case` | `blood_bank/` |

---

## Widget Guidelines

1. **Prefer const constructors** — Performance optimization
2. **Use `super.key`** — Modern Flutter key parameter syntax
3. **Extract widgets** — If a build method exceeds 50 lines, extract sub-widgets
4. **Use RaktSetuTheme** — Never hardcode colors or text styles
5. **Handle loading/error states** — Every async screen needs loading + error UI
