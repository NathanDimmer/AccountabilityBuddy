import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

Map<String, List<Map<String, String>>> deviceStorage = {
  'current': [
    {
      'title': 'Create Flutter App',
      'description':
          'Create the boilerplate Flutter App using Flutter Doctor.',
      'time': '6/13/2020 12:00 PM',
      'reflection': '',
      'key': '1'
    },
    {
      'title': 'Implement Swipe to Complete',
      'description': 'Allow goals to be completed based on gestures',
      'time': '6/13/2020 6:00 PM',
      'reflection': '',
      'key': '2'
    },
    {
      'title': 'Implement echoAR veiwer',
      'description': 'Add echoAR to allow viewing of your virtual buddies',
      'time': '6/15/2020 3:00 AM',
      'reflection': '',
      'key': '3'
    },
    {
      'title': 'Implement scoring',
      'description': 'Add gamificiation to unlock buddies',
      'time': '6/15/2020 3:00 AM',
      'reflection': '',
      'key': '5'
    },
    {
      'title': 'Finish Hackathon Demo',
      'description': 'Record hackathon demo video',
      'time': '6/15/2020 3:00 AM',
      'reflection': '',
      'key': '5'
    },
  ],
  'past': [
    {
      'title': 'Register for Geom Hacks',
      'description': 'Register on Devpost for Geom Hacks',
      'time': '6/15/2020 11:00 PM',
      'reflection': '',
      'key': '5'
    },
  ]
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acountability Buddy',
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
  List<Map<String, String>> currentList = deviceStorage['current'];
  List<Map<String, String>> pastList = deviceStorage['past'];

  int score = 0;

  double isOpacity = .25;

  void addScore() {
    setState(() {
      score++;
    });
    if (score >= 5) {
      setState(() {
        isOpacity = 1;
      });
    }
  }

  void resetScore() {
    setState(() {
      score = 0;
    });
  }

  void addGoal(Map content) {
    setState(() {
      currentList.add(content);
    });
  }

  void currentToPast(Map itemObject) {
    setState(() {
      currentList.remove(itemObject);
      pastList.add(itemObject);
    });
  }

  void pastToCurrent(Map itemObject) {
    setState(() {
      currentList.add(itemObject);
      pastList.remove(itemObject);
    });
  }

  void delete(Map itemObject) {
    setState(() {
      pastList.remove(itemObject);
    });
  }

  void reorderPast(int index1, int index2, Map orgIndex1) {
    setState(() {
      pastList.insert(index2, orgIndex1);
      pastList.removeAt(index1);
    });
  }

  void reorderCurrent(int index1, int index2, Map orgIndex1) {
    setState(() {
      currentList.insert(index2, orgIndex1);
      currentList.removeAt(index1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Accountability Buddy",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Buddies(
                            score: score,
                            isBuddy: isOpacity,
                          )));
            },
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          )
        ],
      ),
      body: PageView(
        children: <Widget>[
          CurrentPage(
            pastList: pastList,
            currentList: currentList,
            currentToPast: currentToPast,
            reorderCurrent: reorderCurrent,
            addScore: addScore,
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NewGoal(
                        addGoal: addGoal,
                      )));
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
  final Function addScore;

  CurrentPage(
      {this.pastList,
      this.currentList,
      this.currentToPast,
      this.reorderCurrent,
      this.addScore});

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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
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
              addScore();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Goal Complete! +1 Score'),
                duration: Duration(seconds: 1, milliseconds: 50),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ));
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

final TextEditingController titleController = new TextEditingController();
final TextEditingController descriptionController = new TextEditingController();
final TextEditingController timeController = new TextEditingController();

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
            Navigator.pop(context);
            titleController.clear();
            descriptionController.clear();
            timeController.clear();
          },
        ),
        title: Text('Add a new goal'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Goal name'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Goal description'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'End time'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(
              height: 30,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      titleController.clear();
                      descriptionController.clear();
                      timeController.clear();
                    },
                    child: Text('Cancel')),
                RaisedButton(
                  onPressed: () {
                    addGoal({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'time': timeController.text,
                      'reflection': '',
                    });
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();
                    timeController.clear();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text('Submit'),
                  color: Colors.blue[500],
                  textColor: Colors.white,
                )
              ],
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      ),
    ));
  }
}

class Buddies extends StatelessWidget {
  final int score;
  final double isBuddy;

  Buddies({this.score, this.isBuddy});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Your Accountability Buddies'),
        ),
        body: Column(children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    child: AspectRatio(
                      child: CircularProgressIndicator(
                        value: (score / 5),
                        backgroundColor: Colors.grey[200],
                        strokeWidth: 25,
                      ),
                      aspectRatio: 1,
                    ),
                    padding: EdgeInsets.fromLTRB(75, 30, 75, 30),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Buddies:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
              child: GridView.count(
            children: <Widget>[
              InkWell(child: Opacity(
                child: GridTile(child: Image.asset('assets/arctic fox.png')),
                opacity: isBuddy,
              ), onTap: () {
                _launchURL();
              },),
              Opacity(
                child: GridTile(child: Image.asset('assets/cat.png')),
                opacity: .25,
              ),
              Opacity(
                child: GridTile(child: Image.asset('assets/dog.png')),
                opacity: .25,
              ),
              Opacity(
                child: GridTile(child: Image.asset('assets/eagle.png')),
                opacity: .25,
              ),
              Opacity(
                child: GridTile(child: Image.asset('assets/fox.png')),
                opacity: .25,
              ),
              Opacity(
                child: GridTile(child: Image.asset('assets/rat.png')),
                opacity: .25,
              ),
            ],
            crossAxisCount: 3,
          ))
        ])));
  }
}

_launchURL({forceWebView: true, enableJavaScript: true}) async {
  const url = 'https://console.echoAR.xyz/webxr?key=lingering-bird-2378';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
