import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _celularController = TextEditingController();
  final _cpfController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _celularController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final telefone = _telefoneController.text.trim();
    final celular = _celularController.text.trim();
    final cpf = _cpfController.text.trim();

    if ([nome, email, telefone, celular, cpf].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    try {
      await _firestore.collection('clientes').add({
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'celular': celular,
        'cpf': cpf,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _nomeController.clear();
      _emailController.clear();
      _telefoneController.clear();
      _celularController.clear();
      _cpfController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Cadastro de Cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 500 : double.infinity,
            ),
            child: Column(
              children: [
                _buildTextField(_nomeController, 'Nome', Icons.person),
                const SizedBox(height: 12),
                _buildTextField(
                  _emailController,
                  'Email',
                  Icons.email,
                  TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _telefoneController,
                  'Telefone',
                  Icons.phone,
                  TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _celularController,
                  'Celular',
                  Icons.phone_android,
                  TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _cpfController,
                  'CPF',
                  Icons.assignment_ind,
                  TextInputType.number,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      onPressed: _cadastrar,
                      icon: const Icon(Icons.save),
                      label: const Text('Cadastrar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType inputType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    );
  }
}
