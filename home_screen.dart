import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../models/story.dart';
import '../../models/user.dart';
import '../../widgets/post_item.dart';
import '../../widgets/story_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Story> stories = [];
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    // Mock data - in a real app, you would fetch from an API
    await Future.delayed(const Duration(seconds: 1));
    
    final mockUser = User(
      id: '1',
      username: 'johndoe',
      fullName: 'John Doe',
      profilePicture: 'https://randomuser.me/api/portraits/men/1.jpg',
    );

    final mockStories = List.generate(
      10,
      (index) => Story(
        id: index.toString(),
        user: User(
          id: index.toString(),
          username: 'user$index',
          fullName: 'User $index',
          profilePicture: 'https://randomuser.me/api/portraits/men/${index + 1}.jpg',
        ),
        mediaUrl: 'https://picsum.photos/500/800?random=$index',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      ),
    );

    final mockPosts = List.generate(
      15,
      (index) => Post(
        id: index.toString(),
        user: User(
          id: (index % 5).toString(),
          username: 'user${index % 5}',
          fullName: 'User ${index % 5}',
          profilePicture: 'https://randomuser.me/api/portraits/men/${(index % 5) + 1}.jpg',
        ),
        mediaUrl: 'https://picsum.photos/500/500?random=$index',
        mediaType: index % 3 == 0 ? MediaType.video : MediaType.image,
        caption: 'This is post $index with a longer caption to test how it looks in the UI.',
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
        likesCount: index * 100 + 50,
        commentsCount: index * 10 + 5,
      ),
    );

    setState(() {
      stories = mockStories;
      posts = mockPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/instagram_logo.png',
          height: 40,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              // Navigate to create post screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {
              // Navigate to direct messages
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                children: [
                  // Stories
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stories.length + 1, // +1 for your story
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Your story
                          return StoryCircle(
                            story: Story(
                              id: 'your-story',
                              user: User(
                                id: 'your-id',
                                username: 'You',
                                fullName: 'Your Name',
                                profilePicture: 'https://randomuser.me/api/portraits/men/0.jpg',
                              ),
                              mediaUrl: '',
                              createdAt: DateTime.now(),
                            ),
                            isYourStory: true,
                            onTap: () {
                              // Navigate to create story
                            },
                          );
                        }
                        return StoryCircle(
                          story: stories[index - 1],
                          onTap: () {
                            // Navigate to view story
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  // Posts
                  ...posts.map((post) => PostItem(
                        post: post,
                        onLike: () {
                          // Handle like
                        },
                        onComment: () {
                          // Navigate to comments
                        },
                        onProfile: () {
                          // Navigate to profile
                        },
                      )),
                ],
              ),
            ),
    );
  }
}