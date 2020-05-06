import 'package:flutter/material.dart';
import 'package:phidbac/Class/Filtres.dart';
import 'package:phidbac/Class/Menu.dart';
import 'package:phidbac/Class/Sujet.dart';

class GlobalState with ChangeNotifier {
  List<Sujet> sujets = [];
  List<SujetSimple> tempSujets = [];
  Filtres filtres = Filtres();
  Menu menu;

  bool areFiltersSet() {
    return filtres.areFiltersSet();
  }

  void addRemoveToFilter(FiltersTypes filter, String value) {
    if (!getFiltre(filter).contains(value)) {
      getFiltre(filter).add(value);
    } else {
      getFiltre(filter).removeWhere((el) => el == value);
    }
    notifyListeners();
  }

  void setAnnees(RangeValues val) {
    filtres.annees = val;
  }

  dynamic getFiltre(FiltersTypes filtre) {
    switch (filtre) {
      case FiltersTypes.notions:
        return filtres.notions;
      case FiltersTypes.auteurs:
        return filtres.auteurs;
      case FiltersTypes.destinations:
        return filtres.destinations;
      case FiltersTypes.series:
        return filtres.series;
      case FiltersTypes.annees:
        return filtres.annees;
    }
  }

  void reset() {
    filtres.reset();
    tempSujets = [];
    notifyListeners();
  }

  void setSujets(List<Sujet> newSujets) {
    sujets = newSujets;
    notifyListeners();
  }

  void setTempSujets(List<SujetSimple> newSujets) {
    tempSujets = newSujets;
    notifyListeners();
  }

  void setMenu(newMenu) {
    List<dynamic> tempAnnees = newMenu["annees"];
    List<Annee> annees = [];
    tempAnnees.forEach((el) => annees.add(Annee.fromJson(el)));

    List<dynamic> tempAuteurs = newMenu["auteurs"];
    List<Auteur> auteurs = [];
    tempAuteurs.forEach((el) => auteurs.add(Auteur.fromJson(el)));

    List<dynamic> tempDestinations = newMenu["destinations"];
    List<Destination> destinations = [];
    tempDestinations
        .forEach((el) => destinations.add(Destination.fromJson(el)));

    List<dynamic> tempNotions = newMenu["notions"];
    List<Notion> notions = [];
    tempNotions.forEach((el) => notions.add(Notion.fromJson(el)));

    List<dynamic> tempSeries = newMenu["series"];
    List<Serie> series = [];
    tempSeries.forEach((el) => series.add(Serie.fromJson(el)));

    List<dynamic> tempSessions = newMenu["sessions"];
    List<Session> sessions = [];
    tempSessions.forEach((el) => sessions.add(Session.fromJson(el)));

    menu = Menu(
        annees: annees,
        auteurs: auteurs,
        destinations: destinations,
        notions: notions,
        series: series,
        sessions: sessions);

    notifyListeners();
  }
}
