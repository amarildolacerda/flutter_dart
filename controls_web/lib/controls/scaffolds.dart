import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class ScaffoldSplash extends StatefulWidget {
  final Widget? body;
  final Widget? image;
  final Widget? toptitle;
  final String? title;
  final AppBar? appBar;
  final Drawer? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? child;
  final Function? onPressed;
  final String? buttonName;
  final Color? backgroundColor;
  final double? topMargin;
  ScaffoldSplash({
    Key? key,
    this.appBar,
    this.drawer,
    this.toptitle,
    this.title,
    this.topMargin = 30,
    this.backgroundColor,
    this.image,
    this.onPressed,
    this.buttonName,
    this.body,
    this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  _ScaffoldSplashState createState() => _ScaffoldSplashState();
}

class _ScaffoldSplashState extends State<ScaffoldSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      drawer: widget.drawer,
      appBar: widget.appBar,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: widget.topMargin,
          ),
          Container(child: Center(child: widget.image)),
          if (widget.toptitle != null) widget.toptitle!,
          if (widget.title != null) ...[
            SizedBox(
              height: 40,
            ),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.title ?? '',
                  softWrap: true,
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 30,
            ),
          ],
          if (widget.body != null) widget.body!,
          if (widget.onPressed != null)
            RoundedButton(
              height: 40,
              width: 180,
              buttonName: widget.buttonName ?? 'Entrar',
              onTap: () {
                if (widget.onPressed != null) widget.onPressed!();
              },
            ),
          if (widget.child != null) widget.child!,
        ]),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
