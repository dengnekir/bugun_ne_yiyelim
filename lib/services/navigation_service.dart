import 'package:flutter/material.dart';
import '../constants/app_animations.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;
  NavigationService._init();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final removeAllOldRoutes = (Route<dynamic> route) => false;

  Future<T?> navigateToPage<T>({required Widget page}) async {
    return await navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<T?> navigateToPageWithFade<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    return await navigatorKey.currentState?.push<T>(
      AppAnimations.fadeTransition<T>(
        page: page,
        duration: duration,
      ),
    );
  }

  Future<T?> navigateToPageWithSlide<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    SlideDirection direction = SlideDirection.right,
  }) async {
    return await navigatorKey.currentState?.push<T>(
      AppAnimations.slideTransition<T>(
        page: page,
        duration: duration,
        direction: direction,
      ),
    );
  }

  Future<void> navigateToPageClear({required Widget page}) async {
    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      removeAllOldRoutes,
    );
  }

  void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
