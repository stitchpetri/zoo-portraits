import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Use relative imports from lib/ui/pages/... up to lib/
import '../../models/portrait.dart';
import '../../data/portraits_service.dart';
// If you add cached_network_image to pubspec, you can use it below.
// import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // UI state
  String query = '';
  final Set<String> activeTags = {};

  // Data state
  List<Portrait> _all = [];
  bool _loading = true;
  String? _error;

  // ✅ Correct raw GitHub URL — no extra text, proper quotes/parens
  final service = PortraitsService(
    'https://raw.githubusercontent.com/stitchpetri/zoo-portraits-content/main/data/portraits.json',
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await service.fetch();
      setState(() => _all = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<String> _collectTags(List<Portrait> list) {
    final set = <String>{};
    for (final p in list) {
      for (final t in p.tags) {
        if (t.trim().isNotEmpty) set.add(t);
      }
    }
    final tags = set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return tags;
  }

  List<Portrait> _applyFilters() {
    final q = query.trim().toLowerCase();
    return _all.where((p) {
      final matchesText =
          q.isEmpty ||
          (p.name?.toLowerCase().contains(q) ?? false) ||
          p.species.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));

      final matchesTags =
          activeTags.isEmpty || activeTags.every((t) => p.tags.contains(t));
      return matchesText && matchesTags;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error loading portraits', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      final tags = _collectTags(_all);
      final filtered = _applyFilters();

      body = RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by name, species, or tag…',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => query = v),
                    ),
                    const SizedBox(height: 10),
                    // Tag chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: activeTags.isEmpty,
                            onSelected: (_) =>
                                setState(() => activeTags.clear()),
                          ),
                          const SizedBox(width: 8),
                          ...tags.map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(t),
                                selected: activeTags.contains(t),
                                onSelected: (sel) => setState(() {
                                  if (sel) {
                                    activeTags.add(t);
                                  } else {
                                    activeTags.remove(t);
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Small count line
                    Text(
                      '${filtered.length} of ${_all.length} portraits',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _PortraitCard(p: filtered[i]),
                  childCount: filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoo Portraits'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _PortraitCard extends StatelessWidget {
  const _PortraitCard({required this.p});
  final Portrait p;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        context.push('/detail/${p.id}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    p.thumb ?? p.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                    loadingBuilder: (ctx, child, evt) {
                      if (evt == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  if ((p.date ?? '').isNotEmpty)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          p.date!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (p.name == null || p.name!.trim().isEmpty)
                        ? _titleFromSlug(p)
                        : p.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.species,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _titleFromSlug(Portrait p) {
    final slug = (p as dynamic).slug ?? '';
    if (slug.isEmpty) return 'Unknown';
    final parts = slug.split('-');
    if (parts.isEmpty) return 'Unknown';
    final first = parts.first;
    if (first.toLowerCase() == 'unknown') return 'Unknown';
    return '${first[0].toUpperCase()}${first.substring(1)}';
  }
}
