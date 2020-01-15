class Question {
  String _question;
  int _timeToRecord;

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
}
