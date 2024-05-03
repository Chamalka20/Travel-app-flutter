class TimeAgoSinceDate {


  TimeAgoSinceDate();

  String timeAgoSinceDate(addDate) {
  
  DateTime date = addDate.toLocal();
  final date2 = DateTime.now().toLocal();
  final difference = date2.difference(date);

  if (difference.inSeconds < 5) {
    return 'Just now';
  } else if (difference.inSeconds <= 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes <= 1) {
    return '1 minute ago' ;
  } else if (difference.inMinutes <= 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours <= 1) {
    return '1 hour ago';
  } else if (difference.inHours <= 60) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays <= 1) {
    return '1 day ago' ;
  } else if (difference.inDays <= 6) {
    return '${difference.inDays} days ago';
  } else if ((difference.inDays / 7).ceil() <= 1) {
    return '1 W' ;
  } else if ((difference.inDays / 7).ceil() <= 4) {
    return '${(difference.inDays / 7).ceil()} W';
  } else if ((difference.inDays / 30).ceil() <= 1) {
    return '1 month ago' ;
  } else if ((difference.inDays / 30).ceil() <= 30) {
    return '${(difference.inDays / 30).ceil()} months ago';
  } else if ((difference.inDays / 365).ceil() <= 1) {
    return '1 year ago' ;
  }
  return '${(difference.inDays / 365).floor()} years ago';
}


}

final TimeAgoSince = TimeAgoSinceDate();
