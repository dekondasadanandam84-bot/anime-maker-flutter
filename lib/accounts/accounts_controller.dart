import 'package:flutter/material.dart';

enum AccountPlan {
  free,
  plus,
}

enum AccountsMenuAction {
  switchAccount,
  deleteAccount,
}

class AnimeClipAccount {
  final String id;
  final String name;
  final String username;
  final AccountPlan plan;

  const AnimeClipAccount({
    required this.id,
    required this.name,
    required this.username,
    required this.plan,
  });
}

class AccountsController extends ChangeNotifier {
  final List<AnimeClipAccount> _accounts = [
    const AnimeClipAccount(
      id: 'dhanush',
      name: 'Dhanush',
      username: '@dhanush',
      plan: AccountPlan.plus,
    ),
    const AnimeClipAccount(
      id: 'maya',
      name: 'Maya',
      username: '@maya',
      plan: AccountPlan.plus,
    ),
    const AnimeClipAccount(
      id: 'aarav',
      name: 'Aarav',
      username: '@aarav',
      plan: AccountPlan.free,
    ),
    const AnimeClipAccount(
      id: 'rohan',
      name: 'Rohan',
      username: '@rohan',
      plan: AccountPlan.free,
    ),
  ];

  String _activeAccountId = 'dhanush';

  AnimeClipAccount? get activeAccount {
    for (final account in _accounts) {
      if (account.id == _activeAccountId) {
        return account;
      }
    }
    return null;
  }

  List<AnimeClipAccount> get otherAccounts => List.unmodifiable(
        _accounts.where((account) => account.id != _activeAccountId),
      );

  void switchAccount(String accountId) {
    final accountExists = _accounts.any(
      (account) => account.id == accountId,
    );

    if (!accountExists || accountId == _activeAccountId) {
      return;
    }

    _activeAccountId = accountId;
    notifyListeners();
  }

  void addAccount() {
    // Authentication/navigation will be connected here later.
    // The UI action is intentionally kept separate from account state.
  }

  Future<void> requestDeleteAccount(
    BuildContext context,
    String accountId,
  ) async {
    final account = _findAccount(accountId);

    if (account == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove account?'),
          content: Text(
            'This will remove ${account.name} from this device. '
            'Your AnimeClip account and cloud data will not be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Remove Account'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      deleteAccount(accountId);
    }
  }

  Future<void> requestLogout(BuildContext context) async {
    final account = activeAccount;

    if (account == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out of AnimeClip?'),
          content: const Text(
            'You can sign back in anytime using this account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      logout();
    }
  }

  void deleteAccount(String accountId) {
    if (accountId == _activeAccountId) {
      return;
    }

    _accounts.removeWhere(
      (account) => account.id == accountId,
    );

    notifyListeners();
  }

  void logout() {
    // Authentication/session navigation will be connected here later.
  }

  AnimeClipAccount? _findAccount(String accountId) {
    for (final account in _accounts) {
      if (account.id == accountId) {
        return account;
      }
    }
    return null;
  }
}
