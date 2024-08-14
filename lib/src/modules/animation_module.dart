import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/animation_module/animation_controller_window.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/widgets/expansion_tile.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';

export 'animation_module/interceptable_animation_controller.dart';

class AnimationModuleState {
  const AnimationModuleState({
    required this.animations,
  });

  final List<InterceptableAnimation> animations;

  AnimationModuleState copyWith({
    List<InterceptableAnimation>? animations,
  }) {
    return AnimationModuleState(
      animations: animations ?? this.animations,
    );
  }

  AnimationModuleState copyWithNewAnimation(
    InterceptableAnimation animation,
  ) {
    return AnimationModuleState(
      animations: [...animations, animation],
    );
  }

  AnimationModuleState copyWithoutAnimation(
    InterceptableAnimation animation,
  ) {
    return AnimationModuleState(
      animations: animations.where((c) => c != animation).toList(),
    );
  }
}

class AnimationModule extends SimulatorModule<AnimationModuleState> {
  const AnimationModule();

  @override
  AnimationModuleState createInitialState(json) {
    return const AnimationModuleState(animations: []);
  }

  @override
  Map<String, dynamic> toJson(AnimationModuleState data) {
    return {};
  }

  @override
  String get id => 'animation';

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<AnimationModuleState> onChanged,
  ) {
    final data = getDataFromState(state);
    final animations = data.animations;

    return SectionCard(
      title: const Text('Animation'),
      leading: const Icon(Icons.animation_rounded),
      builder: (context) => SectionList(
        children: [
          SmExpansionTile(
            leading: const Icon(Icons.account_tree_rounded),
            title: Text('Registered animations (${animations.length})'),
            child: Column(
              children: [
                for (final animation in animations)
                  _AnimationListTile(
                    animation: animation,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimationListTile extends StatelessWidget {
  const _AnimationListTile({
    required this.animation,
  });

  final InterceptableAnimation animation;

  @override
  Widget build(BuildContext context) {
    final title = animation.label ?? describeIdentity(animation);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => ListTile(
        onTap: () {
          windowRootNavigatorStateKey.currentState!.pushWindow(
            (context) => AnimationControllerWindow(
              animation: animation,
            ),
            icon: const Icon(Icons.animation_rounded),
            title: Text(title),
          );
        },
        title: Text(title),
        trailing: const Icon(Icons.open_in_new_rounded),
      ),
    );
  }
}
