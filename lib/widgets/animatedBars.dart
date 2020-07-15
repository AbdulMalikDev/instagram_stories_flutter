import 'package:flutter/material.dart';
import 'package:instagramStories/models/story.dart';

class AnimatedBar extends StatelessWidget {
  AnimationController animController;
  int currentIndex;
  int index;
  AnimatedBar({this.index, this.animController, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  index < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                index==currentIndex
                ?AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) =>  _buildContainer(
                  constraints.maxWidth * animController.value,
                  Colors.white,
                ),
                )
               
                :SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

_buildContainer(width, color) {
  return Container(
    width: width,
    height: 5,
    decoration: BoxDecoration(
      color: color,
        border: Border.all(color: Colors.black26,width: 0.8),
        borderRadius: BorderRadius.circular(5)),
  );
}
