import 'package:flutter/material.dart';

class FABItem {
  final FloatingActionButton fab;
  final String name;

  FABItem({
    @required this.fab,
    @required this.name,
  });
}

class CustomAnimatedFAB extends StatefulWidget {
  final List<FABItem> items;
  final Color activeColor;
  final Color passiveColor;
  final bool textEnabled;
  final TextStyle textStyle;
  final AnimatedIconData openCloseIndicator;
  final Color iconColor;

  CustomAnimatedFAB(
      {@required this.items,
      @required this.activeColor,
      @required this.passiveColor,
      @required this.textEnabled,
      this.textStyle,
      this.openCloseIndicator,
      this.iconColor});

  @override
  _CustomAnimatedFABState createState() => _CustomAnimatedFABState();
}

class _CustomAnimatedFABState extends State<CustomAnimatedFAB>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            if (this.mounted) {
              setState(() {});
            }
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.passiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            //  Tag: 'toggle',
            backgroundColor: _buttonColor.value,
            onPressed: animate,
            child: AnimatedIcon(
              icon: widget.openCloseIndicator != null
                  ? widget.openCloseIndicator
                  : AnimatedIcons.menu_close,
              progress: _animateIcon,
              color: widget.iconColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fabs() {
      List<Widget> fabList = new List();
      for (var i = 0; i < widget.items.length; i++) {
        var fabObject = Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * (widget.items.length - i),
            0.0,
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                isOpened && widget.textEnabled
                    ? Text(
                        widget.items[i].name,
                        style: widget.textStyle,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 9,
                ),
                widget.items[i].fab,
              ],
            ),
          ),
        );
        fabList.add(fabObject);
      }
      fabList.add(toggle());

      return fabList;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: fabs(),
    );
  }
}
