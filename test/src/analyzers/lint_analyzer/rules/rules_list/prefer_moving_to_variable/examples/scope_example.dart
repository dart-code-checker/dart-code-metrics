class BlocTest {
  final state = State();

  FutureOr<void> mapEvent(
    TestEvent event,
    Emitter<TestState> emit,
  ) {
    return event.map<FutureOr<void>>(
      init: (_) async {
        emit(state.copyWith(isLoading: true)); // LINT

        const result = [];

        var newState = state.copyWith(dataList: result); // LINT

        if (result.isEmpty) {
          newState = newState.copyWith(dataList: [], isLoading: false);
        } else {
          newState = newState.copyWith(dataList: result, isLoading: false);
        }

        emit(state);
      },
      checkProviders: (_) async {
        emit(state.copyWith(isLoading: true)); // LINT

        const result = [];

        if (result.isEmpty) {
          emit(state.copyWith(dataList: [])); // LINT
        } else {
          emit(state.copyWith(dataList: result));
        }
      },
    );
  }

  void emit(Object value) {}
}

class TestEvent {
  FutureOr<void> map<T>({Function init, Function checkProviders}) {}
}

class State {
  State copyWith({List<Object> dataList, bool isLoading}) {
    return State();
  }
}
