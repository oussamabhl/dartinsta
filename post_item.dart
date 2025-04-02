import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import '../models/post.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onProfile;

  const PostItem({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onProfile,
  }) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool liked = false;
  int likesCount = 0;
  bool showMore = false;
  VideoPlayerController? _videoController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    liked = widget.post.isLiked;
    likesCount = widget.post.likesCount;

    if (widget.post.mediaType == MediaType.video) {
      _videoController = VideoPlayerController.network(widget.post.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      liked = !liked;
      likesCount = liked ? likesCount + 1 : likesCount - 1;
    });
    widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onProfile,
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post.user.profilePicture),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onProfile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (widget.post.location.isNotEmpty)
                        Text(
                          widget.post.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.caption?.color,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show post options
                },
              ),
            ],
          ),
        ),

        // Post media
        GestureDetector(
          onDoubleTap: _handleLike,
          child: widget.post.mediaType == MediaType.video
              ? AspectRatio(
                  aspectRatio: _videoController?.value.aspectRatio ?? 1.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController!),
                      if (!isPlaying)
                        IconButton(
                          icon: const Icon(
                            Icons.play_circle_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isPlaying = true;
                              _videoController?.play();
                            });
                          },
                        ),
                    ],
                  ),
                )
              : Image.network(
                  widget.post.mediaUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),

        // Post actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : null,
                ),
                onPressed: _handleLike,
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: widget.onComment,
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {
                  // Share post
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Save post
                },
              ),
            ],
          ),
        ),

        // Likes count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$likesCount likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Caption
        if (widget.post.caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),
                children: [
                  TextSpan(
                    text: widget.post.user.username + ' ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: showMore || widget.post.caption.length <= 100
                        ? widget.post.caption
                        : widget.post.caption.substring(0, 100) + '...',
                  ),
                  if (widget.post.caption.length > 100 && !showMore)
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showMore = true;
                          });
                        },
                        child: Text(
                          ' more',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

        // Comments link
        if (widget.post.commentsCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: widget.onComment,
              child: Text(
                'View all ${widget.post.commentsCount} comments',
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption?.color,
                ),
              ),
            ),
          ),

        // Timestamp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            timeago.format(widget.post.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.caption?.color,
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}