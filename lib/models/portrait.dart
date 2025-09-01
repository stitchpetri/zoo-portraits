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
}
