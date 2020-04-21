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
    ],
    "totalCases": [
      {
          "date": "2020-01-22T00:00:00.000Z",
          "count": 600
      },
      {
          "date": "2020-01-23T00:00:00.000Z",
          "count": 702
      },
    ]
    "globalData": {
      "recentCase": 1426096,
      "recentDeath": 81865,
      "recentRecovered": 296263,
      "totalCases": 1804224
    }
  }
}
*/

class WorldStats{
  List<ActiveCases> cases;
  List<Deaths> deaths;
  List<Recovered> recovered;
  List<TotalCases> totalCases;
  GlobalData globalData;

  WorldStats({
    this.cases, this.deaths, this.recovered, this.totalCases, this.globalData
});

  factory WorldStats.fromJson(Map<String, dynamic> parsedJson){

    var listA = parsedJson['case'] as List;
    List<ActiveCases> activeCasesList = listA.map((i) => ActiveCases.fromJson(i)).toList();
    var listD = parsedJson['deaths'] as List;
    List<Deaths> deathsList = listD.map((i) => Deaths.fromJson(i)).toList();
    var listR = parsedJson['recovered'] as List;
    List<Recovered> recoveredList = listR.map((i) => Recovered.fromJson(i)).toList();
    var listT = parsedJson['totalCases'] as List;
    List<TotalCases> totalList = listT.map((i) => TotalCases.fromJson(i)).toList();

    return WorldStats(
      cases: activeCasesList,
      deaths: deathsList,
      recovered: recoveredList,
      totalCases: totalList,
      globalData: GlobalData.fromJson(parsedJson['globalData']),
    );
  }
}

class ActiveCases{
  int number;
  DateTime date;

  ActiveCases({
    this.number, this.date
});

  factory ActiveCases.fromJson(Map<String, dynamic> json){
    return ActiveCases(
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


class TotalCases{
  int number;
  DateTime date;

  TotalCases({
    this.number, this.date
});

  factory TotalCases.fromJson(Map<String, dynamic> json){
    return TotalCases(
      number: json['count'],
      date: DateTime.parse(json["date"]),
    );
  }
}

class GlobalData{
  
  int recentCase;
  int recentDeath;
  int recentRecovered;
  int recentTotalCases;

  GlobalData({
    this.recentCase, this.recentDeath, this.recentRecovered, this.recentTotalCases
});

  factory GlobalData.fromJson(Map<String, dynamic> json){
    return GlobalData(
      recentCase: json['recentCase'],
      recentDeath: json["recentDeath"],
      recentRecovered: json["recentRecovered"],
      recentTotalCases: json["recentTotalCases"],
    );
  }
}