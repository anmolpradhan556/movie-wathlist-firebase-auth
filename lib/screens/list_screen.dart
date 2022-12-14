import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_signin/boxes.dart';
import 'package:firebase_signin/model/todo.dart';
import 'package:firebase_signin/screens/add_todo_Screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Movie Watch List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>(HiveBoxes.todo).listenable(),
          builder: (context, Box<Todo> box, _) {
            if (box.values.isEmpty)
              return Center(
                child: Text("No Record Found"),
              );

            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Todo? res = box.getAt(index);
                return Dismissible(
                  background: Container(color: Colors.red),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    res!.delete();
                  },
                  child: ListTile(
                      title: Text(res!.title),
                      subtitle: Text(res.description),
                      onTap: () {}),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTodoScreen(),
          ),
        ),
      ),
    );
  }
}