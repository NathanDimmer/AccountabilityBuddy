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
        backgroundColor: Colors.lightBlue[200],
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.blue[400],
          child: Row(
            children: <Widget>[
              Padding(
                child: RaisedButton(
                  child: Text('Current'),
                  clipBehavior: Clip.antiAlias,
                  autofocus: false,
                  onPressed: () {
                    pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  color: Colors.lightBlue[200],
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              Padding(
                child: RaisedButton(
                  child: Text('Past'),
                  clipBehavior: Clip.antiAlias,
                  autofocus: false,
                  onPressed: () {
                    pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  color: Colors.lightBlue[200],
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              )
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        PastPage(),
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
  var pastList = deviceStorage['past'];

  @override
  Widget build(BuildContext context) {
    List<Widget> items = currentList.map((itemsObject) {
      return (Dismissible(
        child: Padding(
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
              trailing: Column(
                children: <Widget>[
                  Icon(Icons.drag_handle),
                  IconButton(
                    icon: Icon(Icons.share),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return (AlertDialog(
                              title: Text('Share this goal'),
                              content: Column(
                                children: <Widget>[
                                  Text(
                                      'Share this goal with a friend so they can be an accountability buddy!'),
                                  TextField(
                                    autofocus: true,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        labelText: 'Phone number'),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    print('Phone number canceled');
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    print('Phone number entered');
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Send'),
                                  color: Colors.blue[500],
                                  textColor: Colors.white,
                                ),
                              ],
                            ));
                          });
                    },
                  )
                ],
              ),
            ),
            elevation: 2,
          ),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        ),
        key: UniqueKey(),
        background: Container(
          child: Padding(
            child: Icon(Icons.check),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          color: Colors.green[400],
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: Container(
          child: Padding(
            child: Icon(Icons.close),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          color: Colors.red[400],
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            setState(() {
              pastList.add(itemsObject);
              print(pastList);
              currentList.remove(itemsObject);
              print(currentList);
            });
          } else {
            setState(() {
              pastList.add(itemsObject);
              print(pastList);
              currentList.remove(itemsObject);
              print(currentList);
            });
          }
        },
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

class PastPage extends StatefulWidget {
  @override
  _PastPageState createState() => _PastPageState();
}

class _PastPageState extends State<PastPage> {
  var currentList = deviceStorage['current'];
  var pastList = deviceStorage['past'];

  @override
  Widget build(BuildContext context) {
    List<Widget> items = pastList.map((itemsObject) {
      return (Dismissible(
        child: Padding(
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
        ),
        key: UniqueKey(),
        background: Container(
          child: Padding(
            child: Icon(Icons.arrow_back),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          color: Colors.blue[400],
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: Container(
          child: Padding(
            child: Icon(Icons.delete),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          color: Colors.red[400],
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            setState(() {
              currentList.add(itemsObject);
              pastList.remove(itemsObject);
            });
          } else {
            setState(() {
              pastList.remove(itemsObject);
            });
          }
        },
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
                'Past Goals',
                textScaleFactor: 2,
              ),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            ))));
  }
}
