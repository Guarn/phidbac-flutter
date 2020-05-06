import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phidbac/Class/Menu.dart';
import 'package:phidbac/Class/Sujet.dart';
import 'package:phidbac/Components/RechercheBis.dart';

class SujetView extends StatefulWidget {
  SujetView({
    Key key,
    this.id,
    this.sujet,
    this.sujets,
    this.menu,
  }) : super(key: key);
  final int id;
  final Sujet sujet;
  final List<Sujet> sujets;
  final Menu menu;

  @override
  _SujetView createState() => _SujetView();
}

class _SujetView extends State<SujetView> {
  ScrollController controller;
  bool isAtStart = true;

  Future<List<Sujet>> tempSujets;

  getNotions(int index) {
    switch (index) {
      case 0:
        return widget.sujet.notions1;
        break;
      case 1:
        return widget.sujet.notions2;
        break;
      case 2:
        return widget.sujet.notions3;
        break;
    }
  }

  getTexte(int index) {
    switch (index) {
      case 0:
        return widget.sujet.sujet1;
        break;
      case 1:
        return widget.sujet.sujet2;
        break;
      case 2:
        return widget.sujet.sujet3;
        break;
    }
  }

  List<Widget> generateSujet() {
    return List.generate(3, (int index) {
      return Hero(
          tag: "${widget.sujet.id}-enonce-${index + 1}",
          child: Material(
              color: Theme.of(context).backgroundColor,
              type: MaterialType.card,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.topLeft,
                  child: Enonce(
                    numSujet: index + 1,
                    notions: getNotions(index),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                      left: 15, right: 15, bottom: index == 2 ? 70 : 0),
                  child: Text(
                    getTexte(index),
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ])));
    });
  }

  Widget generateInfos() {
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: RichText(
              overflow: TextOverflow.visible,
              maxLines: 3,
              text: TextSpan(
                  text: "Sujet présenté en ",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                        text: widget.sujet.annee.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ('),
                    TextSpan(
                        text: widget.sujet.destination[0].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '), série '),
                    TextSpan(
                        text: widget.sujet.serie,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ', session '),
                    TextSpan(
                        text: widget.sujet.session,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '.'),
                  ]),
            )),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 2, left: 5),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.4)),
                ),
                child: Text(widget.sujet.code),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.4)),
                ),
                child: Text(widget.sujet.id.toString()),
              )
            ])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).backgroundColor,
        systemNavigationBarIconBrightness:
            Brightness.dark // navigation bar color
        ));
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Scaffold(
            floatingActionButton: FiltresButton(),
            backgroundColor: Theme.of(context).backgroundColor,
            body: ListView(children: [generateInfos(), ...generateSujet()])));
  }
}

class Enonce extends StatelessWidget {
  Enonce({Key key, this.numSujet, this.notions}) : super(key: key);
  final int numSujet;
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
                "Sujet $numSujet",
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

class FiltresButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return RechercheBis();
          }));
        },
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 2.0, // has the effect of extending the shadow
                )
              ],
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(0, 0, 0, 0.5),
              border:
                  Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.3))),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 9.0,
                top: 9.0,
                child: Icon(
                  Icons.search,
                  color: Colors.black54,
                  size: 37,
                ),
              ),
              Positioned(
                left: 9.0,
                top: 9.0,
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 35,
                ),
              )
            ],
          ),
        ));
  }
}
