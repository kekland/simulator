import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/simulator.dart';

Animation<double> createSimulatedAnimation(
  Animation<double> animation, {
  String? label,
}) {
  if (kDebugMode) {
    return InterceptableAnimation(animation, label: label);
  }

  return animation;
}

class InterceptableAnimation extends ProxyAnimation {
  InterceptableAnimation(super.animation, {this.label});

  final String? label;

  @override
  void didStartListening() {
    super.didStartListening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerWithAnimationModule();
    });
  }

  @override
  void didStopListening() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unregisterWithAnimationModule();
    });
    super.didStopListening();
  }

  AnimationController? get controller {
    var parents = Queue<Animation<double>>();
    parents.add(parent!);

    while (parents.isNotEmpty) {
      var parent = parents.removeFirst();

      if (parent is AnimationController) {
        return parent;
      }

      final parentsToAdd = <Animation<double>>[];

      if (parent is AnimationWithParentMixin) {
        parentsToAdd.add(
          (parent as AnimationWithParentMixin).parent as Animation<double>,
        );
      } else if (parent is ProxyAnimation) {
        parentsToAdd.add(parent.parent as Animation<double>);
      } else if (parent is CurvedAnimation) {
        parentsToAdd.add(parent.parent);
      } else if (parent is ReverseAnimation) {
        parentsToAdd.add(parent.parent);
      } else if (parent is CompoundAnimation) {
        parentsToAdd
            .add((parent as CompoundAnimation).first as Animation<double>);
        parentsToAdd
            .add((parent as CompoundAnimation).next as Animation<double>);
      } else if (parent is TrainHoppingAnimation) {
        // TODO: Next train?
        parentsToAdd.add(parent.currentTrain as Animation<double>);
      }

      parents.addAll(parentsToAdd);
    }

    return null;
  }

  void _registerWithAnimationModule() {
    final simulatorApp = simulatorRootKey.currentState as SimulatorAppState;
    final moduleData =
        simulatorApp.state.moduleState['animation'] as AnimationModuleState;

    simulatorApp.setSimulatorState(
      simulatorApp.state.copyWithModuleState(
        'animation',
        moduleData.copyWithNewAnimation(this),
      ),
    );
  }

  void _unregisterWithAnimationModule() {
    final simulatorApp = simulatorRootKey.currentState as SimulatorAppState;
    final moduleData =
        simulatorApp.state.moduleState['animation'] as AnimationModuleState;

    simulatorApp.setSimulatorState(
      simulatorApp.state.copyWithModuleState(
        'animation',
        moduleData.copyWithoutAnimation(this),
      ),
    );
  }
}
