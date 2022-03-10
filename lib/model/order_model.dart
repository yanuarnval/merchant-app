class OrderModel {
  String id;
  String name;
  String description;
  int price;
  String imagesModel;
  int stock;
  Map<String, dynamic> address;

  OrderModel(this.id, this.name, this.description, this.price, this.imagesModel,
      this.stock, this.address);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        json['id'],
        json['name'],
        json['description'],
        json['price'],
        json['main_image']['url'],
        json['quantity'],
        json['address']);
  }
}
