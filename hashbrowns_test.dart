import "package:test/test.dart";
import "package:hashbrowns/hashbrowns.dart";
import "package:flutter/material.dart";

void main() {
  const HELLO_WORLD_HASH = 847757641;
  test(
      "The hash of the string 'Hello, World!' (847757641) should generate an HSL value of ...",
      () {
    final hashbrown = Hashbrown.pastels();
    expect(hashbrown.generateColor(HELLO_WORLD_HASH), equals(Colors.white));
  });
}
