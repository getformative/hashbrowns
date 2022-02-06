# Hashbrowns Static Color Generator

The purpose of Hashbrowns is to generate consistent colors based on the hashcode of an object.

## Usage

```dart
class Genre {
  String name;
  Genre(this.name);
}

class GenrePill extends StatelessWidget {
  final Genre genre;
  late final Hashbrowns hashbrowns;
  GenrePill(this.genre) {
    this.hashbrowns = Hashbrowns.pastels();
  };

  @override
  Widget build(BuildContext context) {
    final color = hashbrowns.generateColor(genre);
    return Container(
      color: color.surfaceColor,
      child: Text(genre.name, style: TextStyle(color: color.onSurfaceColor))
    );
  }
}

```
