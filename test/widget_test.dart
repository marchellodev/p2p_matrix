// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:test/test.dart';

import 'package:p2p_matrix/models/script.dart';

void main() {
  test('storyGenTest', () async {
    final story = ScriptModel.genStory(100, 1000, 10, 60);
    for(final el in story){
      print(el.toJson());
    }
  });
}
