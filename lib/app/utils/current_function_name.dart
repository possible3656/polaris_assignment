String getCurrentFunctionName() {
  final stackTrace = StackTrace.current;
  final frames = stackTrace.toString().split('\n');
  if (frames.length > 2) {
    final currentFunctionName = frames[1].trim();
    final whitespaceIndex = currentFunctionName.indexOf(' ');
    if (whitespaceIndex != -1) {
      return currentFunctionName.substring(whitespaceIndex + 1).trim();
    }
  }
  return 'Name Not Found';
}
