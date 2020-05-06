import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phidbac/Class/Sujet.dart';
import 'package:phidbac/State/GlobalState.dart';
import 'package:provider/provider.dart';

class DownloadSujets extends StatefulWidget {
  _DownloadSujets createState() => _DownloadSujets();
}

class _DownloadSujets extends State<DownloadSujets> {
  int downloaded = 0;
  int finalValue = 4038440;
  Future<List<dynamic>> listeSujets;
  Future<List<dynamic>> listeMenu;

  void getSujets() async {
    Dio dio = Dio();
    final menu = await dio.get(
      "https://www.phidbac.fr:4000/menu/",
    );
    final sujets = await dio.get("https://www.phidbac.fr:4000/sujets/",
        onReceiveProgress: (a, b) {
      setState(() {
        downloaded = a;
      });
    });

    List<Sujet> liste = [];
    await sujets.data.forEach((el) => liste.add(Sujet.fromJson(el)));

    Provider.of<GlobalState>(context, listen: false).setSujets(liste);
    Provider.of<GlobalState>(context, listen: false)
        .setMenu(menu.data as Map<String, dynamic>);
  }

  @override
  void initState() {
    super.initState();
    getSujets();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).backgroundColor,
          systemNavigationBarIconBrightness:
              Brightness.dark // navigation bar color
          // navigation bar color
          ),
    );

    return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(226, 224, 216, 1),
        child: Align(
            alignment: Alignment.center,
            child: Column(children: [
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Image.asset("assets/background.png"))),
              Divider(
                color: Colors.transparent,
              ),
              Container(
                  child: Text(
                "Récupération de la liste de sujets",
                style: TextStyle(fontFamily: "CenturyGothic"),
                textAlign: TextAlign.center,
              )),
              Divider(
                color: Colors.transparent,
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 10,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: downloaded / finalValue,
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.05),
                  ))
            ])));
  }
}
