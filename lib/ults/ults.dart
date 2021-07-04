import 'package:intl/intl.dart';

String dateTimeFormatTime(DateTime dateTime){
  return DateFormat.Hm().format(dateTime);
}

List<String> _createKeyword(String text){
  List<String> list = [];
  for(var i = text.length; i >=3; i--){
    list.add(text.substring(0,i));
  }
  return list;
}

List<String> generateKeywords(String text){
  List<String> list = [];
  for(int i = 0; i < text.length - 2; i++){
    var subList = _createKeyword(text.substring(i));
    list.addAll(subList);
  }
  return list;
}