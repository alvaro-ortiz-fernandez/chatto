import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/home/chats-view.dart';
import 'package:chatto/widgets/home/groups-view.dart';
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

  static UserData _currentUser = UserData.emptyUser();
  final List<Navigation> homeNavigations = <Navigation>[
    Navigation(title: 'Chats', icon: Icons.chat_bubble, view: ChatsView(currentUser: _currentUser), parent: HomeScreen(currentIndex: 0)),
    Navigation(title: 'Grupos', icon: Icons.supervisor_account, view: GroupsView(currentUser: _currentUser), parent: HomeScreen(currentIndex: 1))
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MenuController menuController;
  int currentIndex;
  bool loadError = false;

  _HomeScreenState(this.currentIndex);

  @override
  Future<void> loadData() async {
    startLoading();
    setState(() => loadError = false);

    try {
      UserData user = await UsersService.getUserLocal();
      setState(() => _currentUser = user);

    } catch(e,  stackTrace) {
      setState(() => loadError = true);
      print('Error cargando los mensajes del usuario: ' + e.toString());
      print(stackTrace.toString());
    } finally {
      stopLoading();
    }
  }

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    loadData();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  String getLoadingTitle() {
    return 'Cargando información';
  }

  @override
  Widget getWidgetBody() {
    return SafeArea(
      top: false,
      child: IndexedStack(
        index: currentIndex,
        children: homeNavigations.map<Widget>((Navigation navigation) {
          return loadError
                  ? getLoadErrorBody()
                  : NavigationView(navigation: navigation);
        }).toList()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        scaffoldKey: _scaffoldKey,
        title: homeNavigations[currentIndex].title,
        menuScreen: MenuScreen(currentUser: _currentUser),
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