import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

var deviceStorage = {
    'current': [
      {
        'title': 'Goal 1',
        'description':
            'This is the description of Goal 1. This is the description of Goal 1.',
        'time': '6/11/2020 7:00 PM',
        'done': null,
        'reflection': '',
        'key': '1'
      },
      {
        'title': 'Goal 2',
        'description': 'This is the description of Goal 2',
        'time': '6/13/2020 9:00 AM',
        'done': null,
        'reflection': '',
        'key': '2'
      },
      {
        'title': 'Goal 3',
        'description': 'This is the description of Goal 3',
        'time': '6/15/2020 11:00 PM',
        'done': null,
        'reflection': '',
        'key': '3'
      },
      {
        'title': 'Goal 4',
        'description': 'This is the description of Goal 4',
        'time': '6/15/2020 11:00 PM',
        'done': null,
        'reflection': '',
        'key': '4'
      },
      {
        'title': 'Goal 5',
        'description': 'This is the description of Goal 5',
        'time': '6/15/2020 11:00 PM',
        'done': null,
        'reflection': '',
        'key': '5'
      },
    ],
    'past': []
  };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Accountability',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Accountability"),
      ),
      body: Home(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Fab pressed");
        },
        tooltip: 'New goal',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.lightBlueAccent,
          child: ButtonBar(
            children: <Widget>[
              OutlineButton(
                child: Text('Current'),
                clipBehavior: Clip.antiAlias,
                autofocus: false,
                onPressed: () {
                  pageController.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
              ),
              OutlineButton(
                child: Text('Past'),
                clipBehavior: Clip.antiAlias,
                autofocus: false,
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
              )
            ],
            mainAxisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.start,
            buttonTextTheme: ButtonTextTheme.normal,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final pageController = PageController(initialPage: 0);

class _HomePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return (PageView(
      children: <Widget>[
        CurrentPage(),
        Center(child: Text('Past')),
      ],
      controller: pageController,
    ));
  }
}

class CurrentPage extends StatefulWidget {
  @override
  _CurrentPageState createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  

  var currentList = deviceStorage['current'];

  @override
  Widget build(BuildContext context) {
    List<Widget> items = currentList.map((itemsObject) {
      return (Padding(
        child: Card(
          child: ListTile(
            title: Text(itemsObject['title']),
            subtitle: ConstrainedBox(
              constraints: BoxConstraints.loose(Size(double.infinity,
                  32)), //TODO: Replace with a dynamic solution. Size.copy()?
              child: Column(
                children: <Widget>[
                  Text(
                    itemsObject['description'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(itemsObject['time'],
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            isThreeLine: true,
            trailing: Icon(Icons.drag_handle),
          ),
          elevation: 2,
        ),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        key: Key(itemsObject['key']),
      ));
    }).toList();

    return (Center(
        child: ReorderableListView(
            children: items,
            onReorder: (index1, index2) {
              var orgIndex1 = currentList[index1];

              if (index2 < index1) {
                index1++;
              }

              setState(() {
                currentList.insert(index2, orgIndex1);
                currentList.removeAt(index1);
              });
            },
            header: Padding(
              child: Text(
                'Current Goals',
                textScaleFactor: 2,
              ),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            ))));
  }
}
