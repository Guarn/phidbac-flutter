import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phidbac/Class/Filtres.dart';
import 'package:phidbac/Class/Sujet.dart';
import 'package:phidbac/Components/SujetSimpleView.dart';
import 'package:phidbac/State/GlobalState.dart';
import 'package:provider/provider.dart';

class RechercheBis extends StatefulWidget {
  _RechercheBis createState() => _RechercheBis();
}

class _RechercheBis extends State<RechercheBis> {
  TextEditingController _controller;
  RangeValues tempAnnees = RangeValues(1996, 2019);
  Widget DropShadow() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 1.0, // has the effect of softening the shadow
          )
        ],
      ),
      child: Divider(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        thickness: 1,
      ),
    );
  }

  Widget TextChoice(String text, bool selected) {
    return Container(
      height: 50,
      width: (MediaQuery.of(context).size.width - 60) / 3,
      decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.transparent,
          border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.2))),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
          color: !selected
              ? Theme.of(context).primaryColor
              : Theme.of(context).backgroundColor,
        ),
        textAlign: TextAlign.center,
      )),
    );
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  bool compareLists(List<dynamic> completeList, List<String> partialList) {
    if (partialList.length == 0) {
      return false;
    }
    for (int i = 0; i < partialList.length; i++) {
      if (!completeList.contains(partialList[i])) {
        return false;
      }
    }
    return true;
  }

  bool compareListsInclusive(
      List<dynamic> completeList, List<String> partialList) {
    for (int i = 0; i < partialList.length; i++) {
      if (completeList.contains(partialList[i])) {
        return true;
      }
    }
    return false;
  }

  recalculateResults() {
    List<SujetSimple> tempListe = [];
    GlobalState store = Provider.of<GlobalState>(context, listen: false);
    List<Sujet> sujets = store.sujets;
    Filtres filtres = store.filtres;

    if (filtres.recherche == "") {
      NumSujet numSujet;
      for (int i = 0; i < sujets.length; i++) {
        numSujet = NumSujet.notDefined;
        if (filtres.notions.length == 0 ||
            (compareLists(sujets[i].notions1, filtres.notions) ||
                compareLists(sujets[i].notions2, filtres.notions) ||
                compareLists(sujets[i].notions3, filtres.notions))) {
          if (compareLists(sujets[i].notions1, filtres.notions)) {
            numSujet = NumSujet.sujet1;
          }
          if (compareLists(sujets[i].notions2, filtres.notions)) {
            numSujet = NumSujet.sujet2;
          }
          if (compareLists(sujets[i].notions3, filtres.notions)) {
            numSujet = NumSujet.sujet3;
          }

          if (filtres.series.length == 0 ||
              compareListsInclusive([sujets[i].serie], filtres.series)) {
            if (filtres.destinations.length == 0 ||
                compareListsInclusive(
                    sujets[i].destination, filtres.destinations)) {
              if (sujets[i].annee <= filtres.annees.end.toInt() &&
                  sujets[i].annee >= filtres.annees.start.toInt()) {
                if (filtres.auteurs.length > 0 &&
                    compareListsInclusive(
                        [sujets[i].auteur], filtres.auteurs)) {
                  tempListe
                      .add(SujetSimple.fromSujet(sujets[i], NumSujet.sujet3));
                  numSujet = NumSujet.notDefined;
                } else {
                  if (filtres.auteurs.length == 0) {
                    tempListe.add(SujetSimple.fromSujet(sujets[i], numSujet));
                  }
                }
              }
            }
          }
        }
      }
    } else {
      for (int i = 0; i < sujets.length; i++) {
        if (filtres.notions.length == 0 ||
            (compareLists(sujets[i].notions3, filtres.notions))) {
          if (filtres.series.length == 0 ||
              compareListsInclusive([sujets[i].serie], filtres.series)) {
            if (filtres.destinations.length == 0 ||
                compareListsInclusive(
                    sujets[i].destination, filtres.destinations)) {
              if (sujets[i].annee <= filtres.annees.end.toInt() &&
                  sujets[i].annee >= filtres.annees.start.toInt()) {
                if (filtres.auteurs.length == 0 ||
                    compareListsInclusive(
                        [sujets[i].auteur], filtres.auteurs)) {
                  if (filtres.typeRecherche == TypeRecherche.exacte &&
                      filtres.recherche != "") {
                    if (sujets[i].sujet3.contains(
                        new RegExp(filtres.recherche, caseSensitive: false))) {
                      tempListe.add(
                          SujetSimple.fromSujet(sujets[i], NumSujet.sujet3));
                    }
                  }
                  if (filtres.typeRecherche == TypeRecherche.unDesMots &&
                      filtres.recherche != "") {
                    List<String> motsRecherche = filtres.recherche.split(" ");
                    bool found = false;
                    motsRecherche.forEach((el) {
                      if (sujets[i].sujet3.contains(el)) {
                        found = true;
                      }
                    });
                    if (found) {
                      tempListe.add(
                          SujetSimple.fromSujet(sujets[i], NumSujet.sujet3));
                    }
                  }
                  if (filtres.typeRecherche == TypeRecherche.tousLesMots &&
                      filtres.recherche != "") {
                    List<String> motsRecherche = filtres.recherche.split(" ");
                    bool found = false;
                    bool found2 = true;
                    motsRecherche.forEach((el) {
                      if (sujets[i].sujet3.contains(el)) {
                        found = true;
                      } else {
                        found2 = false;
                      }
                    });
                    if (found && found2) {
                      tempListe.add(
                          SujetSimple.fromSujet(sujets[i], NumSujet.sujet3));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    Provider.of<GlobalState>(context, listen: false).setTempSujets(tempListe);
  }

  _goDetailsAndBack(
      BuildContext context, FiltersTypes type, liste, isAuthor) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SousMenu(
                  type: type,
                  liste: liste,
                  isAuthor: isAuthor,
                )));
    recalculateResults();
  }

  getLeftPadding(double start) {
    var step = (MediaQuery.of(context).size.width - 60) / (2019 - 1993);
    return (start - 1996) * step;
  }

  getRightPadding(double end) {
    var step = (MediaQuery.of(context).size.width - 60) / (2019 - 1993);
    return (2019 - end) * step;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).backgroundColor,
        systemNavigationBarIconBrightness:
            Brightness.dark // navigation bar color
        ));
    return Scaffold(
      body: Consumer<GlobalState>(builder: (context, store, child) {
        return Container(
            margin: EdgeInsets.only(top: 10),
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                DropShadow(),
                GestureDetector(
                    onTap: () => _goDetailsAndBack(context,
                        FiltersTypes.notions, store.menu.notions, false),
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 20, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: store.filtres.notions.length == 0
                                ? <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Toutes les ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20,
                                                fontFamily: "CenturyGothic"),
                                            children: [
                                          TextSpan(
                                              text: "Notions",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                    Text(
                                      "Choisir",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]
                                : [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Wrap(
                                          spacing: 4,
                                          children: List.generate(
                                              store.filtres.notions.length,
                                              (int index) {
                                            return Text(
                                                store.filtres.notions[index]);
                                          }),
                                        )),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          store.filtres.notions = [];
                                          recalculateResults();
                                        },
                                        icon: Icon(Icons.replay),
                                      ),
                                    )
                                  ],
                          )),
                    )),
                DropShadow(),
                GestureDetector(
                    onTap: () => _goDetailsAndBack(
                        context, FiltersTypes.series, store.menu.series, false),
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 20, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: store.filtres.series.length == 0
                                ? <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Toutes les ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20,
                                                fontFamily: "CenturyGothic"),
                                            children: [
                                          TextSpan(
                                              text: "Séries",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                    Text(
                                      "Choisir",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]
                                : [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Wrap(
                                          spacing: 4,
                                          children: List.generate(
                                              store.filtres.series.length,
                                              (int index) {
                                            return Text(
                                                store.filtres.series[index]);
                                          }),
                                        )),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          store.filtres.series = [];
                                          recalculateResults();
                                        },
                                        icon: Icon(Icons.replay),
                                      ),
                                    )
                                  ],
                          )),
                    )),
                DropShadow(),
                GestureDetector(
                    onTap: () => _goDetailsAndBack(
                        context,
                        FiltersTypes.destinations,
                        store.menu.destinations,
                        false),
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 20, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: store.filtres.destinations.length == 0
                                ? <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Toutes les ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20,
                                                fontFamily: "CenturyGothic"),
                                            children: [
                                          TextSpan(
                                              text: "Destinations",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                    Text(
                                      "Choisir",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]
                                : [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Wrap(
                                          spacing: 4,
                                          children: List.generate(
                                              store.filtres.destinations.length,
                                              (int index) {
                                            return Text(store
                                                .filtres.destinations[index]);
                                          }),
                                        )),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          store.filtres.destinations = [];
                                          recalculateResults();
                                        },
                                        icon: Icon(Icons.replay),
                                      ),
                                    )
                                  ],
                          )),
                    )),
                DropShadow(),
                GestureDetector(
                    onTap: () => _goDetailsAndBack(context,
                        FiltersTypes.auteurs, store.menu.auteurs, true),
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 20, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: store.filtres.auteurs.length == 0
                                ? <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Tous les ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20,
                                                fontFamily: "CenturyGothic"),
                                            children: [
                                          TextSpan(
                                              text: "Auteurs",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                    Text(
                                      "Choisir",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]
                                : [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Wrap(
                                          spacing: 4,
                                          children: List.generate(
                                              store.filtres.auteurs.length,
                                              (int index) {
                                            return Text(
                                                store.filtres.auteurs[index]);
                                          }),
                                        )),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          store.filtres.auteurs = [];
                                          recalculateResults();
                                        },
                                        icon: Icon(Icons.replay),
                                      ),
                                    )
                                  ],
                          )),
                    )),
                DropShadow(),
                Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Column(children: [
                        Text(
                          "Années",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "CenturyGothic",
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                              valueIndicatorColor: Colors.black,
                              showValueIndicator: ShowValueIndicator.always),
                          child: RangeSlider(
                            divisions: 2019 - 1996,
                            labels: RangeLabels(
                                store.filtres.annees.start.toInt().toString(),
                                store.filtres.annees.end.toInt().toString()),
                            activeColor:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            inactiveColor:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            values: store.areFiltersSet()
                                ? store.getFiltre(FiltersTypes.annees)
                                : RangeValues(1996, 2019),
                            onChanged: (RangeValues val) {
                              store.setAnnees(val);
                              setState(() {});
                            },
                            onChangeEnd: (RangeValues val) {
                              store.setAnnees(val);
                              recalculateResults();
                            },
                            min: 1996,
                            max: 2019,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: getLeftPadding(store.filtres.annees.start),
                              right: getRightPadding(store.filtres.annees.end)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(store.filtres.annees.start
                                  .toInt()
                                  .toString()),
                              Text(store.filtres.annees.end.toInt().toString())
                            ],
                          ),
                        )
                      ])),
                ),
                DropShadow(),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Recherche par ",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontFamily: "CenturyGothic"),
                                  children: [
                                TextSpan(
                                    text: "expression",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ])),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(0, 0, 0, .2))),
                            child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.text,
                                onChanged: (String val) {
                                  store.filtres.recherche = val;
                                  recalculateResults();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Un ou plusieurs mots, expression')),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
                                        store.filtres.typeRecherche =
                                            TypeRecherche.exacte;
                                        recalculateResults();
                                      },
                                      child: TextChoice(
                                          "Expression exacte",
                                          store.filtres.typeRecherche ==
                                              TypeRecherche.exacte)),
                                  GestureDetector(
                                      onTap: () {
                                        store.filtres.typeRecherche =
                                            TypeRecherche.unDesMots;
                                        recalculateResults();
                                      },
                                      child: TextChoice(
                                          "Un des mots",
                                          store.filtres.typeRecherche ==
                                              TypeRecherche.unDesMots)),
                                  GestureDetector(
                                      onTap: () {
                                        store.filtres.typeRecherche =
                                            TypeRecherche.tousLesMots;
                                        recalculateResults();
                                      },
                                      child: TextChoice(
                                          "Tous les mots",
                                          store.filtres.typeRecherche ==
                                              TypeRecherche.tousLesMots)),
                                ],
                              ))
                        ])),
                GestureDetector(
                    onTap: () {
                      if (!store.areFiltersSet()) {
                        Navigator.pushNamed(context, "/");
                      } else {
                        if (store.tempSujets[0].numSujet !=
                            NumSujet.notDefined) {
                          Navigator.pushNamed(context, "/incompleteList");
                        } else {
                          Navigator.pushNamed(context, "/completeList");
                        }
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 35, bottom: 35),
                        child: Center(
                            child: RichText(
                                text: TextSpan(
                                    text: "Voir les ",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 3.0,
                                            color: Color.fromRGBO(0, 0, 0, 0.2),
                                          ),
                                        ],
                                        fontFamily: "CenturyGothic"),
                                    children: [
                              TextSpan(
                                  text: store.areFiltersSet()
                                      ? store.tempSujets.length.toString()
                                      : store.sujets.length.toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: " résultats",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontFamily: "CenturyGothic"))
                            ]))))),
                GestureDetector(
                    onTap: () {
                      store.reset();
                      _controller.clear();
                    },
                    child: Center(
                      child: Text(
                        "Réinitialiser les filtres",
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      ),
                    ))
              ],
            ));
      }),
    );
  }
}

