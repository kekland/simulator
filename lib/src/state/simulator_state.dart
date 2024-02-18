class SimulatorState {
  SimulatorState({
    required this.moduleState,
  });

  final Map<String, dynamic> moduleState;

  T get<T>(String moduleId) {
    return moduleState[moduleId] as T;
  }

  T? maybeGet<T>(String moduleId) {
    return moduleState[moduleId] as T?;
  }

  SimulatorState copyWith<T>(String moduleId, T value) {
    return SimulatorState(
      moduleState: {
        ...moduleState,
        moduleId: value,
      },
    );
  }
}
