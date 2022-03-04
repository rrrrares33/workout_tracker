import 'package:flutter/material.dart';
import 'padding.dart';
import 'text.dart';

class SliverTopBar extends StatelessWidget {
  const SliverTopBar(
      {Key? key,
      required this.expandedHeight,
      required this.toolbarHeight,
      required this.textExpanded,
      required this.textToolbar,
      required this.showBigTitle})
      : super(key: key);
  final double expandedHeight;
  final double toolbarHeight;
  final bool showBigTitle;
  final String textExpanded;
  final String textToolbar;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: expandedHeight,
      toolbarHeight: toolbarHeight,
      centerTitle: true,
      title: showBigTitle
          ? PaddingWidget(
              type: 'only',
              onlyTop: 10,
              child: TextWidget(
                text: textExpanded,
                color: Colors.black,
                fontSize: 17,
              ),
            )
          : null,
      flexibleSpace: showBigTitle
          ? null
          : FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomLeft,
                child: PaddingWidget(
                  type: 'only',
                  onlyLeft: 15,
                  child: TextWidget(
                    text: textToolbar,
                    fontSize: 27,
                  ),
                ),
              ),
            ),
    );
  }
}
