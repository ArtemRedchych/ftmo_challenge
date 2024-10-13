import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftmo/src/common_widgets/typography/tab_text.dart';
import 'package:ftmo/src/features/symbols/providers/selected_class_provider.dart';
import 'package:ftmo/src/themes/app_colors.dart';

class TabButton extends ConsumerWidget {
  const TabButton({
    super.key,
    required this.symbolClass,
  });

  final String symbolClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final String selectedAssetClass = ref.watch(selectedAssetClassProvider);

    bool isActive = selectedAssetClass == symbolClass;

    return ElevatedButton(
      onPressed: () {
        ref.read(selectedAssetClassProvider.notifier).state = symbolClass;
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 0),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        backgroundColor: isActive
            ? WidgetStateProperty.all<Color>(appColors.primaryActive)
            : WidgetStateProperty.all<Color>(appColors.primaryBase),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(
              width: 16,
            ),
            TabText(
              text: symbolClass,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    String iconPath = '';
    switch (symbolClass) {
      case 'Commodities':
        iconPath = 'assets/icons/commodities_icon.svg';
        break;
      case 'Indices':
        iconPath = 'assets/icons/indicies_icon.svg';
        break;
      case 'Forex':
        iconPath = 'assets/icons/fx_icon.svg';
        break;
      case 'Crypto':
        iconPath = 'assets/icons/crypto_icon.svg';
        break;
      case 'Metals':
        iconPath = 'assets/icons/custom_icon.svg';
        break;
      default:
        iconPath = 'assets/icons/custom_icon.svg';
    }

    return SvgPicture.asset(
      width: 16,
      height: 16,
      iconPath,
    );
  }
}
