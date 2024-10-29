import 'package:flutter/widgets.dart';

/// Exception thrown when there is an issue with rendering music notation.
class NotationRenderingException implements Exception {
  /// A message that describes the error in detail.
  final String message;

  /// Constructs a [NotationRenderingException] with the given [message].
  NotationRenderingException({
    required this.message,
  });

  /// Factory constructor for an exception that occurs when the notation font is missing.
  ///
  /// The [widget] parameter is used to include the runtime type in the error message.
  factory NotationRenderingException.noFont({required Widget widget}) {
    return NotationRenderingException(
      message:
          "Notation font not found. Please ensure that the ${widget.runtimeType} widget is wrapped in a NotationFont inherited widget.",
    );
  }
}
