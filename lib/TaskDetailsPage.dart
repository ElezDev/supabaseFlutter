import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login/utils/styles.dart';

class TaskDetailsPage extends StatelessWidget {
  final dynamic task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueDate = task['due_date'] != null
        ? DateTime.parse(task['due_date'])
        : null;
    final formattedDate = dueDate != null
        ? DateFormat('yyyy-MM-dd').format(dueDate)
        : 'No asignada';

    return Scaffold(
      appBar: AppBar(
        title: Text(task['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la tarea
            Text(
              task['title'],
              style: big2Title(context),
            ),
            const SizedBox(height: 8.0),

            // Descripción de la tarea
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description, color: Colors.grey[700]),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    task['description'],
                   style: big2Title(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Fecha de vencimiento
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[700]),
                const SizedBox(width: 8.0),
                Text(
                  'Fecha de vencimiento: $formattedDate',
                  style: smallitle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
