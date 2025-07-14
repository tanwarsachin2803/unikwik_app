import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// Mock Data
final List<Map<String, String>> countries = [
  {'name': 'Germany', 'flag': '🇩🇪'},
  {'name': 'USA', 'flag': '🇺🇸'},
  {'name': 'India', 'flag': '🇮🇳'},
  {'name': 'Canada', 'flag': '🇨🇦'},
  {'name': 'Australia', 'flag': '🇦🇺'},
];

final List<Map<String, dynamic>> mockChannels = [
  {
    'id': 1,
    'name': '#germany-jobs',
    'type': 'jobs',
    'country': 'Germany',
    'latestMessage': {'emoji': '💼', 'name': 'Anna', 'text': 'New job posted!'},
    'joined': false,
    'requests': [],
    'messages': [
      {'emoji': '💼', 'name': 'Anna', 'text': 'New job posted!', 'likes': 2, 'replies': []},
      {'emoji': '👨‍💻', 'name': 'Ben', 'text': 'Anyone hiring in Berlin?', 'likes': 1, 'replies': []},
    ],
  },
  {
    'id': 2,
    'name': '#germany-study',
    'type': 'study',
    'country': 'Germany',
    'latestMessage': {'emoji': '📚', 'name': 'Sara', 'text': 'Exam tips!'},
    'joined': true,
    'requests': [],
    'messages': [
      {'emoji': '📚', 'name': 'Sara', 'text': 'Exam tips!', 'likes': 3, 'replies': []},
    ],
  },
  {
    'id': 3,
    'name': '#germany-general',
    'type': 'general',
    'country': 'Germany',
    'latestMessage': {'emoji': '🎉', 'name': 'John', 'text': 'Welcome!'},
    'joined': false,
    'requests': [],
    'messages': [
      {'emoji': '🎉', 'name': 'John', 'text': 'Welcome!', 'likes': 0, 'replies': []},
    ],
  },
];

