import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:unikwik_app/presentation/widgets/glass_dropdown_chip.dart';

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget({Key? key}) : super(key: key);

  @override
  State<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends State<QuestionsWidget> {
  String _selectedCategory = 'All';
  String _sortBy = 'Latest';
  bool _showAskQuestionPopup = false;

  final List<String> _categories = [
    'All',
    'Academic',
    'Visa',
    'Accommodation',
    'Social',
    'Technical',
    'General'
  ];

  final List<String> _sortOptions = ['Latest', 'Oldest', 'Most Liked', 'Most Comments'];

  // Mock questions data
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'emoji': '🎓',
      'name': 'Sarah Chen',
      'time': '2 hours ago',
      'date': 'Dec 15, 2024',
      'category': 'Academic',
      'question': 'What are the best universities for Computer Science in Germany? I\'m looking for programs with strong industry connections.',
      'likes': 24,
      'comments': 8,
      'isLiked': false,
      'replies': [
        {
          'name': 'Alex Kumar',
          'time': '1 hour ago',
          'reply': 'TU Munich and RWTH Aachen are excellent choices! Both have strong industry partnerships.',
          'likes': 12,
          'isLiked': false,
        },
        {
          'name': 'Maria Rodriguez',
          'time': '30 min ago',
          'reply': 'Don\'t forget about KIT in Karlsruhe. Great research opportunities there.',
          'likes': 8,
          'isLiked': true,
        },
      ],
      'showReplies': false,
    },
    {
      'id': 2,
      'emoji': '🏠',
      'name': 'David Kim',
      'time': '5 hours ago',
      'date': 'Dec 15, 2024',
      'category': 'Accommodation',
      'question': 'How do I find student accommodation in Berlin? Any tips for international students?',
      'likes': 18,
      'comments': 12,
      'isLiked': true,
      'replies': [
        {
          'name': 'Lisa Wang',
          'time': '4 hours ago',
          'reply': 'Start early! Studentenwerk Berlin has good options, but apply months in advance.',
          'likes': 15,
          'isLiked': false,
        },
      ],
      'showReplies': false,
    },
    {
      'id': 3,
      'emoji': '📋',
      'name': 'Ahmed Hassan',
      'time': '1 day ago',
      'date': 'Dec 14, 2024',
      'category': 'Visa',
      'question': 'What documents do I need for a German student visa? Is there anything specific for engineering students?',
      'likes': 31,
      'comments': 15,
      'isLiked': false,
      'replies': [
        {
          'name': 'Emma Thompson',
          'time': '1 day ago',
          'reply': 'You\'ll need acceptance letter, financial proof, health insurance, and passport. Engineering students might need additional academic transcripts.',
          'likes': 22,
          'isLiked': true,
        },
        {
          'name': 'Carlos Mendez',
          'time': '20 hours ago',
          'reply': 'Don\'t forget to book your visa appointment early! The waiting times can be long.',
          'likes': 18,
          'isLiked': false,
        },
      ],
      'showReplies': false,
    },
  ];

  // Filtering and sorting logic
  List<Map<String, dynamic>> get _filteredQuestions {
    List<Map<String, dynamic>> filtered = _selectedCategory == 'All'
        ? List<Map<String, dynamic>>.from(_questions)
        : _questions.where((q) => q['category'] == _selectedCategory).toList();

    switch (_sortBy) {
      case 'Oldest':
        filtered.sort((a, b) => a['id'].compareTo(b['id']));
        break;
      case 'Most Liked':
        filtered.sort((a, b) => b['likes'].compareTo(a['likes']));
        break;
      case 'Most Comments':
        filtered.sort((a, b) => b['comments'].compareTo(a['comments']));
        break;
      case 'Latest':
      default:
        filtered.sort((a, b) => b['id'].compareTo(a['id']));
        break;
    }
    return filtered;
  }

  // Track reply text for each question by ID
  final Map<int, TextEditingController> _replyControllers = {};

  void _collapseAllReplies() {
    setState(() {
      for (var q in _questions) {
        q['showReplies'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Row (Category and Sort)
                Row(
                  children: [
                    Expanded(
                      child: GlassDropdownChip<String>(
                        placeholder: 'Category',
                        selectedValue: _selectedCategory,
                        options: _categories,
                        labelBuilder: (cat) => cat,
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val ?? 'All';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassDropdownChip<String>(
                        placeholder: 'Sort By',
                        selectedValue: _sortBy,
                        options: _sortOptions,
                        labelBuilder: (sort) => sort,
                        onChanged: (val) {
                          setState(() {
                            _sortBy = val ?? 'Latest';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Ask Question Button (own row)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAskQuestionPopup = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.withOpacity(0.8), Colors.purple.withOpacity(0.8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Ask a Question',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Questions List with outside tap detection
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _collapseAllReplies,
                    child: _filteredQuestions.isEmpty
                        ? Center(
                            child: Text(
                              'No questions found.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredQuestions.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, idx) {
                              final question = _filteredQuestions[idx];
                              final qid = question['id'] as int;
                              _replyControllers.putIfAbsent(qid, () => TextEditingController());
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {}, // Prevents tap from bubbling up
                                child: QuestionCard(
                                  question: question,
                                  onLike: () => _toggleLike(qid),
                                  onComment: () => _toggleReplies(qid),
                                  onReplyLike: (replyIdx) => _toggleReplyLike(qid, replyIdx),
                                  replyController: _replyControllers[qid]!,
                                  onReply: () {
                                    final text = _replyControllers[qid]!.text.trim();
                                    if (text.isNotEmpty) {
                                      setState(() {
                                        question['replies'].add({
                                          'name': 'You',
                                          'time': 'now',
                                          'reply': text,
                                          'likes': 0,
                                          'isLiked': false,
                                        });
                                        _replyControllers[qid]!.clear();
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showAskQuestionPopup)
          Positioned.fill(
            child: AskQuestionPopup(
              onClose: () {
                setState(() {
                  _showAskQuestionPopup = false;
                });
              },
            ),
          ),
      ],
    );
  }

  void _toggleLike(int questionId) {
    setState(() {
      final question = _questions.firstWhere((q) => q['id'] == questionId);
      question['isLiked'] = !question['isLiked'];
      question['likes'] += question['isLiked'] ? 1 : -1;
    });
  }

  void _toggleReplies(int questionId) {
    setState(() {
      final question = _questions.firstWhere((q) => q['id'] == questionId);
      question['showReplies'] = !question['showReplies'];
    });
  }

  void _toggleReplyLike(int questionId, int replyIndex) {
    setState(() {
      final question = _questions.firstWhere((q) => q['id'] == questionId);
      final reply = question['replies'][replyIndex];
      reply['isLiked'] = !reply['isLiked'];
      reply['likes'] += reply['isLiked'] ? 1 : -1;
    });
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final Function(int) onReplyLike;
  final TextEditingController replyController;
  final VoidCallback onReply;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onLike,
    required this.onComment,
    required this.onReplyLike,
    required this.replyController,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07), // Unified card color
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                question['emoji'],
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${question['time']} • ${question['date']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Category Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Text(
                  question['category'],
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Question Text
          Text(
            question['question'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Actions Row
          Row(
            children: [
              // Like Button
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      question['isLiked'] ? Icons.favorite : Icons.favorite_border,
                      color: question['isLiked'] ? Colors.red[300] : Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${question['likes']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Comment Button
              GestureDetector(
                onTap: onComment,
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${question['comments']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Replies Section
          if (question['showReplies'] && question['replies'].isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  ...List.generate(
                    question['replies'].length,
                    (index) => ReplyCard(
                      reply: question['replies'][index],
                      onLike: () => onReplyLike(index),
                    ),
                  ),
                  // Reply input
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: replyController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Write a reply...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.08),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onReply,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: const Text('Reply'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final Map<String, dynamic> reply;
  final VoidCallback onLike;

  const ReplyCard({
    Key? key,
    required this.reply,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reply['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                reply['time'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reply['reply'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onLike,
            child: Row(
              children: [
                Icon(
                  reply['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  color: reply['isLiked'] ? Colors.red[300] : Colors.white.withOpacity(0.5),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${reply['likes']}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AskQuestionPopup extends StatefulWidget {
  final VoidCallback onClose;

  const AskQuestionPopup({Key? key, required this.onClose}) : super(key: key);

  @override
  State<AskQuestionPopup> createState() => _AskQuestionPopupState();
}

class _AskQuestionPopupState extends State<AskQuestionPopup> {
  String _selectedCategory = 'General';
  final TextEditingController _questionController = TextEditingController();
  final List<String> _categories = [
    'Academic',
    'Visa',
    'Accommodation',
    'Social',
    'Technical',
    'General'
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ask a Question',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Category Dropdown
                Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GlassDropdownChip<String>(
                  placeholder: 'Select Category',
                  selectedValue: _selectedCategory,
                  options: _categories,
                  labelBuilder: (category) => category,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'General';
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Question Text Field
                Text(
                  'Your Question',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: _questionController,
                    maxLines: 4,
                    maxLength: 500,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your question here...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      counterStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Submit Button
                GestureDetector(
                  onTap: () {
                    if (_questionController.text.trim().isNotEmpty) {
                      // TODO: Handle question submission
                      widget.onClose();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.withOpacity(0.8), Colors.purple.withOpacity(0.8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Post Question',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).asGlass(
            blurX: 20,
            blurY: 20,
            tintColor: Colors.white.withOpacity(0.2),
            clipBorderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}