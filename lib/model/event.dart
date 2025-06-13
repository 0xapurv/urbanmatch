class Event {
  final String eventName;
  final DateTime eventDateTime;

  Event({
    required this.eventName,
    required this.eventDateTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final eventName = json['name'] as String? ?? 'No name';
    final eventTimeString = json['time'] as String?;
    DateTime parsedEventTime;

    if (eventTimeString != null) {
      try {
        parsedEventTime = DateTime.parse(eventTimeString);
      } catch (_) {
        parsedEventTime = DateTime.now(); // or choose a default
      }
    } else {
      parsedEventTime = DateTime.now(); // or choose a default
    }

    return Event(
      eventName: eventName,
      eventDateTime: parsedEventTime,
    );
  }
}
