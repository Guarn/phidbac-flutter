import 'package:flutter/material.dart';

class Filtres {
  List<String> notions;
  List<String> auteurs;
  List<String> destinations;
  List<String> series;
  RangeValues annees;
  String recherche;
  TypeRecherche typeRecherche;

  Filtres(
      {this.notions,
      this.auteurs,
      this.destinations,
      this.series,
      this.annees,
      this.recherche,
      this.typeRecherche}) {
    this.notions = [];
    this.auteurs = [];
    this.destinations = [];
    this.series = [];
    this.annees = RangeValues(1996, 2019);
    this.recherche = "";
    this.typeRecherche = TypeRecherche.exacte;
  }

  void reset() {
    notions = [];
    auteurs = [];
    destinations = [];
    series = [];
    annees = RangeValues(1996, 2019);
    recherche = "";
    typeRecherche = TypeRecherche.exacte;
  }

  bool areFiltersSet() {
    if (notions.length == 0 &&
        auteurs.length == 0 &&
        destinations.length == 0 &&
        series.length == 0 &&
        annees.start == 1996.0 &&
        annees.end == 2019.0 &&
        recherche == "") {
      return false;
    } else {
      return true;
    }
  }
}

enum FiltersTypes { notions, auteurs, destinations, series, annees }

extension FilterDefs on FiltersTypes {
  static String _value(FiltersTypes val) {
    switch (val) {
      case FiltersTypes.notions:
        return "notions";
      case FiltersTypes.auteurs:
        return "auteurs";
      case FiltersTypes.destinations:
        return "destinations";
      case FiltersTypes.series:
        return "series";
      case FiltersTypes.annees:
        return "annees";
    }
  }

  String get value => _value(this);
}

enum TypeRecherche { exacte, unDesMots, tousLesMots }
