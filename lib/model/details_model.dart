class DetailsModel {
  String id;
  int created_at;
  int updated_at;
  String merchant_id;
  String name;
  String description;
  int price;
  int stok;
  Map<String, dynamic> main_image;
  List<dynamic>? images;
  String categories;

  DetailsModel(
      {required this.id,
        required this.created_at,
        required this.updated_at,
        required this.merchant_id,
        required this.name,
        required this.description,
        required this.price,
        required this.stok,
        required this.main_image,
        required this.images,
        required this.categories});

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
        id: json['id'],
        created_at: json['created_at'],
        updated_at: json['updated_at'],
        merchant_id: json['merchant']['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        stok: json['stock'],
        main_image: json['main_image'],
        images: json['images'],
        categories: "tanaman liar");
  }
}
