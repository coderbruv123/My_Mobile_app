import 'package:flutter/material.dart';

class StudentList extends StatefulWidget{
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();

}

class _StudentListState extends State<StudentList> {
  final List<String> _students = ['John Doe', 'Jane Smith', 'Michael Brown', 'Emily White'];

  void _addStudents() {
    setState(() {
     _students.add('New Student ${_students.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
      title: const Text('Student List'),
    ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_students[index]),
          );
        },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudents,
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }
}