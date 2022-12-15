class Notif {
  String text;
  String date;

  Notif({
    required this.text,
    required this.date
  });

  @override
  String toString() => 'Notification: $text\nDate: $date';
}