/// Returns the name of the current function.
///
/// This function uses the [StackTrace.current] to get the current stack trace,
/// and then extracts the name of the current function from the stack trace.
/// If the name is found, it is returned. Otherwise, it returns 'Name Not Found'.
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
