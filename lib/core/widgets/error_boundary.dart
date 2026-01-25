import 'package:flutter/material.dart';
import '../extensions/l10n_context.dart';

/// Error boundary widget that catches errors and displays a user-friendly message
/// Note: Flutter doesn't have true error boundaries like React.
/// This widget provides a consistent error UI pattern.
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    // Flutter handles errors at the framework level via FlutterError.onError
    // This widget is mainly for consistent error UI patterns
    return child;
  }
}

/// Fallback widget displayed when an error occurs
class _ErrorFallback extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final Widget? fallback;

  const _ErrorFallback({
    required this.error,
    this.stackTrace,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (fallback != null) return fallback!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.somethingWentWrong,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.errorOccurred,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Try to navigate back or restart
                  Navigator.of(context).maybePop();
                },
                child: Text(context.l10n.goBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error handler utility
class ErrorHandler {
  /// Handle and log errors gracefully
  static void handleError(
    BuildContext context,
    Object error, {
    StackTrace? stackTrace,
    String? message,
    VoidCallback? onRetry,
  }) {
    // Log error (in production, send to crash reporting service)
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }

    // Show user-friendly error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? context.l10n.errorOccurred),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onRetry != null
            ? SnackBarAction(
                label: context.l10n.retry,
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Handle async errors with retry
  static Future<T?> handleAsyncError<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? errorMessage,
    VoidCallback? onRetry,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      handleError(
        context,
        e,
        stackTrace: stackTrace,
        message: errorMessage,
        onRetry: onRetry,
      );
      return null;
    }
  }
}
