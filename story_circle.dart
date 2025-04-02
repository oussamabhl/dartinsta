import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryCircle extends StatelessWidget {
  final Story story;
  final bool isYourStory;
  final VoidCallback onTap;

  const StoryCircle({
    Key? key,
    required this.story,
    this.isYourStory = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.isViewed || isYourStory
                    ? null
                    : const LinearGradient(
                        colors: [Colors.purple, Colors.orange, Colors.red],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(story.user.profilePicture),
                  child: isYourStory
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isYourStory ? 'Your Story' : story.user.username,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}