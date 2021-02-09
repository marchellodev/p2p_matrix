import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2p_model/components/buttons.dart';

class HistoryModel {}

class HistoryModelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onPressed: (){},
      scale: ScaleFormat.small,
      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    'модель_1',
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade800, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(6)),
                  ),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    'kademlia_dht',
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade800, fontSize: 12),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blueGrey.shade200),
                  padding: const EdgeInsets.all(4.8),
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    '14/01/2021',
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade700, fontSize: 10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
