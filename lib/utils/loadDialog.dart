import 'package:flutter/material.dart';

void showLoadingDialog({
  required BuildContext context,
  String message = 'Cargando...',
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible, 
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      );
    },
  );
}

  