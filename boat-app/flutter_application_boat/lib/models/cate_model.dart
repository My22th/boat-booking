class CategoryBoat {
  String id;
  int categoryId;
  String name;
  double categoryPrice;
  double categoryVolume;
  String lat;
  String long;
  String title;
  String description;
  List<String> lstImgURL;
  BoatType type;
  int capacity;
  double pricePerDay;

  CategoryBoat({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.categoryPrice,
    required this.categoryVolume,
    required this.lat,
    required this.long,
    required this.title,
    required this.description,
    required this.lstImgURL,
    required this.type,
    required this.capacity,
    required this.pricePerDay,
  });
}

class BoatType {
  int id;
  String name;

  BoatType({
    required this.id,
    required this.name,
  });
}
