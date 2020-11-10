// import 'dart:async';
// import 'package:copy_with_extension/copy_with_extension.dart';
// import 'package:equatable/equatable.dart';
// import 'package:bloc/bloc.dart';
// import 'package:pet_finder/import.dart';

// part 'search.g.dart';

// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit(this.repository)
//       : assert(repository != null),
//         super(SearchState());

//   final DatabaseRepository repository;

//   Future<void> load({String categoryId}) async {
//     // const kLimit = 10;
//     if (state.status == SearchStatus.loading) return;
//     emit(state.copyWith(
//       status: SearchStatus.loading,
//     ));
//     try {
//       final units = await repository.readUnits(
//         query: query,
//         limit: kSearchUnitsLimit,
//       );
//       emit(SearchState());
//       await Future.delayed(Duration(milliseconds: 300));
//       emit(state.copyWith(units: units));
//     } on Exception {
//       out('error');
//     } finally {
//       emit(state.copyWith(
//         status: SearchStatus.ready,
//       ));
//     }
//   }
// }

// enum SearchStatus { initial, loading, ready }

// @CopyWith()
// class SearchState extends Equatable {
//   SearchState({
//     this.units = const [],
//     this.status = SearchStatus.initial,
//   });

//   final List<UnitModel> units;
//   final SearchStatus status;

//   @override
//   List<Object> get props => [
//         units,
//         status,
//       ];
// }
