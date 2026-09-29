class ErrorMessage {
  static String from(Object error) {
    final message = error.toString();

    if (message.contains('permission-denied')) {
      return 'You do not have permission to perform this action.';
    }

    if (message.contains('network-request-failed')) {
      return 'Please check your internet connection and try again.';
    }

    if (message.contains('unavailable')) {
      return 'The service is temporarily unavailable. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }
}
