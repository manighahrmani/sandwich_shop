enum BreadType { white, wheat, wholemeal }

class Sandwich {
  final String name;
  final bool isFootlong;
  final BreadType breadType;
  final String image;

  Sandwich({
    required this.name,
    required this.isFootlong,
    required this.breadType,
    required this.image,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (image.isEmpty || !image.startsWith('assets/images/')) {
      throw ArgumentError('Image must be a valid asset path');
    }
  }
}
