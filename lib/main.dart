import 'package:flutter/material.dart';
import 'package:hci/CardView.dart';
import 'package:hci/ConfettiManager.dart';
import 'package:hci/NewTaskPage.dart';
import 'package:hci/StatsPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
    create: (_) => ConfettiManager(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      home: const MyHomePage(title: "Today's Tasks"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _refreshCounter = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return CardView(refreshTrigger: _refreshCounter);
      case 1:
        return NewTaskPage(onTaskCreated: switchToTasksTab);
      case 2:
        return const StatsPage();
    // Return the appropriate page for each tab
      default:
        return Container();
    }
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // Add a key for each tab
  ];

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      // Pop to first route if the user selects the current tab again
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void switchToTasksTab() {
    _selectTab(0);
    _refreshCounter++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        key: ValueKey(_refreshCounter),
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          // Add an offstage navigator for each tab
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          // Define items for each tab
        ],
        currentIndex: _selectedIndex,
        onTap: _selectTab,
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => _buildPage(index), // Build the page based on the index
          );
        },
      ),
    );
  }
}