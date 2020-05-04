import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Alerts/AddEventAlert.dart';
import 'Alerts/AddTaskAlert.dart';
import 'CustomWidgets/CustomButton.dart';
import 'DataBase/DateTimeProvider.dart';
import 'DataBase/database.dart';
import 'Screens/EventPage.dart';
import 'Screens/TaskPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Database>(
          builder: (_) => Database(),
        ),ChangeNotifierProvider<DateTimeControl>(
          builder: (_) => DateTimeControl(),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false,
        title: 'To Do',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database provider;
  PageController _pageController = PageController();
  double _currentPage = 0;
  final DateTime today = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page;
      });
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).accentColor,
            height: 35,
          ),
          Positioned(
            right: 25,
            top: 25,
            child: Text(
              "${today.day}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 170,
                  color: Color(0x20000000)),
            ),
          ),
          _maincontent()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _currentPage < .5 ? AddTaskAlert() : AddEventAlert(),
                  ));
        },
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(12)
                ),
                enabled: true,
                icon: (Icon(Icons.list,color: Colors.teal,size: 35,)),
                onSelected: (String result) {
                  provider.setfilter(result);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "All",
                    child: Text('All'),
                  ),
                  const PopupMenuItem<String>(
                    value: "Today",
                    child: Text('Today'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: CustomButton(
              onPressed: () {
                setState(() {
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.bounceInOut);
                });
              },
              color: _currentPage > .5
                  ? Colors.white
                  : Theme.of(context).accentColor,
              borderColor: _currentPage > .5
                  ? Theme.of(context).accentColor
                  : Colors.white,
              txt: "Tasks",
              txtColor: _currentPage > .5
                  ? Theme.of(context).accentColor
                  : Colors.white,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: CustomButton(
                onPressed: () {
                  setState(() {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.bounceInOut);
                  });
                },
                color: _currentPage < .5
                    ? Colors.white
                    : Theme.of(context).accentColor,
                borderColor: _currentPage < .5
                    ? Theme.of(context).accentColor
                    : Colors.white,
                txt: "Events",
                txtColor: _currentPage < .5
                    ? Theme.of(context).accentColor
                    : Colors.white),
          ),
        ],
      ),
    );
  }

  _maincontent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
          child: Text(
            "${DateFormat('EEEE').format(today)}",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
        _button(),
        Expanded(
            child: PageView(
          controller: _pageController,
          children: <Widget>[TaskPage(), EventPage()],
        )),
      ],
    );
  }
}
