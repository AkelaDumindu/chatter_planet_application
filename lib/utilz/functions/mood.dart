enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

// get name and emoji of the mood
extension MoodExtension on Mood {
  // Get the name of the mood
  String get name {
    switch (this) {
      case Mood.happy:
        return 'happy';
      case Mood.sad:
        return 'sad';
      case Mood.angry:
        return 'angry';
      case Mood.excited:
        return 'excited';
      case Mood.bored:
        return 'bored';
      default:
        return '';
    }
  }

  // Get the emoji of the mood
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.sad:
        return '😢';
      case Mood.angry:
        return '😡';
      case Mood.excited:
        return '🤩';
      case Mood.bored:
        return '😴';
      default:
        return '';
    }
  }

  // convert string to a mood enum value
  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) =>
          mood.name == moodString, // when have mood value have return that
      orElse: () => Mood.happy, // default value if none match
    );
  }
}
