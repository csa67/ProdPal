import 'package:flutter/material.dart';
import 'package:hci/NewTaskPage.dart';

class CardView extends StatelessWidget{
  const CardView({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title: const Text('Task List Page'),),
        body: const TasksList(),
          ),
        );
  }
}

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList>{

  final List<String> items = List<String>.generate(20, (index) => "Item $index");



  @override
  Widget build(BuildContext context){
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          return TaskCard(
              item: items[index],
              onTaskCompletion: () {
                setState(() {
                  items.removeAt(index);
                });
              },
                onTaskDismissal: (){
                  setState(() {
                    items.removeAt(index);
                  });
                });
        });
  }
}
class TaskCard extends StatelessWidget{
  final String item;
  final VoidCallback onTaskCompletion;
  final VoidCallback onTaskDismissal;
  const TaskCard({super.key, required this.item, required this.onTaskCompletion, required this.onTaskDismissal});

  @override
  Widget build(BuildContext context){
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.horizontal,
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.done_outlined),
      ),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.archive_outlined),
      ),
      onDismissed: (direction){
        if(direction == DismissDirection.startToEnd) {
          //right swipe
          onTaskCompletion();
        }else if(direction == DismissDirection.endToStart) {
          //left swipe
          onTaskDismissal();
        }
      },
      child: Container(
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 60.0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.deepOrange.withAlpha(30),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewTaskPage()),);
          },
          child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('task Details')),
        ),
      ),
    ),
    );
  }
}
