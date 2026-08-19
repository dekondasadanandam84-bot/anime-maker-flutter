import 'package:flutter/material.dart';

import 'accounts_controller.dart';

class AccountsUI extends StatefulWidget {
  const AccountsUI({super.key});

  @override
  State<AccountsUI> createState() => AccountsUIState();
}

class AccountsUIState extends State<AccountsUI> {
  late final AccountsController controller;

  @override
  void initState() {
    super.initState();
    controller = AccountsController();
    controller.addListener(_refresh);
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  TextStyle get _sectionStyle => const TextStyle(
        color: Color(0xFF5E5E5E),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      );

  TextStyle get _titleStyle => const TextStyle(
        color: Color(0xFF1A1C1C),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  TextStyle get _bodyStyle => const TextStyle(
        color: Color(0xFF5E5E5E),
        fontSize: 15,
        height: 1.4,
      );

  @override
  Widget build(BuildContext context) {
    final activeAccount = controller.activeAccount;
    final otherAccounts = controller.otherAccounts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    if (activeAccount != null) ...[
                      Text('ACTIVE ACCOUNT', style: _sectionStyle),
                      const SizedBox(height: 16),
                      _buildActiveAccountCard(context, activeAccount),
                      const SizedBox(height: 40),
                    ],
                    Text('OTHER ACCOUNTS', style: _sectionStyle),
                    const SizedBox(height: 16),
                    if (otherAccounts.isEmpty)
                      _buildOtherAccountsEmptyState()
                    else
                      ...otherAccounts.map(
                        (account) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOtherAccountCard(context, account),
                        ),
                      ),
                    const SizedBox(height: 28),
                    _buildAddAccountCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8E3E4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 22,
            ),
          ),
          const Expanded(
            child: Text(
              'Accounts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 5, 92, 255),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Manage your accounts',
            textAlign: TextAlign.center,
            style: _titleStyle,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Switch between your AnimeClip accounts or add a new account to this device.',
          textAlign: TextAlign.center,
          style: _bodyStyle,
        ),
      ],
    );
  }

  Widget _buildActiveAccountCard(
    BuildContext context,
    AnimeClipAccount account,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFCFC4C5),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountAvatar(account, large: true),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.name,
                            style: const TextStyle(
                              color: Color(0xFF1A1C1C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildPlanBadge(account.plan),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      account.username,
                      style: const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildActiveBadge(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.requestLogout(context),
              icon: const Icon(Icons.logout_outlined, size: 18),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFBA1A1A),
                side: const BorderSide(color: Color(0xFFCFC4C5)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherAccountCard(
    BuildContext context,
    AnimeClipAccount account,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFCFC4C5),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x03000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAccountAvatar(account),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        account.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1A1C1C),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPlanBadge(account.plan, compact: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  account.username,
                  style: const TextStyle(
                    color: Color(0xFF5E5E5E),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          PopupMenuButton<AccountsMenuAction>(
            tooltip: 'Account options',
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF5E5E5E),
            ),
            onSelected: (action) {
              switch (action) {
                case AccountsMenuAction.switchAccount:
                  controller.switchAccount(account.id);
                  break;
                case AccountsMenuAction.deleteAccount:
                  controller.requestDeleteAccount(context, account.id);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: AccountsMenuAction.switchAccount,
                child: Text('Switch Account'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: AccountsMenuAction.deleteAccount,
                child: Text(
                  'Delete Account',
                  style: TextStyle(color: Color(0xFFBA1A1A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherAccountsEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFCFC4C5),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 42,
            color: Color(0xFF5E5E5E),
          ),
          SizedBox(height: 12),
          Text(
            'No other accounts',
            style: TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Add another AnimeClip account to quickly switch between accounts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E5E5E),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: controller.addAccount,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFCFC4C5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Color(0xFF1A1C1C),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Account',
                    style: TextStyle(
                      color: Color(0xFF1A1C1C),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sign in with another AnimeClip account',
                    style: TextStyle(
                      color: Color(0xFF5E5E5E),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF5E5E5E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountAvatar(
    AnimeClipAccount account, {
    bool large = false,
  }) {
    final size = large ? 64.0 : 40.0;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFCFC4C5),
        ),
      ),
      child: Icon(
        Icons.movie_outlined,
        color: Colors.white,
        size: large ? 31 : 20,
      ),
    );
  }

  Widget _buildPlanBadge(
    AccountPlan plan, {
    bool compact = false,
  }) {
    final isPlus = plan == AccountPlan.plus;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 7,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isPlus ? Colors.black : const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(compact ? 3 : 999),
      ),
      child: Text(
        isPlus ? 'PLUS' : 'FREE',
        style: TextStyle(
          color: isPlus ? Colors.white : const Color(0xFF5E5E5E),
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFFCFC4C5),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 14,
            color: Color(0xFF1A1C1C),
          ),
          SizedBox(width: 5),
          Text(
            'Active',
            style: TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
