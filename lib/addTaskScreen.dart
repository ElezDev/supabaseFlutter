import 'package:flutter/material.dart';
import 'package:misTask/TaskDetailsPage.dart';
import 'package:misTask/utils/loadDialog.dart';
import 'package:misTask/utils/styles.dart';
import 'package:misTask/TaskDetailsPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final title = TextEditingController();
  final description = TextEditingController();

  List<dynamic> activeTasks = [];
  List<dynamic> inProgressTasks = [];
  List<dynamic> completedTasks = [];
  bool _isLoading = true;

  Future<void> getTasks() async {
    final res = await Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .order('created_at');

    setState(() {
      activeTasks = res.where((task) => task['status'] == 'active').toList();
      inProgressTasks =
          res.where((task) => task['status'] == 'in_progress').toList();
      completedTasks =
          res.where((task) => task['status'] == 'completed').toList();
      _isLoading = false;
    });
  }

  Future<void> addTask(
      String title, String description, DateTime? dueDate) async {
    await Supabase.instance.client.from('tasks').insert({
      'user_id': Supabase.instance.client.auth.currentUser!.id,
      'title': title,
      'description': description,
      'status': 'active',
      'due_date': dueDate?.toIso8601String(),
    });
    await getTasks();
  }

  Future<void> updateTaskStatus(int id, String status) async {
    await Supabase.instance.client
        .from('tasks')
        .update({'status': status}).eq('id', id);
    await getTasks();
  }

  Future<void> deleteTask(int id) async {
    try {
      await Supabase.instance.client.from('tasks').delete().eq('id', id);
      await getTasks();
    } on AuthException catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'active':
        return activeGradient;
      case 'in_progress':
        return inProgressGradient;
      case 'completed':
        return completedGradient;
      default:
        return defaultGradient;
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Mis Tareas 📚',
              style: bigTitle(context),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Activas'),
                            Tab(text: 'En Progreso'),
                            Tab(text: 'Terminadas'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              buildTaskList(activeTasks),
                              buildTaskList(inProgressTasks),
                              buildTaskList(completedTasks),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
//crear las tareas
  Future<void> _createTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? dueDate;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Crear nueva tarea'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      maxLines: 3, // Ajusta según tus necesidades
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: const Text('Fecha de Vencimiento'),
                      subtitle: Text(dueDate != null
                          ? DateFormat('yyyy-MM-dd').format(dueDate!)
                          : 'No seleccionada'),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              dueDate = selectedDate;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text;
                    final description = descriptionController.text;

                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        dueDate != null) {
                      // Muestra el diálogo de carga
                      showLoadingDialog(
                        context: context,
                        message: 'Creando tarea...',
                        barrierDismissible: false,
                      );

                      // Llama a la función para añadir la tarea
                      await addTask(title, description, dueDate);

                      // Cierra el diálogo de carga
                      Navigator.of(context).pop(); // Cierra el diálogo de carga
                      Navigator.of(context)
                          .pop(); // Cierra el diálogo de creación de tarea

                      // Puedes añadir aquí un mensaje de éxito si lo deseas
                    } else {
                      Navigator.of(context)
                          .pop(); // Cierra el diálogo de carga si ocurre un error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor completa todos los campos'),
                        ),
                      );
                    }
                  },
                  child: const Text('Crear Tarea'),
                ),
              ],
            );
          },
        );
      },
    );
  }
//eliminar kas tareas
  void _showDeleteDialog(BuildContext context, int taskId) {
    Alert(
      style: AlertStyle(
          titleStyle: bigTitle(context), descStyle: big2Title(context)),
      context: context,
      type: AlertType.warning,
      title: 'Confirmar eliminación',
      desc: '¿Estás seguro de que deseas eliminar esta tarea?',
      buttons: [
        DialogButton(
          child: Text(
            'Cancelar',
            style: big2Title(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          child: Text(
            'Eliminar',
            style: big2Title(context),
          ),
          onPressed: () {
            Navigator.pop(context);
            showLoadingDialog(
              context: context,
              message: 'Eliminando tarea...',
              barrierDismissible: false,
            );
            deleteTask(taskId).then((_) {
              Navigator.pop(context);
            }).catchError((error) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al eliminar la tarea')),
              );
            });
          },
        )
      ],
    ).show();
  }

//listar la treas
  Widget buildTaskList(List<dynamic> tasks) {
  return tasks.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no-data.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                'No hay tareas',
                style: big2Title(context),
              ),
            ],
          ),
        )
      : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final dueDate = tasks[index]['due_date'] != null
                ? DateTime.parse(tasks[index]['due_date'])
                : null;
            final formattedDate = dueDate != null
                ? DateFormat('yyyy-MM-dd').format(dueDate)
                : 'No asignada';

            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: _getStatusGradient(tasks[index]['status']),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  title: Text(tasks[index]['title'], style: big2Title(context)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tasks[index]['description'],
                        style: smallitle(context),
                        maxLines: 2, // Limita la cantidad de líneas
                        overflow: TextOverflow.ellipsis, // Muestra puntos suspensivos si el texto es largo
                      ),
                      Text(
                        'Vence: $formattedDate',
                        style: smallitle(context),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _editTaskDialog(tasks[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _showDeleteDialog(context, tasks[index]['id']);
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          updateTaskStatus(tasks[index]['id'], value);
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'active',
                              child: Text('Activa'),
                            ),
                            const PopupMenuItem(
                              value: 'in_progress',
                              child: Text('En Progreso'),
                            ),
                            const PopupMenuItem(
                              value: 'completed',
                              child: Text('Terminada'),
                            ),
                          ];
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailsPage(task: tasks[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
}

//editar las tareas
Future<void> _editTaskDialog(dynamic task) async {
    final titleController = TextEditingController(text: task['title']);
    final descriptionController =
        TextEditingController(text: task['description']);
    DateTime? dueDate =
        task['due_date'] != null ? DateTime.parse(task['due_date']) : null;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      maxLines: 3, // Ajusta según tus necesidades
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción';
                        }
                        return null;
                      },
                    ),
              ListTile(
                title: const Text('Fecha de Vencimiento'),
                subtitle: Text(dueDate != null
                    ? DateFormat('yyyy-MM-dd').format(dueDate!)
                    : 'No seleccionada'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        dueDate = selectedDate;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty) {
                  await Supabase.instance.client.from('tasks').update({
                    'title': title,
                    'description': description,
                    'due_date': dueDate?.toIso8601String(),
                  }).eq('id', task['id']);
                  await getTasks();
                }

                Navigator.of(context).pop();
              },
              child: const Text('Actualizar Tarea'),
            ),
          ],
        );
      },
    );
  }




}
