import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String image_url;
  final String brand_name;
  final String package_name;
  final int price;
  final double rating;

  const Product(
      {required this.id,
      required this.name,
      required this.brand_name,
      required this.image_url,
      required this.package_name,
      required this.price,
      required this.rating});

   
   Map toJson() => {
    "id": id,
    "name": name,
    "image_url": image_url
   };


  factory Product.fromJson(Map<String,dynamic> json){
    return Product(
      id: json["id"],
      name: json["name"],
      brand_name: json["brand_name"],
      package_name: json["package_name"],
      price: json["price"],
      rating: json["rating"],
      image_url: json["image_url"]
    );
  }    

  @override
  List<Object?> get props => [
    id,
    name,
    image_url,
    brand_name,
    package_name,
    price,
    rating
  ];
}
