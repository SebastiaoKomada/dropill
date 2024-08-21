import 'package:dropill_project/common/models/confirmation_model.dart';
import 'package:dropill_project/features/confirmation/confirmation_state.dart';
import 'package:dropill_project/services/confirmation_service.dart';
import 'package:flutter/foundation.dart';

class ConfirmationController extends ChangeNotifier {
  final ConfirmationService _confirmationService;
  Map<String, dynamic>? _payload;
  ConfirmationState _state = ConfirmationStateInitial();

  ConfirmationState get state => _state;
  Map<String, dynamic>? get payload => _payload;

  ConfirmationController(this._confirmationService);

  void _changeState(ConfirmationState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> confirmMedication(int conId) async {
    _changeState(ConfirmationStateLoading());

    await _confirmationService.confirmMedication(con_id: conId);
    _changeState(ConfirmationStateSuccess());
  }
}
