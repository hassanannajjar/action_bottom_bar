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
  AnimationController? _animationController;
  bool isPlaying = false;

  @override
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  void _handleOnPressed(value) {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController!.forward()
          : _animationController!.reverse();
    });
  }

  void _handelClose(value) {
    if (isPlaying) {
      setState(() {
        isPlaying = !isPlaying;
        _animationController!.reverse();
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
      bottomNavigationBar: NavigationActionBar(
        context: context,
        animationCurve: Curves.decelerate,
        // accentColor: Colors.white,
        subItems: <NavBarItem>[
          NavBarItem(
            onPress: _handelClose,
            iconData: Icons.abc_outlined,
            size: 30,
          ),
          NavBarItem(
            onPress: _handelClose,
            iconData: Icons.one_x_mobiledata,
            size: 30,
          ),
        ],
        mainIndex: 2,
        // accentColor: Colors.blue,
        items: <NavBarItem>[
          NavBarItem(
            iconData: Icons.home,
            onPress: _handelClose,
            size: 30,
          ),
          NavBarItem(
            iconData: Icons.safety_check,
            size: 30,
            onPress: _handelClose,
          ),
          NavBarItem(
            iconWidget: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              size: 30,
              progress: _animationController!,
              semanticLabel: 'Show menu',
            ),
            onPress: _handleOnPressed,
            size: 40,
          ),
          NavBarItem(
            iconData: Icons.person,
            size: 30,
            onPress: _handelClose,
          ),
          NavBarItem(
            iconData: Icons.menu,
            size: 30,
            onPress: _handelClose,
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
      body: Container(
        color: Colors.blueAccent,
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
