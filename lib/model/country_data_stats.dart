// To parse this JSON data, do
//
//     final countryData = countryDataFromJson(jsonString);

import 'dart:convert';

CountryData countryDataFromJson(String str) => CountryData.fromJson(json.decode(str));

String countryDataToJson(CountryData data) => json.encode(data.toJson());

class CountryData {
    CountryDataClass countryData;

    CountryData({
        this.countryData,
    });

    factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        countryData: CountryDataClass.fromJson(json["countryData"]),
    );

    Map<String, dynamic> toJson() => {
        "countryData": countryData.toJson(),
    };
}

class CountryDataClass {
    String country;
    CountryInfo countryInfo;
    final updated;
    final cases;
    final todayCases;
    final deaths;
    final todayDeaths;
    final recovered;
    final active;
    final critical;
    final casesPerOneMillion;
    final deathsPerOneMillion;
    final tests;
    final testsPerOneMillion;

    CountryDataClass({
        this.country,
        this.countryInfo,
        this.updated,
        this.cases,
        this.todayCases,
        this.deaths,
        this.todayDeaths,
        this.recovered,
        this.active,
        this.critical,
        this.casesPerOneMillion,
        this.deathsPerOneMillion,
        this.tests,
        this.testsPerOneMillion,
    });

    factory CountryDataClass.fromJson(Map<String, dynamic> json) => CountryDataClass(
        country: json["country"],
        countryInfo: CountryInfo.fromJson(json["countryInfo"]),
        updated: json["updated"],
        cases: json["cases"],
        todayCases: json["todayCases"],
        deaths: json["deaths"],
        todayDeaths: json["todayDeaths"],
        recovered: json["recovered"],
        active: json["active"],
        critical: json["critical"],
        casesPerOneMillion: json["casesPerOneMillion"],
        deathsPerOneMillion: json["deathsPerOneMillion"],
        tests: json["tests"],
        testsPerOneMillion: json["testsPerOneMillion"],
    );

    Map<String, dynamic> toJson() => {
        "country": country,
        "countryInfo": countryInfo.toJson(),
        "updated": updated,
        "cases": cases,
        "todayCases": todayCases,
        "deaths": deaths,
        "todayDeaths": todayDeaths,
        "recovered": recovered,
        "active": active,
        "critical": critical,
        "casesPerOneMillion": casesPerOneMillion,
        "deathsPerOneMillion": deathsPerOneMillion,
        "tests": tests,
        "testsPerOneMillion": testsPerOneMillion,
    };
}

class CountryInfo {
    final id;
    final iso2;
    final iso3;
    final lat;
    final long;
    final flag;

    CountryInfo({
        this.id,
        this.iso2,
        this.iso3,
        this.lat,
        this.long,
        this.flag,
    });

    factory CountryInfo.fromJson(Map<String, dynamic> json) => CountryInfo(
        id: json["_id"],
        iso2: json["iso2"],
        iso3: json["iso3"],
        lat: json["lat"],
        long: json["long"],
        flag: json["flag"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "iso2": iso2,
        "iso3": iso3,
        "lat": lat,
        "long": long,
        "flag": flag,
    };
}
