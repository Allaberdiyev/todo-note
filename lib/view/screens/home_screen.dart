import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_and_note/controllers/todo_controller.dart';
import 'package:todo_and_note/view/screens/notes_screen.dart';
import 'package:todo_and_note/view/screens/todos_screen.dart';
import 'package:todo_and_note/view/widgets/manage_todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
    tabController.addListener(() {
      setState(() {});
    });
  }

  final todosController = TodoController();
  void addTodo() async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return const ManageTodoDialog();
      },
    );

    if (data != null) {
      try {
        todosController.addTodo(
          data['id'],
          data['title'],
          data['isCompleted'] ?? false,
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 143, 39),
        title: tabController.index == 0
            ? const Text(
                "Todo",
                style: TextStyle(fontSize: 27),
              )
            : const Text(
                "Notes",
                style: TextStyle(fontSize: 27),
              ),
        centerTitle: true,
        bottom: TabBar(
          dividerColor: Color.fromARGB(255, 124, 124, 124),
          indicatorColor: Color.fromARGB(255, 0, 0, 192),
          labelColor: Color.fromARGB(255, 1, 22, 143),
          controller: tabController,
          tabs: const [
            Tab(
              text: "Todos",
              icon: Icon(
                Icons.check_circle_outline_outlined,
              ),
            ),
            Tab(
              text: "Notes",
              icon: Icon(Icons.note_alt_outlined),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                TodosScreen(),
                NotesScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Color.fromARGB(255, 23, 0, 75),
        onPressed: addTodo,
        child: Icon(
          tabController.index == 0 ? CupertinoIcons.add : Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
