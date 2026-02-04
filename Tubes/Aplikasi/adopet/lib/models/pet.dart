class Pet {
  final String? id;
  final String name;
  final String age;
  final String breed;
  final String description;
  final String imageUrl;

  Pet({
    this.id,
    required this.name,
    required this.age,
    required this.breed,
    required this.description,
    required this.imageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      age: json['age']?.toString() ?? '',
      breed: json['breed'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'breed': breed,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  Pet copyWith({
    String? id,
    String? name,
    String? age,
    String? breed,
    String? description,
    String? imageUrl,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      breed: breed ?? this.breed,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
