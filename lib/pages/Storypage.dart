import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramStories/data.dart';
import 'package:instagramStories/models/story.dart';
import 'package:instagramStories/widgets/User_info.dart';
import 'package:instagramStories/widgets/animatedBars.dart';
import 'package:video_player/video_player.dart';

class StoryPage extends StatefulWidget {
  final List<Story> stories;
  StoryPage({this.stories});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  PageController _controller;
  AnimationController animationController;
  VideoPlayerController _videoPlayerController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    animationController = AnimationController(vsync: this);

    Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.stop();
        animationController.reset();

        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex++;
          } else {
            _currentIndex = 0;
          }

          _loadStory(story: widget.stories[_currentIndex]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Story story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDownFunction(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.stories.length,
                itemBuilder: (context, index) {
                  Story story = widget.stories[index];

                  switch (story.media) {
                    case MediaType.image:
                      return CachedNetworkImage(
                        imageUrl: story.url,
                        fit: BoxFit.cover,
                      );
                      break;
                    case MediaType.video:
                      if (_videoPlayerController != null &&
                          _videoPlayerController.value.initialized) {
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            height: _videoPlayerController.value.size.height,
                            width: _videoPlayerController.value.size.width,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                        );
                      }
                      break;
                  }
                  return SizedBox.shrink();
                }),
            Positioned(
                top: 40,
                left: 10,
                right: 10,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: stories.asMap().map((i,e) => MapEntry(i,AnimatedBar(animController: animationController,currentIndex: _currentIndex,index: i,))).values.toList(),
                    ),
                    SizedBox(height: 5,),
                    UserInfo(user: story.user,),
                  ],
                )),
          ],
        ),
      ),
    );
  }

   @override
  void dispose() {
    _controller.dispose();
    animationController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  _onTapDownFunction(TapDownDetails details, Story story) {
    //Divide the screen into 3 parts
    double Width = MediaQuery.of(context).size.width;
    double tapPositionInXAxis = details.globalPosition.dx;

    // 1/3
    if (tapPositionInXAxis < Width / 3) {
      print("1/3");
      if (_currentIndex - 1 >= 0) {
        setState(() {
          _currentIndex--;
        });
        _loadStory(story: widget.stories[_currentIndex]);
      }
    } else if (tapPositionInXAxis > 2 * Width / 3) {
      print("3/3");
      if (_currentIndex + 1 < widget.stories.length) {
        setState(() {
          _currentIndex++;
        });
        _loadStory(story: widget.stories[_currentIndex]);
      }
    } else {
      print("2/3");
      if (story.media == MediaType.video) {
        if (_videoPlayerController.value.isPlaying) {
          _videoPlayerController.pause();
          animationController.stop();
        } else {
          _videoPlayerController.play();
          animationController.forward();
        }
      }
    }
  }

  void _loadStory({Story story, bool animateToPage = true}) {
    animationController.stop();
    animationController.reset();

    switch (story.media) {
      case MediaType.image:
        animationController.duration = story.duration;
        animationController.forward();
        break;
      case MediaType.video:
       _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController =
            VideoPlayerController.network(story.url)
              ..initialize().then((_) { 
                setState(() {});
        if (_videoPlayerController.value.initialized) {
          animationController.duration = _videoPlayerController.value.duration;
          _videoPlayerController.play();
          animationController.forward();
        }
        });

        break;
    }

    if (animateToPage) {
      _controller.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }
}
