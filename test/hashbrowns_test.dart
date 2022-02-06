import 'package:flutter_test/flutter_test.dart';

import 'package:hashbrowns/hashbrowns.dart';

void main() {
  test('Consistent surface color returned for "Hello, World!" string', () {
    const helloWorld = "Hello, World!";
    final factories = [Hashbrown.bold, Hashbrown.pastels];

    for (final hashbrownFactory in factories) {
      final hashbrowns = hashbrownFactory();
      final firstPassGeneration = hashbrowns.generateColor(helloWorld.hashCode);
      final secondPassGeneration =
          hashbrowns.generateColor(helloWorld.hashCode);
      expect(firstPassGeneration.surfaceColor.value,
          equals(secondPassGeneration.surfaceColor.value));
    }
  });
}
