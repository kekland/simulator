import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

class LocaleModuleState {
  const LocaleModuleState({required this.locale});

  final Locale locale;

  LocaleModuleState copyWith({Locale? locale}) {
    return LocaleModuleState(
      locale: locale ?? this.locale,
    );
  }
}

class LocaleModule extends SimulatorModule<LocaleModuleState> {
  const LocaleModule({
    this.supportedLocales,
  });

  final List<Locale>? supportedLocales;

  @override
  LocaleModuleState createInitialState(json) {
    if (json != null) {
      return LocaleModuleState(
        locale: Locale(json['languageCode'], json['countryCode']),
      );
    }

    return LocaleModuleState(
      locale: supportedLocales?.first ?? _systemLocales.first,
    );
  }

  @override
  Map<String, dynamic> toJson(LocaleModuleState data) {
    return {
      'languageCode': data.locale.languageCode,
      'countryCode': data.locale.countryCode,
    };
  }

  @override
  String get id => 'locale';

  List<Locale> get _systemLocales =>
      SimulatorWidgetsFlutterBinding.instance.platformDispatcher.systemLocales;

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<LocaleModuleState> onChanged,
  ) {
    final data = getDataFromState(state);

    void _onChanged(LocaleModuleState value) {
      SimulatorWidgetsFlutterBinding.instance.platformDispatcher
          .setLocaleOverride([value.locale]);

      onChanged(value);
    }

    final _supportedLocales = supportedLocales ?? _systemLocales;

    return SectionCard(
      title: const Text('Locale'),
      leading: const Icon(Icons.translate_rounded),
      builder: (context) => SectionList(
        children: [
          for (final locale in _supportedLocales)
            RadioListTile(
              value: locale,
              groupValue: data.locale,
              onChanged: (value) {
                _onChanged(data.copyWith(locale: value));
              },
              title: Text(locale.toLanguageTag()),
            ),
        ],
      ),
    );
  }
}
