import 'package:flutter/material.dart';
import 'curved_edges.dart';

class UCurvedEdgeWidget extends StatelessWidget {
  const UCurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UCustomCurvedEdges(),
      child: child,
    );
  }
}