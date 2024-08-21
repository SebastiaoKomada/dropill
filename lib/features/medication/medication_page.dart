import 'dart:developer';

import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/utils/uppercase_text_fomatter.dart';
import 'package:dropill_project/common/widgets/custom_circular_progress_indicator.dart';
import 'package:dropill_project/common/widgets/custom_text_fiel.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:dropill_project/common/widgets/secundary_button.dart';
import 'package:dropill_project/features/medication/medication_controller.dart';
import 'package:dropill_project/features/medication/medication_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropill Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MedicationPage(),
    );
  }
}

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro do Medicamento',
          textAlign: TextAlign.center,
          style: AppTextStyles.mediumText24
              .copyWith(color: AppColors.standartBlue),
        ),
      ),
      body: const MultiStepForm(),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = locator.get<MedicationController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  final List<TimeOfDay> _times = [];

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.state is MedicationStateLoading) {
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }

      if (_controller.state is MedicationStateSuccess) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NamedRoute.homeView);
      }

      if (_controller.state is MedicationStateError) {
        final error = _controller.state as MedicationStateError;
        Navigator.pop(context);
        log('Erro ao criar medicação ou horários: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar medicação ou horários.')),
        );
      }
    });
  }

  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentStep < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String nome = _nameController.text;
      final String descricao = _descriptionController.text;
      final String tipo = _typeController.text;
      final int quantidade = int.parse(_quantityController.text);
      final DateTime dataAtual = _startDate ?? DateTime.now();
      final DateTime dataFinal = _endDate ?? DateTime.now();
      const bool estado = true;
      await _controller.createMedicationWithTimes(
        nome: nome,
        descricao: descricao,
        tipo: tipo,
        quantidade: quantidade,
        dataAtual: dataAtual,
        dataFinal: dataFinal,
        estado: estado,
        times: _times,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PageView(
        controller: _pageController,
        children: [
          Step1(
            onNext: _nextStep,
            nameController: _nameController,
            typeController: _typeController,
            descriptionController: _descriptionController,
            quantityController: _quantityController,
          ),
          Step2(
            onNext: _nextStep,
            onPrevious: _previousStep,
            onDatesChanged: (startDate, endDate) {
              setState(() {
                _startDate = startDate;
                _endDate = endDate;
              });
            },
            startDate: _startDate,
            endDate: _endDate,
          ),
          Step3(
            onPrevious: _previousStep,
            onTimesChanged: (times) {
              setState(() {
                _times.clear();
                _times.addAll(times);
              });
            },
            times: _times,
            onSubmit: _submitForm,
          ),
        ],
      ),
    );
  }
}

class Step1 extends StatefulWidget {
  final VoidCallback onNext;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;

  const Step1({
    super.key,
    required this.onNext,
    required this.nameController,
    required this.typeController,
    required this.descriptionController,
    required this.quantityController,
  });

  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  late FocusNode _nameFocusNode;
  late FocusNode _typeFocusNode;
  late FocusNode _descriptionFocusNode;
  late FocusNode _quantityFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _typeFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _typeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Passo 1: Informações Básicas',
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumText20
                  .copyWith(color: AppColors.standartBlue),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: widget.nameController,
                      focusNode: _nameFocusNode,
                      labelText: 'Nome do Medicamento',
                      inputFormatters: [
                        UpperCaseTextInputFormatter(),
                      ],
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_typeFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do medicamento.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: widget.typeController,
                      focusNode: _typeFocusNode,
                      labelText: 'Tipo',
                      inputFormatters: [
                        UpperCaseTextInputFormatter(),
                      ],
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o tipo.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      controller: widget.descriptionController,
                      focusNode: _descriptionFocusNode,
                      labelText: 'Descrição',
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_quantityFocusNode);
                      },
                    ),
                    CustomTextFormField(
                      controller: widget.quantityController,
                      focusNode: _quantityFocusNode,
                      labelText: 'Quantidade',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        _quantityFocusNode.unfocus(); // Remove o foco
                        widget
                            .onNext(); // Avança para a próxima etapa ou executa outra ação
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a quantidade.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                        height: 80), // Ajuste o valor conforme necessário
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SecundaryButton(
                onPressed: widget.onNext,
                text: 'Próximo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Step2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(DateTime?, DateTime?) onDatesChanged;
  final DateTime? startDate;
  final DateTime? endDate;

  const Step2({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onDatesChanged,
    required this.startDate,
    required this.endDate,
  });

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDateControllers();
  }

  void _updateDateControllers() {
    _startDateController.text = widget.startDate != null
        ? "${widget.startDate!.toLocal().year}-${widget.startDate!.toLocal().month.toString().padLeft(2, '0')}-${widget.startDate!.toLocal().day.toString().padLeft(2, '0')}"
        : '';
    _endDateController.text = widget.endDate != null
        ? "${widget.endDate!.toLocal().year}-${widget.endDate!.toLocal().month.toString().padLeft(2, '0')}-${widget.endDate!.toLocal().day.toString().padLeft(2, '0')}"
        : '';
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate && widget.startDate != null
        ? widget.startDate!
        : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isStartDate) {
        if (widget.endDate != null && picked.isAfter(widget.endDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'A data de início não pode ser depois da data final.')),
          );
        } else {
          widget.onDatesChanged(picked, widget.endDate);
          setState(() {
            _startDateController.text =
                "${picked.toLocal().year}-${picked.toLocal().month.toString().padLeft(2, '0')}-${picked.toLocal().day.toString().padLeft(2, '0')}";
          });
        }
      } else {
        if (widget.startDate != null && picked.isBefore(widget.startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('A data final não pode ser antes da data de início.')),
          );
        } else {
          widget.onDatesChanged(widget.startDate, picked);
          setState(() {
            _endDateController.text =
                "${picked.toLocal().year}-${picked.toLocal().month.toString().padLeft(2, '0')}-${picked.toLocal().day.toString().padLeft(2, '0')}";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Passo 2: Datas',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText20
                .copyWith(color: AppColors.standartBlue),
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _startDateController,
                  labelText: 'Data de Início',
                  onTap: () => _selectDate(context, true),
                ),
                CustomTextFormField(
                  controller: _endDateController,
                  labelText: 'Data Final',
                  onTap: () => _selectDate(context, false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: SecundaryButton(
                      onPressed: widget.onPrevious,
                      text: 'Anterior',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: SecundaryButton(
                      onPressed: widget.onNext,
                      text: 'Próximo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Step3 extends StatelessWidget {
  final VoidCallback onPrevious;
  final Function(List<TimeOfDay>) onTimesChanged;
  final List<TimeOfDay> times;
  final VoidCallback onSubmit;

  const Step3({
    super.key,
    required this.onPrevious,
    required this.onTimesChanged,
    required this.times,
    required this.onSubmit,
  });

  void _addTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final updatedTimes = List<TimeOfDay>.from(times)..add(picked);
      onTimesChanged(updatedTimes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Passo 3: Horários',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText20
                .copyWith(color: AppColors.standartBlue),
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: ListView.builder(
              itemCount: times.length,
              itemBuilder: (context, index) {
                final time = times[index];
                return ListTile(
                  title: Text(time.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      final updatedTimes = List<TimeOfDay>.from(times)
                        ..removeAt(index);
                      onTimesChanged(updatedTimes);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: SecundaryButton(
              onPressed: () => _addTime(context),
              text: 'Adicionar Horário',
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SecundaryButton(
                    onPressed: onPrevious,
                    text: 'Anterior',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: PrimaryButton(
                    onPressed: onSubmit,
                    text: 'Concluir',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
