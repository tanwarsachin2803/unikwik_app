import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  bool _sortLatest = true;
  late List<Map<String, dynamic>> _feeds;
  final Set<int> _expandedFeeds = {};
  final Map<int, TextEditingController> _replyControllers = {};

  final List<Map<String, dynamic>> _mockFeeds = [
    {
      'author': 'Amit Sharma',
      'avatar': '🧑‍🎓',
      'text': 'Just got my Canada visa approved! 🇨🇦 #visa',
      'likes': 12,
      'comments': 3,
      'views': 120,
      'tag': '#visa',
      'emoji': '🎉',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      '_replies': ['Congrats!', 'Awesome news!'],
    },
    {
      'author': 'Sara Lee',
      'avatar': '👩‍💼',
      'text': 'Looking for accommodation near TU Munich. Any tips? #housing',
      'likes': 7,
      'comments': 2,
      'views': 80,
      'tag': '#housing',
      'emoji': '🏠',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      '_replies': ['Try Facebook groups!', 'Check university notice boards.'],
    },
    {
      'author': 'John Doe',
      'avatar': '🧑‍💻',
      'text': 'Excited to start my internship at Google next week! #career',
      'likes': 20,
      'comments': 5,
      'views': 200,
      'tag': '#career',
      'emoji': '🚀',
      'date': DateTime.now().subtract(const Duration(hours: 10)),
      '_replies': ['Good luck!', 'You deserve it!'],
    },
    {
      'author': 'Priya Singh',
      'avatar': '👩‍🎓',
      'text': 'Anyone here from Delhi University? Let\'s connect! #networking',
      'likes': 9,
      'comments': 1,
      'views': 60,
      'tag': '#networking',
      'emoji': '🤝',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      '_replies': [],
    },
    {
      'author': 'Carlos Mendez',
      'avatar': '🧑‍🏫',
      'text': 'Shared my experience about studying in Germany on my blog. Check it out! #studyabroad',
      'likes': 15,
      'comments': 4,
      'views': 150,
      'tag': '#studyabroad',
      'emoji': '✈️',
      'date': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      '_replies': ['Thanks for sharing!', 'Very helpful!'],
    },
    {
      'author': 'Emily Chen',
      'avatar': '👩‍🔬',
      'text': 'Passed my IELTS exam with flying colors! #achievement',
      'likes': 18,
      'comments': 6,
      'views': 170,
      'tag': '#achievement',
      'emoji': '🏅',
      'date': DateTime.now().subtract(const Duration(hours: 20)),
      '_replies': ['Congrats!', 'Well done!'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _sortFeeds();
  }

  void _sortFeeds() {
    _feeds = _mockFeeds
        .where((f) => f['date'].isAfter(DateTime.now().subtract(const Duration(days: 3))))
        .toList();
    _feeds.sort((a, b) => _sortLatest
        ? b['date'].compareTo(a['date'])
        : a['date'].compareTo(b['date']));
    setState(() {});
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedFeeds.contains(index)) {
        _expandedFeeds.remove(index);
      } else {
        _expandedFeeds.add(index);
        _replyControllers.putIfAbsent(index, () => TextEditingController());
      }
    });
  }

  void _addReply(int index) {
    final controller = _replyControllers[index];
    if (controller != null && controller.text.trim().isNotEmpty) {
      setState(() {
        _feeds[index]['_replies'].add(controller.text.trim());
        controller.clear();
      });
    }
  }

  // Cancels the comment operation (closes the expanded comment/reply UI for the given feed)
  void _removeFeed(int index) {
    setState(() {
      _expandedFeeds.remove(index);
      _replyControllers[index]?.clear();
    });
  }

  void _likeFeed(int index) {
    setState(() {
      _feeds[index]['likes'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    _sortLatest = !_sortLatest;
                    _sortFeeds();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      Icon(_sortLatest ? Icons.arrow_downward : Icons.arrow_upward,
                          color: AppColors.deepTeal),
                      const SizedBox(width: 6),
                      Text(_sortLatest ? 'Latest' : 'Oldest',
                          style: const TextStyle(
                              color: AppColors.deepTeal,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            itemCount: _feeds.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, i) {
              final feed = _feeds[i];
              final expanded = _expandedFeeds.contains(i);
              final replies = List<String>.from(feed['_replies'] ?? []);
              return _FeedCard(
                feed: feed,
                expanded: expanded,
                replies: replies,
                replyController: _replyControllers[i],
                onLike: () => _likeFeed(i),
                onComment: () => _toggleExpand(i),
                onSendReply: () => _addReply(i),
                onX: () => _removeFeed(i),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  final Map<String, dynamic> feed;
  final bool expanded;
  final List<String> replies;
  final TextEditingController? replyController;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onSendReply;
  final VoidCallback onX;
  const _FeedCard({
    required this.feed,
    required this.expanded,
    required this.replies,
    required this.replyController,
    required this.onLike,
    required this.onComment,
    required this.onSendReply,
    required this.onX,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.sand.withOpacity(0.85),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(feed['avatar'], style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(feed['author'],
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                        if (feed['tag'] != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(feed['tag'], style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(feed['text'], maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.2),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticInOut,
                          builder: (_, scale, child) => Transform.scale(
                            scale: scale,
                            child: Text(feed['emoji'], style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: onLike,
                          child: _StatItem(icon: Icons.thumb_up, value: feed['likes'], color: Colors.deepOrange),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onComment,
                          child: _StatItem(icon: Icons.comment, value: feed['comments'], color: Colors.blue),
                        ),
                      ],
                    ),
                    if (expanded) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: replyController,
                              decoration: const InputDecoration(
                                hintText: 'Write a reply...',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: onSendReply,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepTeal,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            child: const Text('Send', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(                            
                          onPressed: onX,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepTeal,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            child: const Text('X', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...replies.map((reply) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feed['avatar'], style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.deepTeal)),
                            const SizedBox(width: 6),
                            Text(feed['author'], style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            Expanded(child: Text(reply)),
                            Spacer(),
                            Text('28 March', style: TextStyle(fontSize: 12,color: Colors.grey)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ).asGlass(
            tintColor: Colors.white.withOpacity(0.13),
            blurX: 12,
            blurY: 12,
            clipBorderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _StatItem({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(value.toString()),
      ],
    );
  }
}