class SousMenu extends StatefulWidget {
  final FiltersTypes type;
  final List<dynamic> liste;
  final bool isAuthor;
  SousMenu(
      {Key key,
      @required this.type,
      @required this.liste,
      @required this.isAuthor})
      : super(key: key);
  _SousMenu createState() => _SousMenu();
}

class _SousMenu extends State<SousMenu> {
  @override
  Widget build(BuildContext context) {
    void setSelected(String val) {
      Provider.of<GlobalState>(context, listen: false)
          .addRemoveToFilter(widget.type, val);
    }

    return Scaffold(
        body: Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(15),
            child: Consumer<GlobalState>(
              builder: (context, store, child) {
                return ListView(
                  children: <Widget>[
                    Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            List.generate(widget.liste.length, (int index) {
                          return GestureDetector(
                              onTap: () =>
                                  setSelected(widget.liste[index].name),
                              child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: store
                                              .getFiltre(widget.type)
                                              .contains(
                                                  widget.liste[index].name)
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: Text(
                                    widget.liste[index].name +
                                        (widget.isAuthor
                                            ? " (${widget.liste[index].nbSujets})"
                                            : ""),
                                    style: TextStyle(
                                        color: store
                                                .getFiltre(widget.type)
                                                .contains(
                                                    widget.liste[index].name)
                                            ? Theme.of(context).backgroundColor
                                            : Theme.of(context).primaryColor),
                                  )));
                        })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            child: IconButton(
                                icon: Icon(Icons.replay, color: Colors.red),
                                onPressed: () {
                                  Provider.of<GlobalState>(context,
                                          listen: false)
                                      .reset();
                                })),
                        Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            child: IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  Navigator.pop(context);
                                }))
                      ],
                    )
                  ],
                );
              },
            )));
  }
}
