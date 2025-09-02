class Portrait {
  final String id;
  final String name;
  final String species;
  final List<String> tags;
  final String imageUrl;
  final String date;

  const Portrait({
    required this.id,
    required this.name,
    required this.species,
    required this.tags,
    required this.imageUrl,
    required this.date,
  });

  factory Portrait.fromJson(Map<String, dynamic> j) => Portrait(
    id: j['id'] as String,
    name: j['name'] as String,
    species: j['species'] as String,
    tags: List<String>.from(j['tags'] as List),
    imageUrl: j['imageUrl'] as String,
    date: j['date'] as String,
  );
}
