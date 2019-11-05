import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;

  HomeScreen({ this.currentIndex });

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = widget.currentIndex;
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        title: homeNavigations[_currentIndex].title,
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => SafeArea(
            top: false,
            child: IndexedStack(
              index: _currentIndex,
              children: homeNavigations.map<Widget>((Navigation navigation) {
                return NavigationView(navigation: navigation);
              }).toList()
            )
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: homeNavigations.map((Navigation navigation) {
            return BottomNavigationBarItem(
              icon: Icon(navigation.icon),
              title: Text(navigation.title)
            );
          }).toList()
        )
      )
    );
  }
}