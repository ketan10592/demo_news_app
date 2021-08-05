
import 'package:intl/intl.dart';
import "package:timeago/timeago.dart" as timeago;


class DateTimeUtils{
  String getEMMMMdFormatedDate(String dtString){
    try {
      var _dt = DateTime.parse(dtString);
      return DateFormat('E, MMM dd').format(_dt.toLocal());
      ///return Example : Fri, Dec 29
    } catch (e) {
      return '';
    }
  }

  String getTimeAgo(String dtString) {
    try {
      var _dt = DateTime.parse(dtString);
      return (timeago.format(_dt, locale: 'en_short'));
    } catch (e) {
      return '';
    }
  }
}
