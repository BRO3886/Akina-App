/*
{
  "time_series": {
    "case": [
      {
        "date": "2020-01-21T18:30:00.000Z",
        "count": 555
      },
    ],
    "recovered": [
      {
        "date": "2020-01-21T18:30:00.000Z",
        "count": 28
      },
    ],
    "deaths": [
      {
        "date": "2020-01-21T18:30:00.000Z",
        "count": 17
      },
    ]
  }
}
*/

class WorldStats{
  List<Cases> cases;
  List<Deaths> deaths;
  List<Recovered> recovered;

  WorldStats({
    this.cases, this.deaths, this.recovered
});

  factory WorldStats.fromJson(Map<String, dynamic> parsedJson){

    var listC = parsedJson['case'] as List;
    List<Cases> casesList = listC.map((i) => Cases.fromJson(i)).toList();
    var listD = parsedJson['deaths'] as List;
    List<Deaths> deathsList = listD.map((i) => Deaths.fromJson(i)).toList();
    var listR = parsedJson['recovered'] as List;
    List<Recovered> recoveredList = listR.map((i) => Recovered.fromJson(i)).toList();

    return WorldStats(
      cases: casesList,
      deaths: deathsList,
      recovered: recoveredList
    );
  }
}

class Cases{
  int number;
  DateTime date;

  Cases({
    this.number, this.date
});

  factory Cases.fromJson(Map<String, dynamic> json){
    return Cases(
      number: json['count'],
      date: DateTime.parse(json["date"]),
    );
  }
}

class Deaths{
  int number;
  DateTime date;

  Deaths({
    this.number, this.date
});

  factory Deaths.fromJson(Map<String, dynamic> json){
    return Deaths(
      number: json['count'],
      date: DateTime.parse(json["date"]),
    );
  }
}
class Recovered{
  int number;
  DateTime date;

  Recovered({
    this.number,
    this.date
});

  factory Recovered.fromJson(Map<String, dynamic> json){
    return Recovered(
      number: json['count'],
      date: DateTime.parse(json["date"]),
    );
  }
}