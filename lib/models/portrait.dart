class Portrait {
  final String id;
  final String slug;
  final String? name;
  final String species;
  final List<String> tags;
  final String? date;
  final String image;
  final String? thumb;
  final String? location;
  final String? credit;

  Portrait({
    required this.id,
    required this.slug,
    this.name,
    required this.species,
    required this.tags,
    this.date,
    required this.image,
    this.thumb,
    this.location,
    this.credit,
  });

  factory Portrait.fromJson(Map<String, dynamic> json) {
    return Portrait(
      id: json['id'] as String,
      slug: json['slug'] ?? '',
      name: json['name'] as String?,
      species: json['species'] as String,
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      date: json['date'] as String?,
      image: json['image'] as String,
      thumb: json['thumb'] as String?,
      location: json['location'] as String?,
      credit: json['credit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'species': species,
      'tags': tags,
      'date': date,
      'image': image,
      'thumb': thumb,
      'location': location,
      'credit': credit,
    };
  }
}
