import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  final int currentIndex;

  UsersScreen({ this.currentIndex });

  @override
  _UsersScreenState createState() => new _UsersScreenState(this.currentIndex);
}

class _UsersScreenState extends State<UsersScreen> with TickerProviderStateMixin {

  MenuController menuController;
  int currentIndex;

  _UsersScreenState(this.currentIndex);

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
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        title: usersNavigations[currentIndex].title,
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => SafeArea(
            top: false,
            child: IndexedStack(
              index: currentIndex,
              children: usersNavigations.map<Widget>((Navigation navigation) {
                return NavigationView(navigation: navigation);
              }).toList()
            )
          )
        ),
        floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          )
          : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: usersNavigations.map((Navigation navigation) {
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