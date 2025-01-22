import 'package:dropill_project/common/models/return_monitoring_model.dart';
import 'package:dropill_project/common/models/sympton_model.dart';
import 'package:dropill_project/services/sympton_service.dart';

abstract class MonitoringState {}

class MonitoringStateInitial extends MonitoringState {}

class MonitoringStateLoading extends MonitoringState {}

class MonitoringStateSuccess extends MonitoringState {}

class MonitoringStateError extends MonitoringState {}

class MonitoringStateSuccess2 extends MonitoringState {
  final List<SymptomModel> symptoms;

  MonitoringStateSuccess2(this.symptoms);
}

class MonitoringStateSuccess3 extends MonitoringState {
  final List<ReturnMonitoring> monitoring;

  MonitoringStateSuccess3(this.monitoring);
}

class SymptomStateLoading extends MonitoringState {}

class SymptomStateSuccess extends MonitoringState {}

class SymptomStateError extends MonitoringState {}
