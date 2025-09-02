import 'package:flutter/material.dart';
import '../../data/portraits_seed.dart';
import '../../models/portrait.dart';

class DetailPage extends StatelessWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Portrait p = portraitsSeed.firstWhere((e) => e.id == id);

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Image.network(p.imageUrl, fit: BoxFit.cover)),
            const SizedBox(height: 16),
            Text(p.species, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Date added: ${p.date}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: p.tags.map((t) => Chip(label: Text(t))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
