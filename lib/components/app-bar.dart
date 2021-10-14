import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_app/helpers/debouncer.dart';

// ignore: must_be_immutable
class AppBarComponent extends StatelessWidget {
  List<Widget> actions = [];
  final PreferredSizeWidget bottom;
  Widget flexibleSpace;
  final Widget title;
  final Function(String) onChange;
  final Function onClose;
  Duration delayChange;

  AppBarComponent({
    @required this.title,
    List<Widget> actions,
    this.bottom,
    @required this.onChange,
    @required this.onClose,
    Duration delayChange,
  }) {
    if (delayChange == null) this.delayChange = Duration(milliseconds: 300);

    if (actions != null) {
      this.actions.addAll(actions);
    }
  }

  @override
  Widget build(BuildContext context) => AppBarComponentState(
        title: title,
        bottom: bottom,
        actions: actions,
        onChange: onChange,
        onClose: onClose,
        delayChange: delayChange,
      );
}

// ignore: must_be_immutable
class AppBarComponentState extends StatefulWidget {
  final List<Widget> actions;
  final PreferredSizeWidget bottom;
  final Widget title;
  final Function(String) onChange;
  final Function onClose;
  final Duration delayChange;

  AppBarComponentState({
    @required this.title,
    this.actions,
    this.bottom,
    @required this.onChange,
    @required this.onClose,
    this.delayChange,
  });

  @override
  State<StatefulWidget> createState() => _AppBarComponentState(
        actions: actions,
        bottom: bottom,
        title: title,
        onChange: onChange,
        onClose: onClose,
        delayChange: delayChange,
      );
}

class _AppBarComponentState extends State<AppBarComponentState> {
  List<Widget> actions;
  final PreferredSizeWidget bottom;
  Widget flexibleSpace;
  final Widget title;
  final Function(String) onChange;
  final Function onClose;
  final Duration delayChange;

  Debouncer debouncer;
  bool open = false;
  Widget icon;
  bool init;

  _AppBarComponentState({
    @required this.title,
    this.actions,
    this.bottom,
    @required this.onChange,
    @required this.onClose,
    this.delayChange,
  }) {
    if (actions != null) this.actions = actions;
    init = true;

    debouncer = Debouncer(delayChange);

    flexibleSpace = FlexibleSpaceBar.createSettings(
      currentExtent: 1,
      child: FlexibleSpaceBar(
        title: TextField(
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) => debouncer.run(() => onChange(value)),
        ),
        titlePadding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: actions,
      bottom: !open ? bottom : null,
      title: title,
      pinned: true,
      expandedHeight: open ? 105 : 0,
      flexibleSpace: open ? flexibleSpace : null,
    );
  }
}
