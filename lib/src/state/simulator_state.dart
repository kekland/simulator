class SimulatorState {
  SimulatorState({
    required this.moduleState,
    required this.moduleVisualOrder,
  });

  final Map<String, dynamic> moduleState;
  final List<String> moduleVisualOrder;

  T get<T>(String moduleId) {
    return moduleState[moduleId] as T;
  }

  T? maybeGet<T>(String moduleId) {
    return moduleState[moduleId] as T?;
  }

  SimulatorState copyWithModuleState<T>(String moduleId, T value) {
    return SimulatorState(
      moduleVisualOrder: moduleVisualOrder,
      moduleState: {
        ...moduleState,
        moduleId: value,
      },
    );
  }

  SimulatorState copyWith({
    Map<String, dynamic>? moduleState,
    List<String>? moduleVisualOrder,
  }) {
    return SimulatorState(
      moduleState: moduleState ?? this.moduleState,
      moduleVisualOrder: moduleVisualOrder ?? this.moduleVisualOrder,
    );
  }
}