final List<Map<String, dynamic>> mockPeople = [
  {
    'id': 1,
    'name': 'Alice Schmidt',
    'image': null,
    'employed': true,
    'student': true,
    'company': 'SAP',
    'university': 'Technical University of Munich',
    'social': ['linkedin'],
    'personalComplete': true,
  },
  {
    'id': 2,
    'name': 'Rahul Verma',
    'image': null,
    'employed': false,
    'student': true,
    'company': null,
    'university': 'RWTH Aachen',
    'social': [],
    'personalComplete': false,
  },
  {
    'id': 3,
    'name': 'Emily Wang',
    'image': null,
    'employed': true,
    'student': false,
    'company': 'Siemens',
    'university': null,
    'social': ['facebook'],
    'personalComplete': true,
  },
];

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({Key? key}) : super(key: key);

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  String selectedCountry = countries[0]['name']!;
  List<Map<String, dynamic>> joinedChannels = [];
  List<Map<String, dynamic>> people = mockPeople;
  List<Map<String, dynamic>> channels = mockChannels;

  // University dropdown
  String? selectedUniversity;
  List<Map<String, dynamic>> universities = [];

  Map<String, dynamic>? selectedChannel;
  int? replyToMessageIdx;

  bool showAddChannel = false;
  String newChannelName = '';
  String? addChannelError;
  bool isChannelValid = false;
  int? pendingChannelId;

  @override
  void initState() {
    super.initState();
    joinedChannels = channels.where((c) => c['joined'] == true).toList();
    _loadUniversities(selectedCountry);
  }

  Future<void> _loadUniversities(String country) async {
    final fileName = 'assets/university_data/${country.toLowerCase()}.json';
    try {
      final jsonStr = await rootBundle.loadString(fileName);
      final data = json.decode(jsonStr);
      setState(() {
        universities = List<Map<String, dynamic>>.from(data['universities']);
        selectedUniversity = universities.isNotEmpty ? universities[0]['name'] : null;
        _filterPeople();
      });
    } catch (e) {
      setState(() {
        universities = [];
        selectedUniversity = null;
        people = [];
      });
    }
  }

  void _filterPeople() {
    setState(() {
      people = mockPeople.where((p) => p['university'] == selectedUniversity).toList();
    });
  }

  void onCountryChanged(String? country) {
    if (country == null) return;
    setState(() {
      selectedCountry = country;
      channels = mockChannels.where((c) => c['country'] == country).toList();
      joinedChannels = channels.where((c) => c['joined'] == true).toList();
    });
    _loadUniversities(country);
  }

  void onUniversityChanged(String? university) {
    setState(() {
      selectedUniversity = university;
      _filterPeople();
    });
  }

  void showJoinNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your request to join this channel has been sent. Once approved by a member, you’ll see the channel here and start receiving updates.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void showApprovalNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.verified, color: Colors.lightBlueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your request to join this channel has been approved! You are now a member and will receive updates.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void openAddChannel() {
    setState(() {
      showAddChannel = true;
      newChannelName = '';
      addChannelError = null;
      isChannelValid = false;
    });
  }
  void closeAddChannel() {
    setState(() {
      showAddChannel = false;
      newChannelName = '';
      addChannelError = null;
      isChannelValid = false;
    });
  }
  void validateChannelName(String value) {
    final allowed = [
      '#${selectedCountry.toLowerCase()}-jobs',
      '#${selectedCountry.toLowerCase()}-study',
      '#${selectedCountry.toLowerCase()}-general',
    ];
    final exists = channels.any((c) => c['name'].toLowerCase() == value.toLowerCase());
    setState(() {
      newChannelName = value;
      if (!allowed.contains(value.toLowerCase())) {
        addChannelError = 'Channel name must match one of the allowed options.';
        isChannelValid = false;
      } else if (exists) {
        addChannelError = 'Channel already exists.';
        isChannelValid = false;
      } else {
        addChannelError = null;
        isChannelValid = true;
      }
    });
  }
  void createChannel() {
    if (!isChannelValid) return;
    setState(() {
      channels.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': newChannelName,
        'type': newChannelName.split('-').last,
        'country': selectedCountry,
        'latestMessage': {'emoji': '✨', 'name': 'System', 'text': 'Channel created!'},
        'joined': false,
        'requests': [],
        'messages': [],
      });
      closeAddChannel();
    });
  }
  void setPending(int channelId) {
    setState(() {
      pendingChannelId = channelId;
    });
    showJoinNotification();
    // Simulate approval after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && pendingChannelId == channelId) {
        approvePending(channelId);
        showApprovalNotification();
      }
    });
  }

  void approvePending(int channelId) {
    setState(() {
      final idx = channels.indexWhere((c) => c['id'] == channelId);
      if (idx != -1) {
        channels[idx]['joined'] = true;
        pendingChannelId = null;
        joinedChannels = channels.where((c) => c['joined'] == true).toList();
      }
    });
  }
  void leaveChannel(int channelId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Channel?'),
        content: const Text('Do you really want to leave this channel?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        final idx = channels.indexWhere((c) => c['id'] == channelId);
        if (idx != -1) {
          channels[idx]['joined'] = false;
          joinedChannels = channels.where((c) => c['joined'] == true).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Country Selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: _GlassCountryDropdown(
                value: selectedCountry,
                label: 'Select Country',
                countries: countries,
                onChanged: onCountryChanged,
              ),
            ),
            // Channels Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                children: [
                  Text('Channels', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  Tooltip(
                    message: 'Add Channel',
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.blueAccent,
                      onPressed: openAddChannel,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ChannelsSection(
              country: selectedCountry,
              channels: channels,
              joinedChannels: joinedChannels,
              onJoin: (channelId) {
                setState(() {
                  if (joinedChannels.length < 3) {
                    final idx = channels.indexWhere((c) => c['id'] == channelId);
                    if (idx != -1) {
                      channels[idx]['joined'] = true;
                      joinedChannels = channels.where((c) => c['joined'] == true).toList();
                    }
                  }
                });
                showJoinNotification();
              },
              onLeave: (channelId) {
                setState(() {
                  final idx = channels.indexWhere((c) => c['id'] == channelId);
                  if (idx != -1) {
                    channels[idx]['joined'] = false;
                    joinedChannels = channels.where((c) => c['joined'] == true).toList();
                  }
                });
              },
              onTapChannel: (channel) {
                setState(() {
                  selectedChannel = channel;
                  replyToMessageIdx = null;
                });
              },
              pendingChannelId: pendingChannelId,
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Connections',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedUniversity,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  items: universities.map<DropdownMenuItem<String>>(
                    (u) => DropdownMenuItem<String>(
                      value: u['name'] as String,
                      child: Text(u['name']),
                    ),
                  ).toList(),
                  onChanged: onUniversityChanged,
                  hint: const Text('Select University', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),
            ),
            // People Section
            Expanded(
              child: Column(
                children: [
                  // People list
                  Expanded(
                    child: PeopleSection(
                      people: people,
                      universities: universities,
                      selectedUniversity: selectedUniversity,
                      onUniversityChanged: onUniversityChanged,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (selectedChannel != null)
          ChannelPopup(
            channel: selectedChannel!,
            joined: selectedChannel!['joined'] == true,
            onClose: () => setState(() => selectedChannel = null),
            onJoin: () {
              setState(() {
                selectedChannel!['joined'] = true;
                final idx = channels.indexWhere((c) => c['id'] == selectedChannel!['id']);
                if (idx != -1) channels[idx]['joined'] = true;
                joinedChannels = channels.where((c) => c['joined'] == true).toList();
              });
              showJoinNotification();
            },
            onLeave: () {
              setState(() {
                selectedChannel!['joined'] = false;
                final idx = channels.indexWhere((c) => c['id'] == selectedChannel!['id']);
                if (idx != -1) channels[idx]['joined'] = false;
                joinedChannels = channels.where((c) => c['joined'] == true).toList();
              });
            },
            onSendMessage: (msg) {
              setState(() {
                selectedChannel!['messages'].add({
                  'emoji': '🧑',
                  'name': 'You',
                  'text': msg,
                  'likes': 0,
                  'replies': [],
                });
              });
            },
            onReply: (idx) => setState(() => replyToMessageIdx = idx),
            replyToMessageIdx: replyToMessageIdx,
            onCancelReply: () => setState(() => replyToMessageIdx = null),
          ),
        if (showAddChannel)
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Add Channel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blueAccent)),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54),
                          onPressed: closeAddChannel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Allowed:', style: TextStyle(color: Colors.black87)),
                    ...['#${selectedCountry.toLowerCase()}-jobs', '#${selectedCountry.toLowerCase()}-study', '#${selectedCountry.toLowerCase()}-general']
                        .map((s) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(s, style: TextStyle(color: Colors.blueGrey)),
                            ))
                        .toList(),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: validateChannelName,
                      decoration: InputDecoration(
                        labelText: 'Channel Name',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isChannelValid ? Colors.green : Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isChannelValid ? Colors.green : Colors.grey),
                        ),
                        errorText: addChannelError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isChannelValid ? createChannel : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isChannelValid ? Colors.green : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Create Channel'),
                      ),
                    ),
                  ],
                ),
              ).asGlass(
                blurX: 10,
                blurY: 10,
                tintColor: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
      ],
    );
  }
}

