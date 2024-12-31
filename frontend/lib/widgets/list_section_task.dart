import 'package:flutter/material.dart';
import 'package:frontend/models/shopping_state.dart';

class ListSection extends StatelessWidget {
  final String title;
  final List<Task> tasks; // Updated to accept a list of Task objects
  final VoidCallback onAdd;
  final void Function(String taskId, String ingredientName) onItemTap;
  final void Function(Task task) onEditTask;
  final void Function(Task task) onDeleteTask;
  final void Function(Task task, bool isCompleted) onToggleCompletion;
  final String role;

  const ListSection(
      {Key? key,
      required this.title,
      required this.tasks,
      required this.onAdd,
      required this.onItemTap,
      required this.onEditTask,
      required this.onDeleteTask,
      required this.onToggleCompletion,
      required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFFEF9920),
                  fontSize: 20,
                  fontFamily: 'Oxygen',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Divider(
                  color: Color(0xFFEF9920),
                  thickness: 1,
                ),
              ),
              SizedBox(width: 5),
              if (role == 'manager' && title == 'Pending Tasks')
                GestureDetector(
                  onTap: onAdd,
                  child: Icon(
                    Icons.add,
                    color: Color(0xFFEF9920),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 300, // Increased height to accommodate more data
            child: ListView(
              children: tasks.map((task) {
                return GestureDetector(
                  onTap: () => onItemTap(task.taskId, task.ingredientName),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Task Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.ingredientName,
                              style: TextStyle(
                                color: Color(0xFF010F07),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Assigned to: ${task.email}',
                              style: TextStyle(
                                color: Color(0xFF8D8D8D),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Status: ${task.status}',
                              style: TextStyle(
                                color: Color(0xFF8D8D8D),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Quantity: ${task.quantity} ${task.unit.unitName}',
                              style: TextStyle(
                                color: Color(0xFF8D8D8D),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Action Buttons
                        if (role == 'manager' ||
                            (role != 'manager' && task.status != 'completed'))
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'complete':
                                  onToggleCompletion(
                                      task, task.status != 'Completed');
                                  break;
                                case 'edit':
                                  onEditTask(task);
                                  break;
                                case 'delete':
                                  onDeleteTask(task);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              if (role != 'manager' &&
                                  task.status != 'completed')
                                PopupMenuItem(
                                  value: 'complete',
                                  child: Text('Mark as Completed'),
                                ),
                              if (role == 'manager' && false)
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit Task'),
                                ),
                              // PopupMenuItem(
                              //   value: 'delete',
                              //   child: Text('Delete Task'),
                              // ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
