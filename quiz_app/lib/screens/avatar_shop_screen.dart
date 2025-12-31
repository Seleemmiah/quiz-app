import 'package:flutter/material.dart';
import 'package:quiz_app/models/avatar_model.dart';
import 'package:quiz_app/services/shop_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:animate_do/animate_do.dart';

class AvatarShopScreen extends StatefulWidget {
  const AvatarShopScreen({super.key});

  @override
  State<AvatarShopScreen> createState() => _AvatarShopScreenState();
}

class _AvatarShopScreenState extends State<AvatarShopScreen> {
  final ShopService _shopService = ShopService();
  int _balance = 0;
  List<String> _ownedAvatars = [];
  String _currentAvatar = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final balance = await _shopService.getBalance();
    final owned = await _shopService.getOwnedAvatars();
    final current = await PreferencesService.getAvatar();

    if (mounted) {
      setState(() {
        _balance = balance;
        _ownedAvatars = owned;
        _currentAvatar = current;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAvatarAction(AvatarModel avatar) async {
    final isOwned = _ownedAvatars.contains(avatar.emoji);

    if (isOwned) {
      // Equip
      await PreferencesService.setAvatar(avatar.emoji);
      setState(() {
        _currentAvatar = avatar.emoji;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${avatar.name} equipped!')),
        );
      }
    } else {
      // Buy
      if (_balance < avatar.price) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient coins!')),
          );
        }
        return;
      }

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
            const SnackBar(content: Text('Purchase failed. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Avatar Shop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Balance Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FadeInDown(
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Balance',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on,
                                      color: Colors.amber, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_balance',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _currentAvatar,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Avatar Grid
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : FadeInUp(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: allAvatars.length,
                          itemBuilder: (context, index) {
                            final avatar = allAvatars[index];
                            final isOwned =
                                _ownedAvatars.contains(avatar.emoji);
                            final isEquipped = _currentAvatar == avatar.emoji;

                            return GestureDetector(
                              onTap: () => _handleAvatarAction(avatar),
                              child: GlassCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      avatar.emoji,
                                      style: const TextStyle(fontSize: 60),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      avatar.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    if (isEquipped)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Equipped',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )
                                    else if (isOwned)
                                      const Icon(Icons.check_circle,
                                          color: Colors.white70)
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.monetization_on,
                                              color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${avatar.price}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
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
    );
  }
}
