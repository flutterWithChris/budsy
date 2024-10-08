import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

SnackBar getSuccessSnackBar(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check, color: Colors.white, size: 18),
        const Gap(size: 8),
        Text(message, style: const TextStyle(color: Colors.white)),
      ],
    ),
    backgroundColor: Colors.green,
  );
}

SnackBar getErrorSnackBar(String message, {Widget? action}) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white, size: 18),
        const Gap(size: 8),
        Text(message, style: const TextStyle(color: Colors.white)),
        if (action != null)
          Row(
            children: [
              action,
            ],
          ),
      ],
    ),
    backgroundColor: Colors.red,
  );
}
