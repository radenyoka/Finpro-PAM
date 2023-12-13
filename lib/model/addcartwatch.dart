import 'package:hive/hive.dart';

part 'addcartwatch.g.dart';

@HiveType(typeId: 0)
class AddCartWatch extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String thumbnail;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  AddCartWatch({
    required this.title,
    required this.thumbnail,
    required this.rating,
    required this.price,
    required this.description,
  });
}
