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

String getPrintableTimer(String secondsStr) {
  final int? parsedSeconds = int.tryParse(secondsStr);
  if (parsedSeconds == null) {
    return '';
  }
  final int seconds = parsedSeconds % 60;
  final int minutes = parsedSeconds ~/ 60 % 60;
  final int hours = parsedSeconds ~/ 3600 % 60;
  String result = '';
  if (hours != 0) {
    if (hours < 10) {
      result += '0$hours:';
    } else {
      result += '$hours:';
    }
  }
  if (minutes != 0) {
    if (minutes < 10) {
      result += '0$minutes:';
    } else {
      result += '$minutes:';
    }
  }
  if (seconds != 0) {
    if (seconds < 10) {
      result += '0$seconds';
    } else {
      result += '$seconds';
    }
  }
  if (minutes == 0 && hours != 0) {
    if (seconds == 0) {
      if (hours < 10) {
        return '0$hours:00:00';
      }
      return '$hours:00:00';
    }
    if (hours < 10) {
      return '0$hours:00:$seconds';
    }
    return '$hours:00:$seconds';
  }
  if (seconds == 0 && minutes != 0) {
    if (minutes < 10) {
      return '0$minutes:00';
    }
    return '$minutes:00';
  }
  if (result.isNotEmpty) {
    return result;
  }
  return '0';
}

String getPrintableTimerSinceStart(String seconds) {
  final String res = getPrintableTimer(seconds);
  if (res.length == 2) {
    return '0:$res';
  }
  if (res.length == 1) {
    return '0:0$res';
  }
  return res;
}
