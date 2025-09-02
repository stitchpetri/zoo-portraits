import 'package:flutter/widgets.dart';

class Pad extends StatelessWidget {
  const Pad(this.value, {super.key, this.child});
  final double value;
  final Widget? child;
  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.all(value), child: child);
}
