import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: кнопка "Новые объявления", когда пролистал далеко вниз

class HomeScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/home',
      builder: (_) => this,
    );
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  final showcaseKey = GlobalKey();
  final whishesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // TODO: [MVP] move initializeService() to LoadProfileScreen
    // getRepository<DatabaseRepository>(context).initializeService();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: CupertinoPageScaffold
    // Widget result =
    return Scaffold(
      appBar: AppBar(
        title: Text("Cats Home"),
        // leading: IconButton(
        //   tooltip: "Search",
        //   icon: Icon(defaultTargetPlatform == TargetPlatform.iOS
        //       ? CupertinoIcons.search_circle_fill
        //       : Icons.search),
        //   onPressed: () {
        //     navigator.push(SearchScreen().getRoute());
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Profile',
            icon: Icon(defaultTargetPlatform == TargetPlatform.iOS
                ? CupertinoIcons.person_crop_square_fill
                : Icons.account_box),
            onPressed: () {
              // TODO:
              navigator.push(EditProfileScreen().getRoute());
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) => ShowcaseCubit(
          getRepository<DatabaseRepository>(context),
          category: CategoryValue.cat,
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: defaultTargetPlatform == TargetPlatform.iOS
              ? BouncingScrollPhysics()
              : defaultTargetPlatform == TargetPlatform.android
                  ? ClampingScrollPhysics()
                  : ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ShowcaseBody(),
            WishesBody(),
          ],
        ),
      ),
      bottomNavigationBar: _NavigationBar(
        tabIndex: _pageIndex,
        onChangeTabIndex: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildAddButton(),
    );
    // result = BlocProvider(
    //   create: (BuildContext context) => ShowcaseCubit(
    //     getRepository<DatabaseRepository>(context),
    //     category: CategoryValue.cat,
    //   ),
    //   child: result,
    // );
    // return result;
  }

  void _onPageChanged(int value) {
    setState(() {
      _pageIndex = value;
    });
  }
}

Widget _buildAddButton() {
  return FloatingActionButton(
    splashColor: Colors.white.withOpacity(0.24),
    onPressed: () async {
      final result = await navigator.push<bool>(EditUnitScreen().getRoute());
      out(result);
    },
    tooltip: 'Add Pet',
    // elevation: kButtonElevation,
    child: Icon(
      Icons.add,
      size: kBigButtonIconSize * 1.2,
    ),
  );
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar(
      {required this.tabIndex, required this.onChangeTabIndex});

  final int tabIndex;
  final void Function(int) onChangeTabIndex;
  // final double _height = kNavigationBarHeight;
  // final Color _backgroundColor = Colors.white;
  // final Color _color = Colors.grey;
  // final Color _activeColor = Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _NavigationBarTab(
        title: 'Showcase',
        icon: defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoIcons.paw
            : Icons.pets,
        value: _NavigationBarTabValue.showcase,
      ),
      _NavigationBarTab(
        title: 'My Wishes',
        icon: Icons.favorite,
        value: _NavigationBarTabValue.wishes,
      ),
    ];
    final children = List.generate(
      tabs.length,
      (int index) => _buildTabItem(
        context: context,
        tab: tabs[index],
        isSelected: index == tabIndex,
        onTap: () {
          onChangeTabIndex(index);
        },
      ),
    );
    children.insert(children.length >> 1, _buildMiddleTabItem());
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      clipBehavior: Clip.hardEdge,
      notchMargin: 8,
      // color: _backgroundColor, // TODO: from Theme
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }
}

Widget _buildMiddleTabItem() {
  return Expanded(
    child: SizedBox(
      height: kNavigationBarHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: kBigButtonIconSize),
        ],
      ),
    ),
  );
}

Widget _buildTabItem({
  required BuildContext context,
  required _NavigationBarTab tab,
  required bool isSelected,
  required void Function() onTap,
}) {
  final activeColor = Theme.of(context).primaryColor;
  final disabledColor = Theme.of(context).disabledColor;
  final color = isSelected ? activeColor : disabledColor;
  return Expanded(
    child: SizedBox(
      height: kNavigationBarHeight,
      child: Material(
        type: MaterialType.transparency,
        child: Tooltip(
          message: tab.title,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Icon(
                      tab.icon,
                      color: color,
                      size: kBigButtonIconSize,
                    ),
                    // TODO: добавить анимацию
                    // if (tab.hasBadge)
                    //   Positioned(
                    //     top: 0.0,
                    //     right: 0.0,
                    //     child: Container(
                    //       width: 6,
                    //       height: 6,
                    //       decoration: ShapeDecoration(
                    //         color: activeColor,
                    //         shape: StadiumBorder(
                    //           side: BorderSide(color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                // Text(
                //   tab.title,
                //   style: TextStyle(color: color),
                // )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

enum _NavigationBarTabValue { showcase, wishes }

class _NavigationBarTab {
  _NavigationBarTab({
    required this.title,
    required this.icon,
    required this.value,
    this.hasBadge = false,
  });

  String title;
  IconData icon;
  _NavigationBarTabValue value;
  bool hasBadge;
}
