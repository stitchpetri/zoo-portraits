import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/portrait.dart';
import '../../data/portrait_repository.dart'; // 👈 use the repository, not the seed

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = LocalAssetPortraitRepository(); // reads assets/portraits.json

  String query = '';
  final Set<String> activeTags = {};

  // data + loading/error state
  List<Portrait> _all = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await repo.loadAll();
      if (!mounted) return;
      setState(() {
        _all = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tags = _collectTags(_all);

    final filtered = _all.where((p) {
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
      appBar: AppBar(
        title: const Text('Austin Zoo Portraits'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, species, or tag…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 12),

            // Tag chips
            if (!_loading && _error == null && tags.isNotEmpty)
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
                        backgroundColor: const Color(0xFF1F2327),
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (!_loading && _error == null && tags.isNotEmpty)
              const SizedBox(height: 12),

            // Content area
            Expanded(
              child: Builder(
                builder: (_) {
                  if (_loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_error != null) {
                    return Center(
                      child: Text(
                        'Could not load portraits:\n$_error',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No portraits match your filters yet.'),
                    );
                  }

                  return LayoutBuilder(
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
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _PortraitCard(p: filtered[i]),
                      );
                    },
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
    final cs = Theme.of(context).colorScheme;
    final isAssetPath = p.imageUrl.startsWith('assets/');

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => context.go('/detail/${p.id}'),
        hoverColor: cs.primary.withOpacity(0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isAssetPath
                      ? Image.asset(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _BrokenImage(),
                        )
                      : Image.network(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _BrokenImage(),
                        ),
                ),
              ),
            ),
            // text
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  p.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  p.species,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Icons.broken_image_outlined));
  }
}
