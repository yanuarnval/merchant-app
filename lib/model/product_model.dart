class ProductModel {
  String id;
  String name;
  String description;
  int price;
  String imagesModel;
  int stock;

  ProductModel(
      {required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.imagesModel,
        required this.stock});

  factory ProductModel.fromJson(Map<String, dynamic> object) {
    return ProductModel(
        id: object['id'],
        name: object['name'],
        description: object['description'],
        price: object['price'],
        imagesModel: object['main_image']['url'],
        stock: object['stock']);
  }
}
