import 'package:paintroid/core/providers/state/advanced_settings_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'advanced_settings_state_provider.g.dart';

const _kAntialiasingKey = 'advanced_settings_antialiasing';
const _kSmoothingKey = 'advanced_settings_smoothing';

@Riverpod(keepAlive: true)
class AdvancedSettingsStateProvider extends _$AdvancedSettingsStateProvider {
  @override
  AdvancedSettingsStateData build() {
    _loadFromPrefs();
    return const AdvancedSettingsStateData();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      isAntialiasingEnabled: prefs.getBool(_kAntialiasingKey) ?? false,
      isSmoothingEnabled: prefs.getBool(_kSmoothingKey) ?? false,
    );
  }

  Future<void> setAntialiasing({required bool enabled}) async {
    state = state.copyWith(isAntialiasingEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAntialiasingKey, enabled);
  }

  Future<void> setSmoothing({required bool enabled}) async {
    state = state.copyWith(isSmoothingEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSmoothingKey, enabled);
  }
}