class MenuItemModel {
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  double? price;

  MenuItemModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
  });

  factory MenuItemModel.fromMap(map) {
    return MenuItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
