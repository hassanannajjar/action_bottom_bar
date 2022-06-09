library navigation_action_bar;

import 'package:common_ui_toolkit/common_ui_toolkit.dart';

import 'src/item.dart';
import 'src/painter.dart';

class NavigationActionBar extends StatefulWidget {
  NavigationActionBar({
    required this.items,
    required this.mainIndex,
    required this.subItems,
    this.overLayColor = Colors.white,
    this.overLayColorOpacity = 0.5,
    this.onPressOverLay,
    this.index = 0,
    this.accentColor = Colors.redAccent,
    this.backgroundColor = Colors.white,
    this.scaffoldColor = Colors.blueAccent,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 300),
    this.context,
    this.subItemSpacing = 150,
    this.animationCurve = Curves.bounceOut,
    this.rowSubItemDirection = false,
    this.columItemsSpaceBetween = 80,
    Key? key,
  })  : assert(context != null, 'context is required'),
        assert(items.isNotEmpty, 'items is required'),
        assert(0 <= index && index < items.length, 'index is out of range'),
        assert(0 <= mainIndex && mainIndex < items.length,
            'mainIndex is out of range'),
        super(key: key);
  final BuildContext? context;
  final List<NavBarItem> items;
  final int index;
  final int mainIndex;
  final double subItemSpacing;
  final Color accentColor;
  final Color backgroundColor;
  final Color scaffoldColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final ValueChanged<double>? onTap;
  final List<NavBarItem> subItems;
  final Color overLayColor;
  final double overLayColorOpacity;
  final double columItemsSpaceBetween;
  final Function()? onPressOverLay;
  final bool rowSubItemDirection;

  @override
  NavigationActionBarState createState() => NavigationActionBarState();
}

class NavigationActionBarState extends State<NavigationActionBar>
    with SingleTickerProviderStateMixin {
  double height = 80;
  int? selectedIndex;
  AnimationController? controller;
  Animation<double>? translation;
  double? position;
  int? length;
  OverlayEntry? _overlayEntry;
  bool _overlayTrue = false;
  OverlayState? overlayState;

//  double splitAngle;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: widget.animationDuration);

    length = widget.items.length;
    position = widget.mainIndex / length!;
    overlayState = Overlay.of(context);

//    if (widget.subItems != null) {
//      splitAngle = 180 / (widget.subItems.length! + 1);
//    }

    translation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(
      CurvedAnimation(parent: controller!, curve: Curves.linear),
    );
    selectedIndex = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void _insertOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      double mid = widget.subItems.length / 2;
      // ignore: use_is_even_rather_than_modulo
      if (widget.subItems.length % 2 == 1) {
        mid = mid.floorToDouble();
      } else {
        mid = mid - 0.5;
      }
      return SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: controller!,
                    curve: Curves.slowMiddle,
                  ),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: controller!,
                      curve: const Interval(
                        1,
                        1,
                        curve: Curves.easeInToLinear,
                      ),
                    ),
                    child: CommonContainer(
                      onPress: () {
                        _overlayTrue = false;
                        controller!.reverse();
                        widget.onPressOverLay?.call();
                      },
                      style: CommonContainerModel(
                        height: 1,
                        width: 1,
                        backgroundColor: (widget.overLayColor)
                            .withOpacity(widget.overLayColorOpacity),
                      ),
                    ),
                  ),
                ),
              ),
              ...widget.subItems.reversed.map((NavBarItem item) {
                final int index = widget.subItems.indexOf(item);
                return Positioned(
                  bottom: widget.rowSubItemDirection
                      ? 100
                      : 100 + (index * widget.columItemsSpaceBetween),
                  left: widget.rowSubItemDirection
                      ? (0 +
                          ((index > mid)
                                  ? (index - mid) * widget.subItemSpacing
                                  : 0)
                              .toDouble())
                      : 0,
                  right: widget.rowSubItemDirection
                      ? (0 +
                          ((index < mid)
                                  ? (mid - index) * widget.subItemSpacing
                                  : 0)
                              .toDouble())
                      : 0,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: controller!,
                      curve: Interval(
                        0 + ((1 / length!) * (index)),
                        1.0 - index / widget.subItems.length / 4,
                        curve: Curves.easeInCubic,
                      ),
                    ),
                    child: ActionBarItem(
                      onTap: (double value) {
                        item.onPress?.call(value);
                        _buttonTap(value);
                        setState(() {
                          _overlayTrue = false;
                          controller!.reverse();
                        });
                      },
                      iconData: item.iconData,
                      iconWidget: item.iconWidget,
                      size: item.size!,
                      mainIndex: widget.mainIndex,
                      index: index,
                    ),
                  ),
                );
              }).toList()
            ],
          ),
        ),
      );
    });
    overlayState!.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.scaffoldColor,
        border: Border.all(width: 0, color: widget.scaffoldColor),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: CustomPaint(
              painter: Painter(
                position!,
                length!,
                widget.backgroundColor,
                Directionality.of(context),
              ),
              child: Container(
                height: height,
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.items.map((NavBarItem item) {
                final int index = widget.items.indexOf(item);
                if (index == widget.mainIndex) {
                  return SpecialBarItem(
                    animationController: controller!,
                    iconData: item.iconData,
                    iconWidget: item.iconWidget,
                    size: item.size!,
                    index: index,
                    onTap: (double value) {
                      item.onPress?.call(value);
                      _buttonTap(value);
                    },
                    color: widget.accentColor,
                  );
                } else {
                  return BarItem(
                    index: index,
                    onTap: (double value) {
                      item.onPress?.call(value);
                      _buttonTap(value);
                    },
                    iconData: item.iconData,
                    iconWidget: item.iconWidget,
                    size: item.size!,
                    selected: item.selectedColor,
                    unselected: item.unselectedColor,
                    currentIndex: selectedIndex!,
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _buttonTap(double index) {
    if (widget.onTap != null) {
      widget.onTap!(index);
      setState(() {
        selectedIndex = index.floor();
      });
      _handleOverlay(index);
    }
  }

  void _handleOverlay(double index) {
    if (index == widget.mainIndex) {
      if (_overlayTrue) {
        _removeOverlay();
      } else {
        _addOverlay();
      }
    } else {
      if (_overlayTrue) {
        _removeOverlay();
      }
    }
  }

  void _removeOverlay() {
    controller!.reverse();
    _overlayTrue = !_overlayTrue;
  }

  void _addOverlay() {
    if (_overlayEntry == null) {
      _insertOverlay(widget.context!);
    }
    controller!.forward();
    _overlayTrue = !_overlayTrue;
  }
}

class NavBarItem {
  NavBarItem({
    this.iconData,
    this.iconWidget,
    this.size,
    this.selectedColor = Colors.redAccent,
    this.unselectedColor = Colors.black,
    this.onPress,
  });
  final IconData? iconData;
  final Widget? iconWidget;
  final double? size;
  final Color selectedColor;
  final Color unselectedColor;
  final Function(double)? onPress;
}
