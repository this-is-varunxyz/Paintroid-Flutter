import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/advanced_settings_state_provider.dart';
import 'package:paintroid/ui/theme/theme.dart';

Future<void> showAdvancedSettingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const _AdvancedSettingsDialog(),
  );
}

class _AdvancedSettingsDialog extends ConsumerStatefulWidget {
  const _AdvancedSettingsDialog();

  @override
  ConsumerState<_AdvancedSettingsDialog> createState() =>
      _AdvancedSettingsDialogState();
}

class _AdvancedSettingsDialogState extends ConsumerState<_AdvancedSettingsDialog> {
  late bool _antialiasing;
  late bool _smoothing;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(advancedSettingsStateProvider);
    _antialiasing = settings.isAntialiasingEnabled;
    _smoothing = settings.isSmoothingEnabled;
  }

  void _onOkPressed() {
    final notifier = ref.read(advancedSettingsStateProvider.notifier);
    notifier.setAntialiasing(enabled: _antialiasing);
    notifier.setSmoothing(enabled: _smoothing);
    Navigator.of(context).pop();
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tealColor = PaintroidTheme.of(context).primaryColor;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 16.0,
          top: 24.0,
          bottom: 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Options', 
              style: TextStyle(
                color: tealColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            _SettingsToggleRow(
              label: 'Antialiasing',
              value: _antialiasing,
              activeColor: tealColor,
              onChanged: (v) => setState(() => _antialiasing = v),
            ),
            const SizedBox(height: 8),

            _SettingsToggleRow(
              label: 'Smoothing',
              value: _smoothing,
              activeColor: tealColor,
              onChanged: (v) => setState(() => _smoothing = v),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _onCancelPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: tealColor,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _onOkPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: tealColor,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: activeColor, 
                activeTrackColor: activeColor.withValues(alpha: 0.4), 
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
           