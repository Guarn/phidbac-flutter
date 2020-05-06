import 'package:phidbac/Components/SujetSimpleView.dart';
import 'package:phidbac/State/GlobalState.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:phidbac/Components/DownloadSujets.dart';
import 'package:phidbac/Components/SujetView.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => GlobalState(), child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, store, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Phidbac',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(94, 94, 94, 1),
          backgroundColor: Color.fromRGBO(233, 231, 225, 1),
          fontFamily: "CenturyGothic",
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => MainPage(),
          "/incompleteList": (context) =>
              SujetSimpleView(sujets: store.tempSujets),
          "/completeList": (context) => PageView(
                children: List.generate(store.tempSujets.length, (int index) {
                  return SujetView(
                    id: index,
                    sujet: store.tempSujets[index],
                    sujets: store.tempSujets,
                  );
                }),
                controller: PageController(initialPage: 0, keepPage: false),
              )
        },
      );
    });
  }
}

class MainPage extends StatefulWidget {
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  bool downloading = true;
  Widget _download = DownloadSujets();
  Widget _acc = Container(
    child: Consumer<GlobalState>(builder: (context, globalState, child) {
      return PageView(
        children: List.generate(globalState.sujets.length, (int index) {
          return SujetView(
            id: index,
            sujet: globalState.sujets[index],
            sujets: globalState.sujets,
          );
        }),
        controller: PageController(initialPage: 0, keepPage: false),
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(builder: (context, globalState, child) {
      return AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: globalState.sujets.length > 0
              ? Scaffold(body: _acc)
              : Scaffold(body: _download));
    });
  }
}
