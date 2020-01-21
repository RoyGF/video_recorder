class Question {
  String _question;
  int _timeToRecord;
  String _videoPath;

  Question(String inQuestion, int inTimeToRecord) {
    this._question = inQuestion;
    this._timeToRecord = inTimeToRecord;
  }

  String getQuestion() {
    return _question;
  }

  int getTimeToRecord() {
    return _timeToRecord;
  }

  String getVideoPath() {
    return _videoPath;
  }

  void setVideoPath(String videoPath) {
    this._videoPath = videoPath;
  }

  bool hasVideo() {
    return _videoPath != null;
  }
}
