# FinApp iOS

A modern fintech iOS application built with SwiftUI, following clean architecture principles and MVVM pattern.

## Features

- Beautiful onboarding experience
- Secure login with email/password
- Social login (Google, Apple)
- Clean and modern UI/UX
- Dark mode support
- Form validation
- Reusable UI components

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## Project Structure

```
FinApp/
├── Features/           # Feature modules
│   ├── Onboarding/     # Onboarding screens
│   └── Auth/           # Authentication screens
├── CommonUI/           # Reusable UI components
├── Resources/          # Colors, fonts, assets
├── Models/             # Data models
├── Networking/         # API clients and services
├── Persistence/        # Local storage
├── Helpers/            # Utility classes and extensions
└── Coordinators/      # Navigation coordinators
```

## Getting Started

1. Clone the repository
2. Open `FinApp.xcodeproj` in Xcode
3. Build and run the project

## Dependencies

- SwiftUI (built-in)
- Combine (built-in)

## Design System

### Colors
- Background: `#171212`
- Primary Button: `#DB0F0F`
- Text: `#FFFFFF`
- Text Field Background: `#362B2B`
- Teal Background: `#70A092`

### Typography
- Font Family: Lexend
- Weights: Regular, Medium, SemiBold, Bold

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture with Coordinators for navigation:

- **Models**: Represent the data and business logic
- **Views**: SwiftUI views that display the UI
- **ViewModels**: Handle presentation logic and state
- **Coordinators**: Manage navigation flow
- **Repositories**: Abstract data sources (local/remote)
- **Services**: Handle business logic and API calls

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
