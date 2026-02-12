import 'package:intl/intl.dart';

class DateUtil {
  static String? convertToLocalDate(DateTime? date,
      {String? format = 'dd MMM,hh:mm a'}) {
    final localDate = date?.toLocal();
    if (localDate != null) {
      return DateFormat(format).format(localDate);
    } else {
      return null;
    }
  }

  String formatRelativeTime(DateTime? dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }
  }

  static String? convertTimestampToLocalDate(dynamic timeStamp,
      {String? format = 'dd MMM,yyyy'}) {
    if (timeStamp == null) {
      return null;
    } // Convert seconds to milliseconds
    int milliseconds = (timeStamp * 1000).toInt();

    // Convert milliseconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final localDate = dateTime.toLocal();
    return DateFormat(format).format(localDate);
  }
}
