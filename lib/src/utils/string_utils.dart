class StringUtils {
  static String convertFirstToUpperCase(String input) {
    if (input.isEmpty) {
      return '';
    }
    List<String> words = input.split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }
    String result = words.join(' ');
    return result;
  }

  static String convertFirstToLowerCase(String input) {
    if (input.isEmpty) {
      return '';
    }
    List<String> words = input.split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toLowerCase() + word.substring(1).toLowerCase();
      }
    }
    String result = words.join('_');
    return result;
  }

  static String convertFirstToUpperCaseAndRemoveScore(String input) {
    if (input.isEmpty) {
      return '';
    }
    List<String> words = input.split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }
    String result = words.join(' ');
    return result;
  }

  static String convertToLowerCaseAndJoin(String input) {
    if (input.isEmpty) {
      return '';
    }
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toLowerCase() + word.substring(1).toLowerCase();
      }
    }
    String result = words.join('_');
    return result;
  }

  static String? getFirstName(String? input) {
    if (input == null) {
      return null;
    }
    String? result = input.split(" ")[0];
    return result;
  }

  static String? getCardNumWithAsterisks(dynamic cardNum) {
    final asterisks = List.generate(3, (_) => '*' * 4);
    String? cardNumWithAsterisks = '${asterisks.join(' ')} $cardNum';
    return cardNumWithAsterisks;
  }

  static String convertEnumToString(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }
    String? result = input.split(".")[1];
    return convertFirstToUpperCase(result);
  }
}
