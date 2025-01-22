import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:dropill_project/common/widgets/secundary_button.dart';
import 'package:dropill_project/features/config/config_controller.dart';
import 'package:dropill_project/features/config/config_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final SecureStorage _secureStorage = SecureStorage();
  late ConfigController _configController;

  @override
  void initState() {
    super.initState();
    _configController = locator.get<ConfigController>();
    _configController.loadInfos();
  }

  Future<void> _logout() async {
    await _secureStorage.deleteAll();
    Navigator.popAndPushNamed(context, NamedRoute.splash);
  }

  void _switchProfile() {
    Navigator.pushReplacementNamed(context, NamedRoute.profile);
  }

  Future<void> _showConnectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Usuário precisa interagir com o diálogo para continuar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conectar à Rede Wi-Fi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Antes de configurar o Wi-Fi do dispositivo ESP32, por favor, conecte-se à rede Wi-Fi criada pelo ESP32:'),
                SizedBox(height: 10),
                Text(
                  'Nome da rede: Dropill Dispenser',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Senha: 12345678',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Após se conectar à rede Wi-Fi, abra o seu navegador de internet e digite o endereço IP 192.168.4.1 na barra de endereços. Você será direcionado a um formulário onde deverá selecionar e informar os dados da rede Wi-Fi que deseja configurar.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _configController,
        builder: (context, child) {
          if (_configController.state is ConfigStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_configController.state is ConfigStateError) {
            return const Center(
              child: Text(
                'Erro ao carregar dados',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Configuração',
                  style: AppTextStyles.mediumText20
                      .copyWith(color: AppColors.standartBlue),
                ),
                const SizedBox(height: 24),
                Text(
                  'Dados pesoais:',
                  style: AppTextStyles.mediumText20
                      .copyWith(color: AppColors.standartBlue),
                ),
                Text(
                  'Nome: ${_configController.userName ?? ''}',
                  style: AppTextStyles.mediumText18
                      .copyWith(color: AppColors.grey),
                ),
                Text(
                  'E-mail: ${_configController.userEmail ?? ''}',
                  style: AppTextStyles.mediumText18
                      .copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 48),
                SecundaryButton(
                  text: "Trocar de Perfil",
                  onPressed: _switchProfile,
                ),
                const SizedBox(height: 16),
                SecundaryButton(
                  text: "Configurar Wi-Fi",
                  onPressed: () async {
                    await _showConnectionDialog();
                    final url = Uri.parse('http://192.168.4.1');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                const Spacer(),
                PrimaryButton(
                  text: "Logout",
                  onPressed: _logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
