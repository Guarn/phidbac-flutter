class Menu {
  final List<Annee> annees;
  final List<Auteur> auteurs;
  final List<Destination> destinations;
  final List<Notion> notions;
  final List<Session> sessions;
  final List<Serie> series;

  Menu(
      {this.notions,
      this.annees,
      this.auteurs,
      this.destinations,
      this.series,
      this.sessions});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      annees: json["annees"],
      auteurs: json['auteurs'],
      destinations: json['destinations'],
      notions: json['notions'],
      sessions: json['sessions'],
      series: json['series'],
    );
  }
}

class Annee {
  final int annee;
  final bool menu;

  Annee({this.annee, this.menu});

  factory Annee.fromJson(Map<String, dynamic> json) {
    return Annee(annee: json["Annee"], menu: json["menu"]);
  }
}

class Auteur {
  final int nbSujets;
  final String name;
  final bool menu;

  Auteur({this.nbSujets, this.menu, this.name});

  factory Auteur.fromJson(Map<String, dynamic> json) {
    return Auteur(
        name: json["Auteur"], menu: json["menu"], nbSujets: json["NbSujets"]);
  }
}

class Destination {
  final String name;
  final bool menu;

  Destination({
    this.name,
    this.menu,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json["Destination"],
      menu: json["menu"],
    );
  }
}

class Notion {
  final String name;

  Notion({
    this.name,
  });

  factory Notion.fromJson(Map<String, dynamic> json) {
    return Notion(
      name: json["Notion"],
    );
  }
}

class Serie {
  final String name;
  final bool menu;

  Serie({this.name, this.menu});

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      name: json["Serie"],
      menu: json["menu"],
    );
  }
}

class Session {
  final String name;
  final bool menu;

  Session({this.name, this.menu});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      name: json["Session"],
      menu: json["menu"],
    );
  }
}
