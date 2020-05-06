class Sujet {
  final int id;
  final int annee;
  final String serie;
  final String session;
  final String auteur;
  final List<dynamic> destination;
  final String code;
  final String sujet1;
  final String sujet2;
  final String sujet3;
  final List<dynamic> notions1;
  final List<dynamic> notions2;
  final List<dynamic> notions3;

  Sujet(
      {this.id,
      this.annee,
      this.serie,
      this.session,
      this.auteur,
      this.destination,
      this.code,
      this.sujet1,
      this.sujet2,
      this.sujet3,
      this.notions1,
      this.notions2,
      this.notions3});

  factory Sujet.fromJson(Map<String, dynamic> json) {
    return Sujet(
      id: json['id'] as int,
      annee: json['Annee'],
      auteur: json['Auteur'],
      serie: json['Serie'],
      session: json['Session'],
      destination: json['Destination'],
      code: json['Code'],
      sujet1: json['Sujet1Naked'],
      sujet2: json['Sujet2Naked'],
      sujet3: json['Sujet3Naked'],
      notions1: json['Notions1'],
      notions2: json['Notions2'],
      notions3: json['Notions3'],
    );
  }
}

class SujetSimple extends Sujet {
  final NumSujet numSujet;

  SujetSimple({
    id,
    annee,
    serie,
    session,
    auteur,
    destination,
    code,
    sujet1,
    sujet2,
    sujet3,
    notions1,
    notions2,
    notions3,
    this.numSujet,
  }) : super(
          id: id,
          annee: annee,
          serie: serie,
          session: session,
          auteur: auteur,
          destination: destination,
          code: code,
          sujet1: sujet1,
          sujet2: sujet2,
          sujet3: sujet3,
          notions1: notions1,
          notions2: notions2,
          notions3: notions3,
        );

  factory SujetSimple.fromSujet(Sujet sujet, NumSujet numSujet) {
    return SujetSimple(
      id: sujet.id,
      annee: sujet.annee,
      serie: sujet.serie,
      session: sujet.session,
      auteur: sujet.auteur,
      destination: sujet.destination,
      code: sujet.code,
      sujet1: sujet.sujet1,
      sujet2: sujet.sujet2,
      sujet3: sujet.sujet3,
      notions1: sujet.notions1,
      notions2: sujet.notions2,
      notions3: sujet.notions3,
      numSujet: numSujet,
    );
  }
}

enum NumSujet { sujet1, sujet2, sujet3, notDefined }
