import 'package:flutter/material.dart';

class PanelBottom extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final Widget? child;
  const PanelBottom(
      {Key? key,
      this.child,
      this.color,
      this.height = 45,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cor = color ?? Theme.of(context).primaryColor.withAlpha(80);
    return Container(
      height: height,
      width: width,
      alignment: Alignment.centerLeft,
      child: Padding(padding: const EdgeInsets.only(left: 8), child: child),
      color: cor,
    );
  }
}

class PanelTitle extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final Widget? child;
  const PanelTitle(
      {Key? key,
      this.child,
      this.color,
      this.height = 45,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cor = color ?? Theme.of(context).primaryColor.withAlpha(120);
    return Container(
      height: height,
      width: width,
      alignment: Alignment.centerLeft,
      child: Padding(padding: const EdgeInsets.only(left: 8), child: child),
      color: cor,
    );
  }
}

class Panel extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Widget? title;
  final Widget? appBar;
  final List<Widget>? actions;
  final double? elevation;
  final EdgeInsets? margin;
  final Clip? clipBehavior;
  final ShapeBorder? shape;
  final Widget? leading;
  const Panel(
      {Key? key,
      this.appBar,
      this.margin,
      this.color,
      this.elevation,
      this.child,
      this.title,
      this.leading,
      this.actions,
      this.shape,
      this.clipBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool bappBar = (title != null);
    return Card(
      elevation: elevation,
      margin: margin,
      color: color,
      clipBehavior: clipBehavior,
      shape: shape,
      child: Column(
        children: <Widget>[
          appBar ??
              (bappBar
                  ? AppBar(
                      title: title,
                      automaticallyImplyLeading: false,
                      elevation: 0.0,
                      actions: actions,
                      leading: leading,
                    )
                  : Container()),
          Expanded(
            child: child!,
          )
        ],
      ),
    );
  }
}

class PanelUserTile extends StatefulWidget {
  final String? title;
  final int? alpha;
  final List<Widget>? actions;
  final double? heigth;
  final Widget? user;
  final Widget? image;
  PanelUserTile(
      {this.user,
      this.title,
      this.image,
      this.actions,
      this.heigth,
      this.alpha = 150,
      key})
      : super(key: key);

  _PanelUserTileState createState() => _PanelUserTileState();
}

class _PanelUserTileState extends State<PanelUserTile> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
        child: Container(
      height: widget.heigth,
      color: color.withAlpha(widget.alpha!),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 10,
        ),
        Center(
          child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              child: CircleAvatar(child: widget.image ?? Icon(Icons.person))),
        ),
        widget.user ?? Container(),
      ]),
    ));
  }
}

class ListTileMenuItem extends StatelessWidget {
  final Widget? title;
  final Function? onTap;
  const ListTileMenuItem({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: () => onTap!(),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
