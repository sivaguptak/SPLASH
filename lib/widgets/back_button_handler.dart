import 'package:flutter/material.dart';
import '../services/back_button_service.dart';

class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final BackButtonBehavior behavior;

  const BackButtonHandler({
    super.key,
    required this.child,
    this.behavior = BackButtonBehavior.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        bool shouldPop = false;
        
        switch (behavior) {
          case BackButtonBehavior.navigate:
            shouldPop = await BackButtonService.handleBackNavigation(context);
            break;
          case BackButtonBehavior.exit:
            shouldPop = await BackButtonService.handleBackPress(context);
            break;
          case BackButtonBehavior.home:
            shouldPop = await BackButtonService.handleBackToHome(context);
            break;
        }
        
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}

enum BackButtonBehavior {
  navigate, // Navigate to previous screen, show exit confirmation if no previous screen
  exit,     // Always show exit confirmation
  home,     // Navigate to home screen
}
