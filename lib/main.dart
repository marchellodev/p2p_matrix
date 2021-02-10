import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2p_model/components/buttons.dart';
import 'package:p2p_model/models/pmodel.dart';
import 'package:p2p_model/models/script.dart';
import 'package:p2p_model/screens/script_create.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'models/history.dart';

void main() {
  runApp(MyApp());
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
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    _RowHeader('Сценарії', () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ScriptCreateScreen()));
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    ScriptModelCard(),
                    ScriptModelCard(),
                    ScriptModelCard(),
                  ],
                )),
                Container(
                  width: 2,
                  color: Colors.blueGrey.shade700,
                ),
                Expanded(
                    child: Column(
                  children: [
                    _RowHeader('Моделі', () {}),
                    const SizedBox(
                      height: 12,
                    ),
                    PModelCard(),
                    PModelCard(),
                    PModelCard(),
                  ],
                )),
                Container(
                  width: 2,
                  color: Colors.blueGrey.shade700,
                ),
                Expanded(
                    child: Column(
                  children: [
                    _RowHeader('Історія', null),
                    const SizedBox(
                      height: 12,
                    ),
                    HistoryModelCard(),
                    HistoryModelCard(),
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
                    onPressed: () {},
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
