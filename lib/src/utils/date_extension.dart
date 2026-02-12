import 'package:intl/intl.dart';

extension DateExtension on String {
  String toLocalDateTime({String? format = 'dd MMM, hh:mm a'}) {
    // Parse the UTC time string to a DateTime object
    DateTime utcDateTime = DateTime.parse(this);

    // Get the local time zone offset
    DateTime localDateTime = utcDateTime.toLocal();

    // Format the local time as a string using the custom format
    String formattedLocalTime = DateFormat(format).format(localDateTime);

    return formattedLocalTime;
  }
}
