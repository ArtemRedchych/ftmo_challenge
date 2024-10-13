// app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/features/errors_handler/presentation/error_screen.dart';
import 'package:ftmo/src/features/splash_screen/splash_screen.dart';
import 'package:ftmo/src/features/symbols/presentation/symbols_screen.dart';
import 'package:ftmo/src/features/symbols/providers/init_provider.dart';
import 'package:go_router/go_router.dart';

final routerProvider = AutoDisposeProvider<GoRouter>((ref) {
  final initializationState = ref.watch(initializationProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isInitializing = initializationState.isLoading;
      final hasError = initializationState.hasError;
      final isInitialized = initializationState.hasValue;

      if (isInitializing) {
        // While initializing, stay on or go to the splash screen
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      if (hasError) {
        // If initialization failed, navigate to the error page
        return '/error';
      }

      if (isInitialized) {
        // If initialization succeeded, navigate to the home page
        return state.matchedLocation == '/' ? null : '/';
      }

      // Default to splash screen
      return '/splash';
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SymbolsScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => const ErrorScreen(),
      ),
    ],
  );
});