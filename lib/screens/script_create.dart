import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2p_model/components/buttons.dart';

class ScriptCreateScreen extends StatelessWidget {
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
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Кількість операцій (читання/запису)',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Мінімальна кількість пірів в мережі',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.rubik(fontSize: 12),
                          decoration: const InputDecoration(
                              labelText: 'Мінімальний розмір файлу (МБ)',
                              border: OutlineInputBorder()))),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                      child: TextField(
                          keyboardType: TextInputType.number,
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.cyan.shade700,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Зегенерувати',
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
