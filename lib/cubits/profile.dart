import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'profile.g.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repository)
      : assert(repository != null),
        super(ProfileState());

  final DatabaseRepository repository;

  Future<void> load({String categoryId}) async {
    if (state.status == ProfileStatus.loading) return;
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await repository.readProfile();
      out(profile.wishes);
      emit(state.copyWith(
        profile: profile,
      ));
    } on Exception {
      emit(state.copyWith(status: ProfileStatus.error));
      rethrow;
    }
    emit(state.copyWith(status: ProfileStatus.ready));
  }
}

enum ProfileStatus { initial, loading, error, ready }

@CopyWith()
class ProfileState extends Equatable {
  ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
  });

  final ProfileModel profile;
  final ProfileStatus status;

  @override
  List<Object> get props => [
        profile,
        status,
      ];
}
