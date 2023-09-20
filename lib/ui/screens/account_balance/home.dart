import 'package:account_connect/ui/screens/account_balance/widgets/account_indicator.dart';
import 'package:account_connect/ui/widgets/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:starknet_flutter/starknet_flutter.dart';
import '../../widgets/loading.dart';
import 'home_presenter.dart';
import 'home_viewmodel.dart';
import 'widgets/account_address.dart';
import 'widgets/account_not_deployed.dart';
import 'widgets/action_button.dart';
import 'widgets/crypto_balance_cell.dart';
import 'widgets/empty_wallet.dart';
import 'widgets/no_account_selected.dart';

abstract class HomeView {
  void refresh();

  Future createPasswordDialog(PasswordStore passwordStore);

  Future showMoreDialog();

  Future<String?> unlockWithPassword();

  Future createPassword();

  Future<SelectedAccount?> showInitialisationDialog();

  Future<bool?> showTransactionModal(TransactionArguments args);
  Future showReceiveModal();
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeView {
  late HomePresenter presenter;
  late HomeViewModel model;

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    presenter = HomePresenter(
      HomeViewModel(),
      this,
    ).init();
    model = presenter.viewModel;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.checkPasswordConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 15,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AccountIndicatorWidget(
                    avatarUrl: 'https://i.pravatar.cc/150?img=1',
                    selectedWallet: model.selectedWallet,
                    selectedAccount: model.selectedAccount,
                    onPressed: presenter.onAccountSwitchTap,
                  ),
                  const Spacer(),
                  BouncingWidget(
                    child: const Icon(Icons.more_horiz),
                    onTap: () {
                      showMoreDialog();
                    },
                  ),
                ],
              ),
              if (model.selectedAccount?.accountAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: AccountAddressWidget(
                    address: model.selectedAccount!.accountAddress,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 15),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: model.hasSomeEth
                      ? SizedBox(
                          key: const Key('total_balance'),
                          width: double.infinity,
                          child: Text(
                            '\$${model.totalFiatBalance.truncateBalance(precision: 2).format()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        )
                      : const SizedBox(
                          key: Key('total_balance_placeholder'),
                          width: double.infinity,
                        ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildContent(),
                  ),
                ),
              ),
              if (model.hasSelectedWallet && model.hasSelectedAccount)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButtonWidget(
                      icon: Icons.send_outlined,
                      text: 'Send',
                      onPressed: presenter.onSendTap,
                    ),
                    const SizedBox(width: 20),
                    ActionButtonWidget(
                      icon: Icons.qr_code_2_rounded,
                      text: 'Receive',
                      onPressed: presenter.onReceiveTap,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // check if a wallet & account is selected
    if (!model.hasSelectedAccount || !model.hasSelectedWallet) {
      return NoAccountSelectedWidget(
        key: const Key('no_account_selected'),
        onAccountSwitchTap: presenter.onAccountSwitchTap,
      );
    }

    if (model.deployStatus == DeployStatus.unknown ||
        model.isLoadingBalance == true) {
      return const Center(
        key: Key('loading'),
        child: LoadingWidget(),
      );
    }

    if (model.deployStatus != DeployStatus.valid) {
      return AccountNotDeployed(
        key: const Key('account_not_deployed'),
        onRefresh: presenter.refreshAccount,
        publicAccount: model.selectedAccount!,
        balance: model.ethBalance!,
        fiatPrice: model.ethFiatPrice.truncateBalance(precision: 2),
        onDeploy: () => presenter.onDeploy(unlockWithPassword),
        deployStatus: model.deployStatus,
        error: model.deployError,
        onAddCrypto: () {
          StarknessDeposit.showDepositModal(
            context,
          );
        },
      );
    }

    if (model.hasSomeEth) {
      return RefreshIndicator(
        onRefresh: presenter.loadEthBalance,
        child: ListView.separated(
          key: const Key('list'),
          itemBuilder: (context, index) {
            // currently only ETH is supported
            return CryptoBalanceCellWidget(
              name: 'Ethereum',
              symbolIconUrl: 'https://cryptoicons.org/api/color/eth/200',
              balance: model.ethBalance!,
              fiatPrice: model.ethFiatPrice.truncateBalance(precision: 2),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: 1,
        ),
      );
    } else {
      return EmptyWalletWidget(
        onAddCrypto: () {
          StarknessDeposit.showDepositModal(
            context,
          );
        },
      );
    }
  }

  @override
  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Future<String?> unlockWithPassword() {
    return PasscodeInputView.showPinCode(context);
  }

  @override
  Future createPassword() {
    return PasscodeInputView.showPinCode(
      context,
      actionConfig: const PasscodeActionConfig.create(
        createTitle: "Create your pin code",
        confirmTitle: "Confirm",
      ),
    );
  }

  @override
  Future showMoreDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Dev options"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final publicStore = StarknetStore.public();
              final wallets = publicStore.getWallets();
              for (var w in wallets) {
                await StarknetStore.deleteWallet(w);
              }
              model.selectedWallet = null;
              model.selectedAccount = null;
              refresh();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text("Remove wallets"),
          ),
          TextButton.icon(
            onPressed: () async {
              // TODO We use the same passwordPrompt for unlocking and creating a password
              // In a real app, text would be different like "Enter your previous
              // password" and "Create a new password" for example
              final previousPassword = await unlockWithPassword();
              if (mounted) {
                final newPassword = await createPassword();
                if (previousPassword != null && newPassword != null) {
                  await PasswordStore().replacePassword(
                    previousPassword,
                    newPassword,
                  );
                }
              }
            },
            icon: const Icon(Icons.key),
            label: const Text("Replace password"),
          ),
        ],
      ),
    );
  }

  @override
  Future createPasswordDialog(PasswordStore passwordStore) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Set a password to protect your wallets"),
        actions: [
          TextButton(
            onPressed: () async {
              final password = await createPassword();
              if (password != null) {
                await passwordStore.initiatePassword(password);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text("Continue"),
          )
        ],
      ),
    );
  }

  @override
  Future<SelectedAccount?> showInitialisationDialog() {
    return StarknetWalletList.showModal(
      context,
      unlockWithPassword,
    );
  }

  @override
  Future<bool?> showTransactionModal(TransactionArguments args) {
    return StarknetTransaction.showModal(
      context,
      args: args,
    );
  }

  @override
  Future showReceiveModal() {
    return StarknetReceive.showQRCodeModal(
      context,
      address: model.selectedAccount!.accountAddress,
    );
  }
}
