import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';
  final int currentIndex;

  HomeScreen({ this.currentIndex });

  @override
  _HomeScreenState createState() => new _HomeScreenState(this.currentIndex);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, Loadable {

  MenuController menuController;
  int currentIndex;

  _HomeScreenState(this.currentIndex);

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
  String getLoadingTitle() {
    return 'Cargando mensajes';
  }

  @override
  Widget getWidgetBody() {
    return SafeArea(
      top: false,
      child: IndexedStack(
        index: currentIndex,
        children: homeNavigations.map<Widget>((Navigation navigation) {
          return NavigationView(navigation: navigation);
        }).toList()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        title: homeNavigations[currentIndex].title,
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => getSreenBody()
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
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