import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phidbac/Class/Menu.dart';
import 'package:phidbac/Class/Sujet.dart';
import 'package:phidbac/Components/RechercheBis.dart';
import 'package:phidbac/Components/SujetView.dart';

class SujetSimpleView extends StatefulWidget {
  SujetSimpleView({
    Key key,
    @required this.sujets,
  }) : super(key: key);
  final List<SujetSimple> sujets;

  @override
  _SujetSimpleView createState() => _SujetSimpleView();
}

class _SujetSimpleView extends State<SujetSimpleView> {
  String getSujet(NumSujet numSujet, int index) {
    switch (numSujet) {
      case NumSujet.sujet1:
        return widget.sujets[index].sujet1;
      case NumSujet.sujet2:
        return widget.sujets[index].sujet2;
      case NumSujet.sujet3:
        return widget.sujets[index].sujet3;
      case NumSujet.notDefined:
        return "Not defined.";
    }
  }

  List<dynamic> getNotions(NumSujet numSujet, int index) {
    switch (numSujet) {
      case NumSujet.sujet1:
        return widget.sujets[index].notions1;
      case NumSujet.sujet2:
        return widget.sujets[index].notions2;
      case NumSujet.sujet3:
        return widget.sujets[index].notions3;
      case NumSujet.notDefined:
        return ["Not defined."];
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).backgroundColor,
        systemNavigationBarIconBrightness:
            Brightness.dark // navigation bar color
        ));
    return Scaffold(
        floatingActionButton: FiltresButton(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
            children: List.generate(widget.sujets.length, (int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return SujetView(
                    id: widget.sujets[index].id,
                    sujet: widget.sujets[index],
                  );
                }));
              },
              child: Hero(
                  tag:
                      "${widget.sujets[index].id}-enonce-${widget.sujets[index].numSujet.toString().substring(14)}",
                  child: Material(
                      type: MaterialType.transparency,
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          alignment: Alignment.topLeft,
                          child: Enonce(
                            numSujet: widget.sujets[index].numSujet,
                            notions: getNotions(
                                widget.sujets[index].numSujet, index),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            getSujet(widget.sujets[index].numSujet, index),
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ]))));
        })));
  }
}

class Enonce extends StatelessWidget {
  Enonce({Key key, this.numSujet, this.notions}) : super(key: key);
  final NumSujet numSujet;
  final List<dynamic> notions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30, bottom: 8),
        child: Row(children: [
          Container(
            child: null,
            height: 1,
            width: 30,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Sujet ${numSujet.toString().substring(14)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor),
              )),
          Expanded(
              child: Container(
            child: null,
            height: 1,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          )),
          Container(
            child: null,
            height: 10,
            width: 1,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Container(
            child: Notions(
              notions: notions,
            ),
          ),
        ]));
  }
}

class Notions extends StatelessWidget {
  Notions({Key key, this.notions}) : super(key: key);
  final List<dynamic> notions;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(left: 5),
        child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 2,
            runSpacing: 2,
            direction: Axis.vertical,
            children: List.generate(notions.length, (index) {
              return Container(
                child: Text(notions[index],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    )),
                padding: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                )),
              );
            })));
  }
}
