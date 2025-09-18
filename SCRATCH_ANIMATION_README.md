# Scratch Animation Feature

This document describes the scratch animation feature implemented for coupons in the Locsy app.

## Overview

The scratch animation feature allows users to interact with coupons by scratching a silver layer to reveal the coupon details underneath. This creates an engaging and gamified experience for users when they receive coupons.

## Features

### 🎯 Core Functionality
- **Interactive Scratch Layer**: Users can touch and drag to scratch away the silver layer
- **Progressive Reveal**: The coupon is revealed gradually as the user scratches
- **Smooth Animations**: Elastic reveal animation with celebration effects
- **Haptic Feedback**: Visual and tactile feedback during scratching
- **State Management**: Tracks scratch progress and completion state

### 🎨 Visual Design
- **Custom Paint**: Hand-drawn scratch effects with realistic texture
- **Gradient Backgrounds**: Beautiful color schemes matching the app theme
- **Celebration Animation**: Confetti-like reveal effect when coupon is fully scratched
- **Responsive Design**: Works on different screen sizes

### 🔧 Technical Implementation
- **Custom Painter**: Efficient rendering of scratch effects
- **Animation Controllers**: Smooth transitions and reveal animations
- **State Management**: Proper handling of scratch states and progress
- **Memory Efficient**: Optimized rendering for smooth performance

## Components

### 1. ScratchCouponWidget
**Location**: `lib/widgets/scratch_coupon_widget.dart`

Main widget that handles the scratch animation functionality.

**Key Features**:
- Touch gesture handling for scratching
- Custom paint for scratch effects
- Progressive reveal animation
- Celebration overlay when revealed

**Usage**:
```dart
ScratchCouponWidget(
  title: 'Pizza Palace',
  description: 'Get 20% off on any pizza order',
  discount: '20%',
  expiryDate: 'Dec 31, 2024',
  isScratched: false,
  onScratchComplete: () => print('Coupon revealed!'),
)
```

### 2. Enhanced Coupon Model
**Location**: `lib/data/models/enhanced_coupon.dart`

Enhanced data model that includes scratch animation support.

**Key Features**:
- Scratch state tracking
- Expiry date handling
- Discount text formatting
- Status management

### 3. Coupon Scratch Service
**Location**: `lib/services/coupon_scratch_service.dart`

Service for managing coupon scratch states and animations.

**Key Features**:
- State management for multiple coupons
- Scratch progress tracking
- Statistics and analytics
- Token generation for security

### 4. Demo Screen
**Location**: `lib/features/demo/screens/scratch_demo_screen.dart`

Demo screen showcasing the scratch animation feature.

**Key Features**:
- Multiple sample coupons
- Reset functionality
- Progress tracking
- Instructions for users

## Usage

### Basic Implementation

1. **Add the widget to your screen**:
```dart
import '../../../widgets/scratch_coupon_widget.dart';

ScratchCouponWidget(
  title: 'Your Coupon Title',
  description: 'Coupon description',
  discount: '20%',
  expiryDate: 'Dec 31, 2024',
  onScratchComplete: () {
    // Handle coupon reveal
  },
)
```

2. **Access the demo**:
Navigate to the User Dashboard and tap "🎁 Scratch Demo" to see the feature in action.

### Advanced Usage

1. **Using the service**:
```dart
final scratchService = CouponScratchService();

// Add coupons
scratchService.addCoupons(coupons);

// Listen to changes
scratchService.addListener(() {
  // Handle state changes
});

// Complete scratch
await scratchService.completeScratch(couponId);
```

2. **Custom styling**:
```dart
ScratchCouponWidget(
  // ... other properties
  backgroundColor: Colors.blue,
  scratchColor: Colors.grey,
)
```

## Customization

### Colors
- `backgroundColor`: Background color of the coupon card
- `scratchColor`: Color of the scratch layer
- Theme colors are used from `LocsyColors`

### Animations
- Scratch reveal duration: 2000ms
- Celebration animation duration: 1500ms
- Elastic curve for reveal effect

### Gestures
- Touch and drag to scratch
- Minimum scratch area for completion
- Smooth gesture recognition

## Performance Considerations

- **Efficient Rendering**: Custom painter only redraws when necessary
- **Memory Management**: Proper disposal of animation controllers
- **Smooth Animations**: 60fps target with optimized paint operations
- **State Persistence**: Scratch states are maintained across app sessions

## Future Enhancements

- **Sound Effects**: Audio feedback during scratching
- **Haptic Feedback**: Vibration on scratch completion
- **Multiple Scratch Patterns**: Different scratch textures
- **Social Sharing**: Share revealed coupons
- **Analytics**: Track scratch completion rates
- **A/B Testing**: Different scratch experiences

## Testing

The feature includes:
- Demo screen for manual testing
- Reset functionality for repeated testing
- Multiple coupon examples
- Different scratch colors and patterns

## Browser Compatibility

The scratch animation works on:
- ✅ Android (Flutter)
- ✅ iOS (Flutter)
- ✅ Web (Flutter Web)
- ✅ Desktop (Flutter Desktop)

## Troubleshooting

### Common Issues

1. **Scratch not working**: Ensure touch gestures are properly enabled
2. **Animation stuttering**: Check for memory leaks in animation controllers
3. **Performance issues**: Reduce scratch texture complexity

### Debug Mode

Enable debug mode to see:
- Scratch progress values
- Animation controller states
- Gesture recognition details

## Contributing

When contributing to the scratch animation feature:

1. Maintain smooth 60fps performance
2. Test on multiple devices
3. Ensure accessibility compliance
4. Update documentation for new features
5. Add unit tests for new functionality

## License

This feature is part of the Locsy app and follows the same licensing terms.
