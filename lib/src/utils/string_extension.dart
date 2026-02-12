extension ReplaceWhiteSpaces on String {
  replaceWhiteSpaces() {
    return replaceAll(RegExp(r"\s+"), " ");
  }

  String capitalizeFirst() {
    if (isEmpty) {
      return this;
    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }
}
