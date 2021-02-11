import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2p_model/components/buttons.dart';
import 'package:p2p_model/models/script.dart';

class ScriptCreateScreen extends StatefulWidget {
  @override
  _ScriptCreateScreenState createState() => _ScriptCreateScreenState();
}

class _ScriptCreateScreenState extends State<ScriptCreateScreen> {
  final TextEditingController name = TextEditingController();

  final TextEditingController operations = TextEditingController();

  final TextEditingController nodesAmount = TextEditingController();

  final TextEditingController peersMin = TextEditingController();

  final TextEditingController peersMax = TextEditingController();

  final TextEditingController fileSizeMin = TextEditingController();

  final TextEditingController fileSizeMax = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade800])),
        child: Column(
          children: [
            Container(
              height: 76,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ScalableButton(
                      scale: ScaleFormat.big,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade50,
                        size: 20,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Створення сценарію',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF5F5F5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.2,
              color: Colors.blueGrey.shade800,
            ),
            const SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: operations,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Кількість операцій (читання/запису)',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          controller: nodesAmount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Кількість вузлів',
                              border: OutlineInputBorder()))),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: peersMin,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Мінімальна кількість пірів в мережі',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          controller: peersMax,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Максимальна кількість пірів в мережі',
                              border: OutlineInputBorder()))),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: fileSizeMin,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny('.')
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Мінімальний розмір файлу (МБ)',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          controller: fileSizeMax,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny('.')
                          ],
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Максимальний розмір файлу (МБ)',
                              border: OutlineInputBorder()))),
                ],
              ),
            ),
            const SizedBox(
              height: 38,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: name,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Назва сценарію',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: ScalableButton(
                    scale: ScaleFormat.small,
                    onPressed: loading
                        ? null
                        : () async {
                            if (name.text.isEmpty ||
                                operations.text.isEmpty ||
                                nodesAmount.text.isEmpty ||
                                peersMin.text.isEmpty ||
                                peersMax.text.isEmpty ||
                                fileSizeMin.text.isEmpty ||
                                fileSizeMax.text.isEmpty) {
                              return;
                            }
                            Dialogs.showLoadingDialog(
                                context, _keyLoader); //invoking login

                            () {
                              final nodes = ScriptModel.genNodes(
                                  int.parse(nodesAmount.text));

                              final files = ScriptModel.genFiles(
                                  int.parse(nodesAmount.text),
                                  double.parse(fileSizeMin.text),
                                  double.parse(fileSizeMax.text));

                              final model = ScriptModel(
                                  name: name.text,
                                  operations: int.parse(operations.text),
                                  nodesAmount: int.parse(nodesAmount.text),
                                  peersMin: int.parse(peersMin.text),
                                  peersMax: int.parse(peersMax.text),
                                  fileSizeMin: int.parse(fileSizeMin.text),
                                  fileSizeMax: int.parse(fileSizeMax.text),
                                  nodes: nodes,
                                  files: files,
                                  story: []);

                              print(model.toJson());
                            }.call();
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.of(_keyLoader.currentContext,
                                    rootNavigator: true)
                                .pop(); //close the dialoge

                            Navigator.pop(context);
                          },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.cyan.shade700,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Згенерувати',
                          style:
                              GoogleFonts.rubik(color: Colors.blueGrey.shade50),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(key: key, children: <Widget>[
                Center(
                  child: Column(children: const [
                    CircularProgressIndicator(),
                  ]),
                )
              ]));
        });
  }
}