// Channels Section Stub
class ChannelsSection extends StatelessWidget {
  final String country;
  final List<Map<String, dynamic>> channels;
  final List<Map<String, dynamic>> joinedChannels;
  final Function(int) onJoin;
  final Function(int) onLeave;
  final Function(Map<String, dynamic>) onTapChannel;
  final int? pendingChannelId;
  const ChannelsSection({
    required this.country,
    required this.channels,
    required this.joinedChannels,
    required this.onJoin,
    required this.onLeave,
    required this.onTapChannel,
    required this.pendingChannelId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: channels.length, // +1 for create button
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, idx) {
          if (idx == channels.length) {
            return CreateChannelButton(country: country);
          }
          final channel = channels[idx];
          return GestureDetector(
            onTap: () => onTapChannel(channel),
            child: ChannelCard(
              channel: channel,
              joined: channel['joined'] == true,
              onJoin: () => onJoin(channel['id']),
              onLeave: () => onLeave(channel['id']),
              pendingChannelId: pendingChannelId,
            ),
          );
        },
      ),
    );
  }
}

class CreateChannelButton extends StatelessWidget {
  final String country;
  const CreateChannelButton({required this.country, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Show create channel dialog with validation
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
        ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final Map<String, dynamic> channel;
  final bool joined;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final int? pendingChannelId;
  const ChannelCard({
    required this.channel,
    required this.joined,
    required this.onJoin,
    required this.onLeave,
    required this.pendingChannelId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(channel['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(channel['latestMessage']['emoji'], style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(channel['latestMessage']['name'], style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)), // Changed to black for contrast
              const SizedBox(width: 8),
              Expanded(child: Text(channel['latestMessage']['text'], style: TextStyle(color: Colors.black87), overflow: TextOverflow.ellipsis)), // Changed to black87
            ],
          ),
          const Spacer(),
          if (pendingChannelId == channel['id'])
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Pending'),
            )
          else if (joined)
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Leave Channel?', style: TextStyle(color: Colors.red)),
                    content: const Text('Are you sure you want to leave this channel?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) onLeave();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Leave'),
            )
          else
            ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Join'),
            ),
        ],
      ),
    ).asGlass(
      blurX: 20,
      blurY: 20,
      tintColor: Colors.white.withOpacity(0.8),
      clipBorderRadius: BorderRadius.circular(20),
    ); // Removed .asGlass for solid white background
  }
}

