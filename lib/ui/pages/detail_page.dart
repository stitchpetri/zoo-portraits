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

  final service = PortraitsService(
    'https://raw.githubusercontent.com/stitchpetri/zoo-portraits-content/data/portraits.json',
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
      appBar: AppBar(title: Text(p.name ?? p.slug)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full image
            AspectRatio(
              aspectRatio: 3 / 4,
              child: CachedNetworkImage(
                imageUrl: p.image,
                fit: BoxFit.contain,
                placeholder: (ctx, _) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (ctx, _, __) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(height: 16),

            // Info
            Text(p.name ?? 'Unknown', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
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
              Text('Credit: ${p.credit}', style: theme.textTheme.bodyMedium),

            if (p.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: p.tags.map((t) => Chip(label: Text(t))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
