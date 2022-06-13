import 'package:action_bottom_bar/action_bottom_bar.dart';
import 'package:common_ui_toolkit/common_ui_toolkit.dart';

void main() => runApp(const MaterialApp(home: CustomNavigationBar()));

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  double currentIndex = 0;
  Color unSelectedColor = Colors.grey;
  Color selectedColor = Colors.black;
  double _iconIndex = 0;

  @override
  @override
  void initState() {
    super.initState();
  }

  void _handleOnPressed(value) {
    setState(() {
      _iconIndex = _iconIndex == 0 ? 1 : 0;
    });
  }

  void _handelClose(value) {
    if (_iconIndex == 1) {
      setState(() {
        _iconIndex = 0;
      });
    }
  }

  Widget bottomIconCustom(String path, {Function()? onPress, Color? color}) {
    return CommonContainer(
      onPress: _handelClose,
      style: CommonContainerModel(
        width: 0.1, height: 0.1, alignment: Alignment.center,
        // borderRadius: 50,
        // backgroundColor: color ?? unSelectedColor,
      ),
      child: const Icon(
        Icons.select_all,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      bottomNavigationBar: NavigationActionBar(
        context: context,
        animationCurve: Curves.decelerate,
        // accentColor: Colors.white,
        subItems: <NavBarItem>[
          NavBarItem(
            onPress: _handelClose,
            iconWidget: const OverlayItem(
              title: 'New job',
            ),
            containerStyle: CommonContainerModel(
              backgroundColor: Colors.white,
              alignment: Alignment.bottomCenter,
              paddingVertical: 0.01,
              marginHorizontal: 0.35,
              borderRadius: 0.1,
            ),
            size: 30,
          ),
          NavBarItem(
            onPress: _handelClose,
            iconWidget: const OverlayItem(
              title: 'New Quote',
              icon: Icons.create_new_folder_outlined,
            ),
            containerStyle: CommonContainerModel(
              backgroundColor: Colors.white,
              alignment: Alignment.bottomCenter,
              paddingVertical: 0.01,
              marginHorizontal: 0.35,
              borderRadius: 0.1,
            ),
            size: 30,
          ),
        ],
        onPressOverLay: () => _handelClose(0),
        mainIndex: 2,
        overLayColorOpacity: 0.5,
        rowSubItemDirection: false,
        columItemsSpaceBetween: DEVICE_HEIGHT * 0.07,
        overlayMarginBottom: DEVICE_HEIGHT * 0.12,
        accentColor: Colors.blue,
        height: DEVICE_HEIGHT * 0.1,
        scaffoldColor: Colors.transparent,
        items: <NavBarItem>[
          NavBarItem(
            iconData: Icons.home,
            onPress: _handelClose,
            size: 30,
            selectedColor: Colors.blue,
            text: 'Home',
          ),
          NavBarItem(
            iconData: Icons.safety_check,
            size: 30,
            onPress: _handelClose,
            selectedColor: Colors.blue,
          ),
          NavBarItem(
            iconWidget: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: _iconIndex == 0
                  ? const Icon(
                      Icons.add,
                      key: ValueKey('icon1'),
                      color: Colors.white,
                      size: 30,
                    )
                  : const Icon(
                      Icons.close,
                      key: ValueKey('icon2'),
                      color: Colors.white,
                      size: 30,
                    ),
            ),
            onPress: _handleOnPressed,
            size: 50,
          ),
          NavBarItem(
            iconData: Icons.person,
            size: 30,
            onPress: _handelClose,
            selectedColor: Colors.blue,
          ),
          NavBarItem(
            iconData: Icons.menu,
            size: 30,
            onPress: _handelClose,
            selectedColor: Colors.blue,
          ),
        ],
        onTap: (double index) {
          if (index == 2) {
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
      body: SizedBox(
        // color: Colors.blueAccent,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                currentIndex.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlayItem extends StatelessWidget {
  const OverlayItem({
    Key? key,
    this.title = '',
    this.icon,
  }) : super(key: key);

  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: '  $title',
      leftChild: Icon(
        icon ?? Icons.work,
      ),
    );
  }
}
