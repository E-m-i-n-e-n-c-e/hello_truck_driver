# Onboarding Module

This directory contains a well-organized onboarding flow split into logical components for better maintainability and code reuse.

## Structure

```
onboarding/
├── onboarding.dart                 # Main export file
├── onboarding_screen.dart         # Main onboarding screen orchestrator
├── controllers/
│   └── onboarding_controller.dart # State management and business logic
├── widgets/
│   ├── onboarding_header.dart     # Header with progress indicator
│   ├── onboarding_bottom_section.dart # Bottom action buttons
│   └── onboarding_components.dart # Shared reusable components
└── steps/
    ├── name_step.dart             # Name input step
    ├── photo_step.dart            # Photo upload step
    ├── email_step.dart            # Email verification step
    └── phone_step.dart            # Phone number step
```

## Key Features

- **Modular Architecture**: Each step is a separate component for easy maintenance
- **Shared Controller**: Centralized state management with OnboardingController
- **Reusable Components**: Common UI elements like icons, titles, and text fields
- **Enhanced Animations**: Smooth transitions and micro-interactions
- **Modern UI/UX**: Material 3 design with improved visual hierarchy

## Usage

```dart
import 'package:hello_truck_driver/screens/onboarding/onboarding.dart';

// Use OnboardingScreen as before - the API remains the same
const OnboardingScreen()
```

## Benefits

1. **Maintainability**: Easier to modify individual steps without affecting others
2. **Reusability**: Components can be reused across different parts of the app
3. **Testability**: Each component can be tested in isolation
4. **Performance**: Better tree shaking and smaller bundle sizes
5. **Scalability**: Easy to add new steps or modify existing ones