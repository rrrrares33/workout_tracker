int convertTimeToSeconds(String? time) {
  if (time == null) {
    return 0;
  }
  if (!time.contains(':')) {
    return int.parse(time);
  }
  if (time.length == 5) {
    return int.parse(time[0] + time[1]) * 60 + int.parse(time[3] + time[4]);
  }
  // if time.length == 8
  return int.parse(time[0] + time[1]) * 60 * 60 + int.parse(time[3] + time[4]) * 60 + int.parse(time[6] + time[7]) * 60;
}

String getPrintableTimer(String seconds) {
  final int? parsedSeconds = int.tryParse(seconds);
  if (parsedSeconds == null) {
    return '';
  }
  if (parsedSeconds > 60) {
    if (parsedSeconds - parsedSeconds ~/ 60 * 60 < 10) {
      return '0${parsedSeconds ~/ 60}:0${parsedSeconds - parsedSeconds ~/ 60 * 60}';
    }
    return '0${parsedSeconds ~/ 60}:${parsedSeconds - parsedSeconds ~/ 60 * 60}';
  }
  return parsedSeconds.toString();
}
