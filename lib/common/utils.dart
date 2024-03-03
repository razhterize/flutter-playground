import 'package:money_formatter/money_formatter.dart';

bool isDigit(String input) => RegExp("^[0-9]").hasMatch(input);

bool isParentheses(String input) => input.contains('(') || input.contains(')');

MoneyFormatterOutput idrMoney(double amount) => MoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: "Rp",
        thousandSeparator: ',',
      ),
    ).output;
