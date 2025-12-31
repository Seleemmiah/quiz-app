import 'package:flutter/material.dart';
import 'package:quiz_app/services/shop_service.dart';
import 'package:quiz_app/models/theme_preset.dart';
import 'package:quiz_app/models/avatar_model.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:animate_do/animate_do.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final ShopService _shopService = ShopService();
  int _coins = 0;
  List<String> _ownedThemes = [];
  List<String> _ownedAvatars = [];
  String _currentAvatar = '';
  bool _isLoading = true;
  late TabController _tabController;

  final Map<String, int> _themePrices = {
    'Default': 0,
    'Ocean': 100,
    'Sunset': 200,
    'Forest': 300,
    'Lavender': 400,
    'Dark': 500,
    'Midnight': 600,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final coins = await _shopService.getBalance();
    final ownedThemes = await _shopService.getOwnedThemes();
    final ownedAvatars = await _shopService.getOwnedAvatars();
    final currentAvatar = await PreferencesService.getAvatar();

    if (mounted) {
      setState(() {
        _coins = coins;
        _ownedThemes = ownedThemes;
        _ownedAvatars = ownedAvatars;
        _currentAvatar = currentAvatar;
        _isLoading = false;
      });
    }
  }

  Future<void> _buyTheme(ThemePreset theme) async {
    final price = _themePrices[theme.name] ?? 999;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${theme.name}?'),
        content: Text('This will cost $price coins.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buy'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    final success = await _shopService.buyTheme(theme.name, price);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully bought ${theme.name}!')),
        );
      }
      await _loadData();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed. Not enough coins?')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _equipTheme(ThemePreset theme) {
    final myApp = context.findAncestorStateOfType<MyAppState>();
    if (myApp != null) {
      myApp.changeThemePreset(theme);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipped ${theme.name} theme!')),
      );
    }
  }

  Future<void> _handleAvatarAction(AvatarModel avatar) async {
    final isOwned = _ownedAvatars.contains(avatar.emoji);

    if (isOwned) {
      await PreferencesService.setAvatar(avatar.emoji);
      setState(() => _currentAvatar = avatar.emoji);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${avatar.name} equipped!')),
        );
      }
    } else {
      if (_coins < avatar.price) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient coins!')),
          );
        }
        return;
      }

      setState(() => _isLoading = true);
      final success = await _shopService.buyAvatar(avatar.emoji, avatar.price);
      if (success) {
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchased ${avatar.name}!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchase failed.')),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindly Shop'),
        actions: [
          _buildCoinBalance(),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.palette), text: 'Themes'),
            Tab(icon: Icon(Icons.face), text: 'Avatars'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildThemesTab(),
                _buildAvatarsTab(),
              ],
            ),
    );
  }

  Widget _buildCoinBalance() {
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Text(
            '$_coins',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: ThemePreset.presets.length,
      itemBuilder: (context, index) {
        final theme = ThemePreset.presets[index];
        final isOwned =
            _ownedThemes.contains(theme.name) || theme.name == 'Default';
        final price = _themePrices[theme.name] ?? 999;
        final isCurrent = context
                .findAncestorStateOfType<MyAppState>()
                ?.currentThemePreset
                .name ==
            theme.name;

        return FadeInUp(
          delay: Duration(milliseconds: 50 * index),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isCurrent
                  ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
                  : BorderSide.none,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(
                        isOwned
                            ? (isCurrent ? Icons.check_circle : Icons.lock_open)
                            : Icons.lock,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(theme.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (isOwned)
                        ElevatedButton(
                          onPressed:
                              isCurrent ? null : () => _equipTheme(theme),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 36),
                          ),
                          child: Text(isCurrent ? 'Equipped' : 'Equip'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => _buyTheme(theme),
                          icon: const Icon(Icons.monetization_on, size: 16),
                          label: Text('$price'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 36),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: allAvatars.length,
      itemBuilder: (context, index) {
        final avatar = allAvatars[index];
        final isOwned = _ownedAvatars.contains(avatar.emoji);
        final isEquipped = _currentAvatar == avatar.emoji;

        return FadeInUp(
          delay: Duration(milliseconds: 50 * index),
          child: GestureDetector(
            onTap: () => _handleAvatarAction(avatar),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isEquipped
                    ? BorderSide(
                        color: Theme.of(context).primaryColor, width: 3)
                    : BorderSide.none,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(avatar.emoji, style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 8),
                  Text(avatar.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (isEquipped)
                    const Text('Equipped',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold))
                  else if (isOwned)
                    const Icon(Icons.check_circle, color: Colors.green)
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${avatar.price}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
