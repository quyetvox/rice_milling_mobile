// 🎯 Dart imports:
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

export '_build_context_extensions.dart';

extension ListExtension<T> on List<T> {
  List<T> addBetween(T separator) {
    if (length <= 1) return toList();

    final _newItems = <T>[];
    for (int i = 0; i < length - 1; i++) {
      _newItems.add(this[i]);
      _newItems.add(separator);
    }
    _newItems.add(this[length - 1]);

    return _newItems;
  }
}

extension IterableExtension<T> on List<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    final idSet = <Object>{};
    final distinct = <T>[];
    for (final d in this) {
      if (idSet.add(getCompareValue(d))) {
        distinct.add(d);
      }
    }
    return distinct;
  }

  String? indexWhereOrNull(bool Function(T e) getCompareValue) {
    for (final d in this) {
      if (getCompareValue(d)) return indexOf(d).toString();
    }
    return null;
  }
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1440) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
