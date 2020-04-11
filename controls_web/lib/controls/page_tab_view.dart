import 'dart:async';

import 'package:flutter/material.dart';

class PageTabViewController {
  TabController tabController;

  animateTo(index) {
    tabController.animateTo(index);
  }

  next() {
    tabController.animateTo(tabController.index + 1);
  }

  previus() {
    tabController.animateTo(tabController.previousIndex);
  }
}

class PageTabView extends StatefulWidget {
  final List<TabChoice> choices;
  final PageTabViewController controller;
  final int initialIndex;
  final Widget title;
  final List<Widget> actions;
  final double elevation;
  final Color tabColor;
  final Widget tabTitle;
  final List<Widget> tabActions;
  final double tabHeight;
  final Widget tabLeading;
  final bool isScrollable;
  final Widget Function(TabController, TabChoice, int) tabBuilder;
  final Color iconColor;
  final Color indicatorColor;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Widget leading;
  final Widget appBar;
  final Size preferredSize;
  final bool automaticallyImplyLeading;
  PageTabView({
    this.title,
    this.appBar,
    this.tabBuilder,
    this.elevation = 0.0,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.isScrollable = false,
    @required this.choices,
    this.initialIndex = 0,
    this.tabColor = Colors.blue,
    this.indicatorColor = Colors.white,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.iconColor = Colors.white,
    this.tabHeight = 55,
    this.tabActions,
    this.tabTitle,
    this.preferredSize,
    this.tabLeading,
    this.controller,
  });
  _TabBarViewState createState() => _TabBarViewState();
}

class _TabBarViewState extends State<PageTabView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ThemeData theme;
  @override
  void initState() {
    super.initState();
    indexSelected = widget.initialIndex;
    _tabController = TabController(vsync: this, length: widget.choices.length);
    _tabController.addListener(_nextPage);
    if (widget.controller != null) {
      widget.controller.tabController = _tabController;
    }
  }

  var tabChangeEvent = StreamController<int>.broadcast();
  @override
  void dispose() {
    _tabController.removeListener(_nextPage);
    _tabController.dispose();
    tabChangeEvent.close();
    super.dispose();
  }

  int indexSelected;

  void _nextPage({int delta = 0, int to}) {
    int newIndex = _tabController.index + delta;
    if (to != null) newIndex = to;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
    indexSelected = newIndex;
    tabChangeEvent.sink.add(newIndex);
  }

  List<Widget> _pages() {
    List<Widget> rt = [];
    if (widget.choices != null)
      widget.choices.forEach((c) {
        rt.add(c.child);
      });
    return rt;
  }

  createTab(ctrl, tc, idx, w) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(2),
        width: w ?? 200,
        height: widget.tabHeight,
        color: widget.tabColor,
        child: Column(
          children: <Widget>[
            Icon(tc.icon, size: 25, color: Colors.white),
            Text(tc.title, style: TextStyle(fontSize: 18, color: Colors.white))
          ],
        ),
      ),
      onTap: () {
        _nextPage(to: idx);
        //if (widget.controller != null) widget.controller.animateTo(idx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width / widget.choices.length;
    theme = Theme.of(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
            title: widget.title,
            elevation: widget.elevation,
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            actions: widget.actions,
            bottom: PreferredSize(
              child: Column(children: [
                if (widget.appBar != null) widget.appBar,
                Row(
                  children: <Widget>[
                    if (widget.tabLeading != null) widget.tabLeading,
                    Expanded(
                      child: Container(
                          height: widget.tabHeight,
                          constraints: BoxConstraints(maxWidth: 2000),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 0; i < widget.choices.length; i++)
                                  Container(
                                      width: widget.choices[i].width ?? w,
                                      child: Column(
                                        children: <Widget>[
                                          (widget.tabBuilder == null)
                                              ? Expanded(
                                                  child: createTab(
                                                      _tabController,
                                                      widget.choices[i],
                                                      i,
                                                      w))
                                              : Expanded(
                                                  child: widget.tabBuilder(
                                                      _tabController,
                                                      widget.choices[i],
                                                      i),
                                                ),
                                          StreamBuilder<int>(
                                              stream: tabChangeEvent.stream,
                                              initialData: indexSelected,
                                              builder: (context, snapshot) {
                                                //print(snapshot.data);
                                                return Container(
                                                  height: 3,
                                                  constraints: BoxConstraints(
                                                      maxWidth: 2000),
                                                  color: (snapshot.data != i)
                                                      ? widget.tabColor
                                                      : widget.indicatorColor,
                                                  //child:
                                                );
                                              })
                                        ],
                                      )),
                                if (widget.tabTitle != null) widget.tabTitle,
                              ])),
                    ),
                    for (var item in widget.tabActions ?? []) item
                  ],
                )
              ]),
              preferredSize: widget.preferredSize ??
                  Size.fromHeight((widget.appBar != null) ? 55 : 0),
            )),
        body: TabBarView(
          controller: _tabController, //_pageController,
          children: _pages(),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}

/*
 --------------------------------------------------------------------------
 */
class TabChoice {
  final int index;
  const TabChoice(
      {this.iconColor,
      this.index,
      this.title,
      this.icon,
      this.image,
      this.width,
      this.child});
  final double width;
  final String title;
  final IconData icon;
  final Widget child;
  final Widget image;
  final Color iconColor;
}
