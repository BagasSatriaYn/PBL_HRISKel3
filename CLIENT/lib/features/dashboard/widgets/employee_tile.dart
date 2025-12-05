import 'package:flutter/material.dart';

class EmployeeTile extends StatelessWidget {
  final String name;
  final String position;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EmployeeTile({
    super.key,
    required this.name,
    required this.position,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(name),
        subtitle: Text(position),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// EDIT BUTTON
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),

            /// DELETE BUTTON
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
