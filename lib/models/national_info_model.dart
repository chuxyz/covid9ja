class NationalInfo {
  int? samplesTested;
  int? confirmedCases;
  int? activeCases;
  int? dischargedCases;
  int? deaths;

  NationalInfo(
      {this.samplesTested,
      this.confirmedCases,
      this.activeCases,
      this.dischargedCases,
      this.deaths});

  NationalInfo.fromJson(Map<String, dynamic> json) {
    samplesTested = json['SamplesTested'];
    confirmedCases = json['ConfirmedCases'];
    activeCases = json['ActiveCases'];
    dischargedCases = json['DischargedCases'];
    deaths = json['Deaths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SampleTested'] = this.samplesTested;
    data['ConfirmedCases'] = this.confirmedCases;
    data['ActiveCases'] = this.activeCases;
    data['DischargedCases'] = this.dischargedCases;
    data['Deaths'] = this.deaths;

    return data;
  }
}

class NationalInfoPercentageModel {
  double? deathPercentage;
  double? activePercentage;
  double? dischargedPercentage;

  NationalInfoPercentageModel({
    this.activePercentage,
    this.deathPercentage,
    this.dischargedPercentage,
  });
}
