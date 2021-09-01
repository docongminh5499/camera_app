class Utils {
  static String getTimeString(DateTime time) {
    String year = time.year.toString();
    String month;
    if (time.month > 9)
      month = time.month.toString();
    else
      month = "0" + time.month.toString();

    String day;
    if (time.day > 9)
      day = time.day.toString();
    else
      day = "0" + time.day.toString();

    String hour;
    if (time.hour > 9)
      hour = time.hour.toString();
    else
      hour = "0" + time.hour.toString();

    String minute;
    if (time.minute > 9)
      minute = time.minute.toString();
    else
      minute = "0" + time.minute.toString();
      
    return year + "-" + month + "-" + day + " " + hour + ":" + minute;
  }
}
