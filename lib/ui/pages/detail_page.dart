import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/models/portrait.dart';
import '/data/portraits_service.dart';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Portrait? _portrait;
  bool _loading = true;
  String? _error;

  // ✅ Correct raw GitHub URL
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
      final list = await service.fetch();
      final found = list.firstWhere(
        (p) => p.id == widget.id,
        orElse: () => throw Exception('Portrait not found'),
      );
      setState(() => _portrait = found);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Portrait')),
        body: Center(child: Text('Error: $_error')),
      );
    }

    final p = _portrait!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Title styling comes from AppTheme.appBarTheme (24px, bold)
        title: Text(p.name?.trim().isNotEmpty == true ? p.name! : p.slug),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const _TopGradient(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center, // fade ~halfway down
            colors: [
              Color(0xFFc47b25), // zoo orange
              Color(0xFF32302C), // soft dark
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image: reasonable cap + better filtering/decoding
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 420),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dpr = MediaQuery.of(context).devicePixelRatio;
                      final targetW = (constraints.maxWidth * dpr).round();
                      final targetH = (constraints.maxHeight * dpr).round();

                      return CachedNetworkImage(
                        imageUrl: p.image,
                        imageBuilder: (ctx, provider) => Image(
                          image: provider,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium, // smooth
                        ),
                        placeholder: (ctx, _) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (ctx, _, __) =>
                            const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Info
                if ((p.name ?? '').isNotEmpty)
                  Text(
                    p.name!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if ((p.name ?? '').isNotEmpty) const SizedBox(height: 4),
                Text(
                  p.species,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 12),

                if (p.date != null)
                  Text('Date: ${p.date}', style: theme.textTheme.bodyMedium),
                if (p.location != null)
                  Text(
                    'Location: ${p.location}',
                    style: theme.textTheme.bodyMedium,
                  ),
                if (p.credit != null)
                  Text(
                    'Credit: ${p.credit}',
                    style: theme.textTheme.bodyMedium,
                  ),

                if (p.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.tags
                        .map(
                          (t) => Chip(
                            label: Text(t),
                            backgroundColor: scheme.secondaryContainer,
                            labelStyle: TextStyle(
                              color: scheme.onSecondaryContainer,
                            ),
                            side: BorderSide(
                              color: scheme.outlineVariant,
                              width: 0.6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopGradient extends StatelessWidget {
  const _TopGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFc47b25), Color(0xFF32302C)],
        ),
      ),
    );
  }
}
