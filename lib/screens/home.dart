import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cats Home"),
        actions: <Widget>[
          IconButton(
            tooltip: "Profile",
            icon: Icon(Icons.account_box),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: Platform.isIOS
            ? BouncingScrollPhysics()
            : Platform.isAndroid
                ? ClampingScrollPhysics()
                : ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Showcase(),
          Wishes(),
          // HomeShowcase(pageIndex: 0),
          // HomeUnderway(pageIndex: 1),
          // HomeInterplay(pageIndex: 2),
          // HomeProfile(),
        ],
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
  }

  void _onPageChanged(int value) {
    setState(() {
      _pageIndex = value;
    });
  }
}

Widget _buildAddButton() {
  return FloatingActionButton(
    onPressed: () async {
      final result = await navigator.push<bool>(AddUnitScreen().getRoute());
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
        icon: Platform.isIOS ? CupertinoIcons.paw : Icons.pets,
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
  var _activeColor = Theme.of(context).primaryColor;
  var _color = Theme.of(context).disabledColor;
  final color = isSelected ? _activeColor : _color;
  return Expanded(
    child: SizedBox(
      height: kNavigationBarHeight,
      child: Tooltip(
        message: tab.title,
        child: Material(
          type: MaterialType.transparency,
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
                    //         color: _activeColor,
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