// People Section Stub
class PeopleSection extends StatelessWidget {
  final List<Map<String, dynamic>> people;
  final List<Map<String, dynamic>> universities;
  final String? selectedUniversity;
  final Function(String?) onUniversityChanged;
  const PeopleSection({
    required this.people,
    required this.universities,
    required this.selectedUniversity,
    required this.onUniversityChanged,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: people.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final person = people[idx];
              return PersonCard(person: person);
            },
          ),
        ),
      ],
    );
  }
}

class PersonCard extends StatelessWidget {
  final Map<String, dynamic> person;
  const PersonCard({required this.person, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: [
                    if (person['employed'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.work, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(person['company'] ?? '', style: TextStyle(color: Colors.green, fontSize: 12), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    if (person['student'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.school, size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(person['university'] ?? '', style: TextStyle(color: Colors.blue, fontSize: 12), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              ElevatedButton(
                onPressed: (person['personalComplete'] && person['social'].isNotEmpty)
                    ? () {
                        // TODO: Connect logic
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (person['personalComplete'] && person['social'].isNotEmpty)
                      ? Colors.blue
                      : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Connect'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Ask question popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Ask'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ChannelPopup widget
class ChannelPopup extends StatefulWidget {
  final Map<String, dynamic> channel;
  final bool joined;
  final VoidCallback onClose;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final Function(String) onSendMessage;
  final Function(int) onReply;
  final int? replyToMessageIdx;
  final VoidCallback onCancelReply;
  const ChannelPopup({
    required this.channel,
    required this.joined,
    required this.onClose,
    required this.onJoin,
    required this.onLeave,
    required this.onSendMessage,
    required this.onReply,
    required this.replyToMessageIdx,
    required this.onCancelReply,
    Key? key,
  }) : super(key: key);
  @override
  State<ChannelPopup> createState() => _ChannelPopupState();
}

class _ChannelPopupState extends State<ChannelPopup> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages = widget.channel['messages'] as List;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(widget.channel['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blueAccent)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white24, height: 1),
              // Messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, idx) {
                    final msg = messages[idx];
                    final isReplying = widget.replyToMessageIdx == idx;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isReplying ? Colors.blue.withOpacity(0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isReplying ? Border.all(color: Colors.blueAccent) : null,
                      ),
                      child: ListTile(
                        leading: Text(msg['emoji'], style: TextStyle(fontSize: 24)),
                        title: Text(msg['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(msg['text'], style: TextStyle(color: Colors.white70)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up, color: Colors.white54, size: 20),
                              onPressed: () {}, // TODO: Like logic
                            ),
                            IconButton(
                              icon: Icon(Icons.reply, color: Colors.white54, size: 20),
                              onPressed: () => widget.onReply(idx),
                            ),
                            IconButton(
                              icon: Icon(Icons.flag, color: Colors.redAccent, size: 20),
                              onPressed: () {}, // TODO: Report logic
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (widget.joined)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (widget.replyToMessageIdx != null)
                        Row(
                          children: [
                            Text('Replying to message #${widget.replyToMessageIdx! + 1}', style: TextStyle(color: Colors.blueAccent)),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: widget.onCancelReply,
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: widget.replyToMessageIdx != null ? 'Reply...' : 'Type a message...',
                                hintStyle: TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.08),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_msgController.text.trim().isNotEmpty) {
                                widget.onSendMessage(_msgController.text.trim());
                                _msgController.clear();
                                widget.onCancelReply();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: widget.onLeave,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text('Leave Channel'),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: widget.onJoin,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Join Channel'),
                  ),
                ),
            ],
          ),
        ).asGlass(
          blurX: 20,
          blurY: 20,
          tintColor: Colors.white.withOpacity(0.8),
          clipBorderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// Glassmorphic Dropdown
class _GlassCountryDropdown extends StatefulWidget {
  final String value;
  final String label;
  final List<Map<String, String>> countries;
  final ValueChanged<String> onChanged;
  const _GlassCountryDropdown({required this.value, required this.label, required this.countries, required this.onChanged, Key? key}) : super(key: key);
  @override
  State<_GlassCountryDropdown> createState() => _GlassCountryDropdownState();
}

class _GlassCountryDropdownState extends State<_GlassCountryDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  bool _isOpen = false;

  void _showDropdown() {
    if (_dropdownOverlay != null) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double width = renderBox.size.width;
    final double height = renderBox.size.height;

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + height + 4,
          width: width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16)],
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widget.countries.map((c) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        _hideDropdown();
                        widget.onChanged(c['name']!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Text(c['flag']!, style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(c['name']!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_dropdownOverlay!);
    setState(() => _isOpen = true);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.countries.firstWhere((c) => c['name'] == widget.value);
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _isOpen ? _hideDropdown : _showDropdown,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(widget.label, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text(selected['flag']!, style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(selected['name']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
} 