import 'package:flutter/material.dart';
import 'package:quiz_app/services/shop_service.dart';
import 'package:quiz_app/models/theme_preset.dart';
import 'package:quiz_app/main.dart'; // To access MyAppState for changing theme

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopService _shopService = ShopService();
  int _coins = 0;
  List<String> _ownedThemes = [];
  bool _isLoading = true;

  // Define prices for themes (could be moved to a model or remote config)
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
    _loadData();
  }

  Future<void> _loadData() async {
    final coins = await _shopService.getBalance();
    final owned = await _shopService.getOwnedThemes();
    if (mounted) {
      setState(() {
        _coins = coins;
        _ownedThemes = owned;
        _isLoading = false;
      });
    }
  }

  Future<void> _buyTheme(ThemePreset theme) async {
    final price = _themePrices[theme.name] ?? 999;

    // Show confirmation dialog
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
      await _loadData(); // Refresh balance and owned list
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Shop'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_coins',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
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
                final isOwned = _ownedThemes.contains(theme.name) ||
                    theme.name == 'Default';
                final price = _themePrices[theme.name] ?? 999;
                final isCurrent = context
                        .findAncestorStateOfType<MyAppState>()
                        ?.currentThemePreset
                        .name ==
                    theme.name;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isCurrent
                        ? BorderSide(
                            color: Theme.of(context).primaryColor, width: 3)
                        : BorderSide.none,
                  ),
                  child: Column(
                    children: [
                      // Preview Color
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isOwned
                                  ? (isCurrent
                                      ? Icons.check_circle
                                      : Icons.lock_open)
                                  : Icons.lock,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              theme.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (isOwned)
                              ElevatedButton(
                                onPressed:
                                    isCurrent ? null : () => _equipTheme(theme),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(isCurrent ? 'Equipped' : 'Equip'),
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: () => _buyTheme(theme),
                                icon:
                                    const Icon(Icons.monetization_on, size: 16),
                                label: Text('$price'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
