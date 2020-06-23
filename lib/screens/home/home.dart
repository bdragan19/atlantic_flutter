import 'package:atlantic_app/screens/home/tab-config.dart';
import 'package:atlantic_app/screens/latest/latest.dart';
import 'package:atlantic_app/widgets/atlantic-app-bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static var comingSoonWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.av_timer, size: 45, color: Colors.grey),
        Text("Coming soon...", style: TextStyle( color: Colors.grey, fontSize: 28, fontFamily: "AGaramond", fontStyle: FontStyle.italic))
      ]);

  final List<TabConfig> _tabsConfig = [
    TabConfig("Today", comingSoonWidget),
    TabConfig("Latest", LatestPage()),
    TabConfig("Sections", comingSoonWidget),
    TabConfig("Saved", comingSoonWidget),
    TabConfig("Settings", comingSoonWidget)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AtlanticAppBar(title: _tabsConfig.elementAt(_selectedIndex).name),
      body: Center(
        child: _tabsConfig.elementAt(_selectedIndex).body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 36,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            title: Text('Today'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('Latest'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_left),
            title: Text('Sections'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('Saved'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[600],
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }
}
