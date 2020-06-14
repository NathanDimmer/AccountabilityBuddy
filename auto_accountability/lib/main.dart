import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

Map<String,List<Map<String,String>>> deviceStorage = {
  'current': [
    {
      'title': 'Goal 1',
      'description':
          'This is the description of Goal 1. This is the description of Goal 1.',
      'time': '6/11/2020 7:00 PM',
      'reflection': '',
      'key': '1'
    },
    {
      'title': 'Goal 2',
      'description': 'This is the description of Goal 2',
      'time': '6/13/2020 9:00 AM',
      'reflection': '',
      'key': '2'
    },
    {
      'title': 'Goal 3',
      'description': 'This is the description of Goal 3',
      'time': '6/15/2020 11:00 PM',
      'reflection': '',
      'key': '3'
    },
    {
      'title': 'Goal 4',
      'description': 'This is the description of Goal 4',
      'time': '6/15/2020 11:00 PM',
      'reflection': '',
      'key': '4'
    },
    {
      'title': 'Goal 5',
      'description': 'This is the description of Goal 5',
      'time': '6/15/2020 11:00 PM',
      'reflection': '',
      'key': '5'
    },
  ],
  'past': [{
      'title': 'Goal 5',
      'description': 'This is the description of Goal 5',
      'time': '6/15/2020 11:00 PM',
      'reflection': '',
      'key': '5'
    },]
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
  List<Map<String, String>> currentList = deviceStorage['current'] as List<Map<String, String>>;
  List<Map<String, String>> pastList = deviceStorage['past'] as List<Map<String, String>>;

  void addGoal(Map content) {
    currentList.add(content);
  }

  void currentToPast(Map itemObject) {
    currentList.remove(itemObject);
    pastList.add(itemObject);
  }

  void pastToCurrent(Map itemObject) {
    currentList.add(itemObject);
    pastList.remove(itemObject);
  }

  void delete(Map itemObject) {
    pastList.remove(itemObject);
  }

  void reorderPast(int index1, int index2, Map orgIndex1) {
    pastList.insert(index2, orgIndex1);
    pastList.removeAt(index1);
  }

  void reorderCurrent(int index1, int index2, Map orgIndex1) {
    currentList.insert(index2, orgIndex1);
    currentList.removeAt(index1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Accountability"),
      ),
      body: PageView(
        children: <Widget>[
          CurrentPage(
            pastList: pastList,
            currentList: currentList,
            currentToPast: currentToPast,
            reorderCurrent: reorderCurrent,
          ),
          PastPage(
            pastList: pastList,
            currentList: currentList,
            delete: delete,
            pastToCurrent: pastToCurrent,
            reorderPast: reorderPast,
          ),
        ],
        controller: pageController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NewGoal()));
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

final pageController = PageController(initialPage: 0);

class CurrentPage extends StatelessWidget {
  final List<Map<String, String>> pastList;
  final List<Map<String, String>> currentList;

  final Function currentToPast;
  final Function reorderCurrent;

  CurrentPage(
      {this.pastList,
      this.currentList,
      this.currentToPast,
      this.reorderCurrent});

  @override
  Widget build(BuildContext context) {
    var items = currentList.map((itemsObject) {
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
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
              currentToPast(itemsObject);
            } else {
              currentToPast(itemsObject);
            }
          }));
    }).toList();

    return (Center(
        child: ReorderableListView(
            children: items,
            onReorder: (index1, index2) {
              var orgIndex1 = currentList[index1];

              if (index2 < index1) {
                index1++;
              }

              reorderCurrent(index1, index2, orgIndex1);
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

class PastPage extends StatelessWidget {
  final List<Map<String, String>> pastList;
  final List<Map<String, String>> currentList;

  final Function pastToCurrent;
  final Function delete;
  final Function reorderPast;

  PastPage(
      {this.pastList,
      this.currentList,
      this.delete,
      this.pastToCurrent,
      this.reorderPast});

  @override
  Widget build(BuildContext context) {
    var items = pastList.map((itemsObject) {
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
            pastToCurrent(itemsObject);
          } else {
            delete(itemsObject);
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

              reorderPast(index1, index2, orgIndex1);
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

class NewGoal extends StatelessWidget {
  final Function addGoal;

  NewGoal({this.addGoal});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            addGoal({
              'title': 'Added Goal',
              'description': 'This is the description of the added goal',
              'time': '6/17/2020 11:00 PM',
              'reflection': '',
            });
            Navigator.pop(context);
          },
        ),
        title: Text('Add a new goal'),
      ),
    ));
  }
}
