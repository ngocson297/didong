import 'package:intl/intl.dart';

String dateTimeFormatTime(DateTime dateTime){
  return DateFormat.Hm().format(dateTime);
}