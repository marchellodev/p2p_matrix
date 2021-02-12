import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:p2p_matrix/components/buttons.dart';
import 'package:p2p_matrix/log.dart';
import 'package:p2p_matrix/models/pmodel.dart';
import 'package:p2p_matrix/models/script.dart';
import 'package:p2p_matrix/screens/script_create.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'models/pings.dart';

Pings pings;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
  FlutterError.onError = (FlutterErrorDetails details) {
    llog('-- ERROR 2 -- ');

    llog(details.exception.toString());
    llog(details.stack.toString());
  };

  runZoned(() async {
    runApp(MyApp()); // starting point of app
  }, onError: (error, stackTrace) {
    llog('-- ERROR -- ');

    llog(error.toString());
    llog(stackTrace.toString());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, widget) => ResponsiveWrapper.builder(widget,
          // maxWidth: 1200,

          defaultScaleFactor: 1.4
          // breakpoints: [
          //   ResponsiveBreakpoint.resize(480, name: MOBILE),
          //   ResponsiveBreakpoint.autoScale(800, name: TABLET),
          //   ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          // ]
          ),
      theme: ThemeData(brightness: Brightness.dark),
      home: AppLoader(),
    );
  }
}

class AppLoader extends StatefulWidget {
  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool loaded = false;

  @override
  void initState() {
    () async {
      Hive.init('storage');
      Hive.registerAdapter(PModelAdapter());
      await Hive.openBox<PModel>('models');

      pings = await Pings.loadFromAssets(context);

      File('storage/log.txt').create(recursive: true);

      llog('App has launched');

      setState(() {
        loaded = true;
      });

      // final files = ;
      //
      // files.listen((event) async {
      //   if (event.path.split('.').last == 'json') {
      //     print(event.path);
      //     final f = await File(event.path).readAsString();
      //     scripts
      //         .add(ScriptModel.fromJson(jsonDecode(f) as Map<String, dynamic>));
      //   }
      // });
    }.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return App();
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<ScriptModel> scripts = <ScriptModel>[];
  List<PModel> models = <PModel>[];

  void loadScripts() {
    final files = Directory('storage').list();
    scripts = [];
    files.listen((event) async {
      if (event.path.split('.').last == 'json') {
        print(event.path);
        final f = await File(event.path).readAsString();
        setState(() {
          scripts
              .add(ScriptModel.fromJson(jsonDecode(f) as Map<String, dynamic>));
        });
      }
    });
  }

  void loadModels() {
    setState(() {
      models = Hive.box<PModel>('models').values.toList();
    });
  }

  @override
  void initState() {
    loadScripts();
    loadModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(scripts.length);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blueGrey.shade900,
                  Colors.blueGrey.shade800
                ])),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    _RowHeader('Сценарії', () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ScriptCreateScreen()));
                      loadScripts();
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                        child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: scripts.length,
                      itemBuilder: (ctx, el) =>
                          ScriptModelCard(scripts[el], () {
                        File('storage/${scripts[el].name}.json').deleteSync();
                        loadScripts();
                      }),
                    ))
                  ],
                )),
                Container(
                  width: 2,
                  color: Colors.blueGrey.shade700,
                ),
                Expanded(
                    child: Column(
                  children: [
                    _RowHeader('Моделі', () async {
                      final typeGroup = XTypeGroup(extensions: ['dll']);
                      final file =
                          await openFile(acceptedTypeGroups: [typeGroup]);

                      Hive.box<PModel>('models').add(PModel(
                          path: file.path,
                          lastModified: await file.lastModified(),
                          size: double.parse((await file.length() / 1000000)
                              .toStringAsFixed(4))));

                      loadModels();
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                        child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: models.length,
                      itemBuilder: (ctx, el) =>
                          PModelCard(models[el], () async {
                        await Hive.box<PModel>('models').deleteAt(el);
                        loadModels();
                      }),
                    ))
                  ],
                )),
                Container(
                  width: 2,
                  color: Colors.blueGrey.shade700,
                ),
                Expanded(
                    child: Column(
                  children: const [
                    _RowHeader('Історія', null),
                    SizedBox(
                      height: 12,
                    ),
                    // HistoryModelCard(),
                    // HistoryModelCard(),
                  ],
                )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 42,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ScalableButton(
                    scale: ScaleFormat.big,
                    onPressed: () {
                      Process.run('explorer.exe', ['storage\\log.txt']);
                    },
                    child: Text(
                      '> відкрити лог',
                      style: GoogleFonts.rubik(
                          fontSize: 12, color: Colors.blueGrey.shade900),
                    ),
                  ),
                  ScalableButton(
                    scale: ScaleFormat.big,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          '9a1d81b',
                          style: GoogleFonts.rubik(
                              fontSize: 12, color: Colors.blueGrey.shade700),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        SvgPicture.asset('assets/icons/icon_github.svg')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RowHeader extends StatelessWidget {
  final String text;
  final Function() onClick;

  const _RowHeader(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 76,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF5F5F5),
                ),
              ),
              if (onClick != null)
                ScalableButton(
                  scale: ScaleFormat.big,
                  onPressed: onClick,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.shade700..withOpacity(0.6)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset('assets/icons/icon_add.svg'),
                  ),
                )
            ],
          ),
        ),
        Container(
          height: 1.2,
          color: Colors.blueGrey.shade800,
        ),
      ],
    );
  }
}
