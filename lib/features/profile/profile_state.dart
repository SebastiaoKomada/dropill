import 'package:dropill_project/common/models/profile_model.dart';

abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateSuccess extends ProfileState {
  final List<ProfileModel> profiles;

  ProfileStateSuccess(this.profiles);
}

class ProfileStateError extends ProfileState {}
