class Statez {
  String? stateName;
  int? casesConfirmed;
  int? casesOnAdmission;
  int? casesDischarged;
  int? deathCases;

  Statez({
    this.stateName,
    this.casesConfirmed,
    this.casesOnAdmission,
    this.casesDischarged,
    this.deathCases,
  });

  Statez.fromJson(Map<String, dynamic> json) {
    stateName = json['State'];
    casesConfirmed = json['CasesConfirmed'];
    casesOnAdmission = json['CasesOnAdmission'];
    casesDischarged = json['CasesDischarged'];
    deathCases = json['DeathCases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.stateName;
    data['CasesConfirmed'] = this.casesConfirmed;
    data['CasesOnAdmission'] = this.casesOnAdmission;
    data['CasesDischarged'] = this.casesDischarged;
    data['DeathCases'] = this.deathCases;

    return data;
  }
}

class PreferredState {
  final String stateName;
  final String stateCases;
  final String stateDeaths;

  PreferredState({
    required this.stateName,
    required this.stateCases,
    required this.stateDeaths,
  });
}
