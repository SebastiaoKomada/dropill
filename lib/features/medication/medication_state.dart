import 'package:dropill_project/common/models/medication_model.dart';

abstract class MedicationState {}

class MedicationStateInitial extends MedicationState {}

class MedicationStateLoading extends MedicationState {}

class MedicationStateSuccess extends MedicationState {
/*  final List<MedicationModel> medication;

  MedicationStateSuccess(this.medication);*/
}

class getMedicationStateSuccess extends MedicationState {
  final List<MedicationModel> medication;

  getMedicationStateSuccess(this.medication);
}

class MedicationStateError extends MedicationState {}
