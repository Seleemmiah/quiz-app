import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/services/multiplayer_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/api_service.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen>
    with SingleTickerProviderStateMixin {
  final MultiplayerService _multiplayerService = MultiplayerService();
  final ApiService _apiService = ApiService();
  final TextEditingController _codeController = TextEditingController();
  late TabController _tabController;

  bool _isCreating = false;
  bool _isJoining = false;
  List<String> _categories = [];
  String? _selectedCategory;
  Difficulty _selectedDifficulty = Difficulty.easy;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> _createLobby() async {
    setState(() => _isCreating = true);
    try {
      final code = await _multiplayerService.createLobby(
        _selectedCategory ?? 'General Knowledge',
        _selectedDifficulty.name,
      );

      if (code != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/multiplayer_game',
          arguments: {'code': code, 'isHost': true},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating lobby: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _debugPermissions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DEBUG: User is NOT logged in!')),
      );
      return;
    }

    final results = <String>[];

    try {
      // Test 1: Write to users
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'lastDebug': DateTime.now()});
      results.add('✅ Users: OK');
    } catch (e) {
      results.add('❌ Users: ${e.toString().split(']').first}]');
    }

    try {
      // Test 2: Write to lobbies
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc('debug_${user.uid}')
          .set({
        'debug': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      results.add('✅ Lobbies: OK');
    } catch (e) {
      results.add('❌ Lobbies: ${e.toString().split(']').first}]');
    }

    try {
      // Test 3: Write to classes (Root)
      await FirebaseFirestore.instance
          .collection('classes')
          .doc('debug_${user.uid}')
          .set({
        'debug': true,
      });
      results.add('✅ Classes: OK');
    } catch (e) {
      results.add('❌ Classes: ${e.toString().split(']').first}]');
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Debugger'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: results.map((r) => Text(r)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _joinLobby() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }

    setState(() => _isJoining = true);
    try {
      final success = await _multiplayerService.joinLobby(code);
      if (success && mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/multiplayer_game',
          arguments: {'code': code, 'isHost': false},
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not join lobby. Check code or status.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error joining lobby: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Lobby?'),
            content: const Text(
                'Are you sure you want to leave the multiplayer lobby?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        if (shouldPop ?? false) {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multiplayer Lobby'),
          actions: [
            IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: () {
                Navigator.pushNamed(context, '/leaderboard');
              },
              tooltip: 'Leaderboard',
            ),
            if (kDebugMode)
              IconButton(
                icon: const Icon(Icons.bug_report),
                onPressed: _debugPermissions,
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Join Game', icon: Icon(Icons.login)),
              Tab(text: 'Host Game', icon: Icon(Icons.add_circle_outline)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildJoinSection(),
            _buildCreateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinSection() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sports_esports, size: 64, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Enter Game Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask the host for the 6-digit code',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _codeController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: '000000',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isJoining ? null : _joinLobby,
                    icon: _isJoining
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: const Text('JOIN GAME'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateSection() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_to_queue, size: 64, color: Colors.green),
                const SizedBox(height: 24),
                const Text(
                  'Host a New Game',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Random Category'),
                    ),
                    ..._categories.map((c) => DropdownMenuItem(
                          value: c,
                          child: SizedBox(
                            width: 200,
                            child: Text(c, overflow: TextOverflow.ellipsis),
                          ),
                        )),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Difficulty>(
                  value: _selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.speed),
                  ),
                  items: Difficulty.values.map((d) {
                    return DropdownMenuItem(
                      value: d,
                      child: Text(d.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDifficulty = value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isCreating ? null : _createLobby,
                    icon: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: const Text('CREATE & START'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
