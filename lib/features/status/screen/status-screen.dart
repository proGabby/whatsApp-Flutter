import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

import 'package:whatsapp_clone/resources/common/circularLoader.dart';

import '../../../models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  //creating a controller for the story
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    //initialise the storypage
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrlList.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrlList[i],
        controller: controller,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const CircularLoader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
