import 'package:flutter/material.dart';
import '../../models/portrait.dart';
import '../../data/portraits_seed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';
  final Set<String> activeTags = {};

  @override
  Widget build(BuildContext context) {
    final all = portraitsSeed;
    final tags = _collectTags(all);

    final filtered = all.where((p) {
      final q = query.trim().toLowerCase();
      final matchesText =
          q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.species.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
      final matchesTags =
          activeTags.isEmpty || activeTags.every((t) => p.tags.contains(t));
      return matchesText && matchesTags;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Zoo Portraits')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // If SearchBar gives an error, switch to a TextField (commented below)
            SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search by name, species, or tag…',
              onChanged: (v) => setState(() => query = v),
            ),
            // TextField fallback:
            // TextField(
            //   decoration: const InputDecoration(
            //     prefixIcon: Icon(Icons.search),
            //     hintText: 'Search by name, species, or tag…',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (v) => setState(() => query = v),
            // ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tags.map((t) {
                  final selected = activeTags.contains(t);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(t),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selected ? activeTags.remove(t) : activeTags.add(t);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final cols = w >= 1200
                      ? 4
                      : w >= 900
                      ? 3
                      : w >= 600
                      ? 2
                      : 1;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 4 / 3,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _PortraitCard(p: filtered[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _collectTags(List<Portrait> list) {
    final s = <String>{};
    for (final p in list) {
      s.addAll(p.tags);
    }
    final out = s.toList()..sort();
    return out;
  }
}

class _PortraitCard extends StatelessWidget {
  const _PortraitCard({required this.p});
  final Portrait p;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          /* detail page later */
        },
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                p.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
            ListTile(title: Text(p.name), subtitle: Text(p.species)),
          ],
        ),
      ),
    );
  }
}
