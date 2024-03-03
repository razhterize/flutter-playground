bool isDigit(String input) => RegExp("^[0-9]").hasMatch(input);

bool isParentheses(String input) => input.contains('(') || input.contains(')');


