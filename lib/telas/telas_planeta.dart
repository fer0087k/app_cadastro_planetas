import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';
import 'package:myapp/modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.planeta,
    required this.onFinalizado,
    required this.isIncluir,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.planeta.nome;
    _tamanhoController.text = widget.planeta.tamanho.toString();
    _distanciaController.text = widget.planeta.distancia.toString();
    _apelidoController.text = widget.planeta.apelido ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta(Planeta planeta) async {
    await _controlePlaneta.inserirPlaneta(planeta);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isIncluir ? 'Dados do planeta foram salvos com sucesso!' : 'Dados do planeta foram alterados com sucesso!',
        ),
      ),
    );
    Navigator.of(context).pop();
    widget.onFinalizado();
  }

  Future<void> _alterarPlaneta(Planeta planeta) async {
    await _controlePlaneta.alterarPlaneta(planeta);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados do planeta foram alterados com sucesso!')),
    );
    Navigator.of(context).pop();
    widget.onFinalizado();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      Planeta novoPlaneta = Planeta(
        nome: _nameController.text,
        tamanho: double.parse(_tamanhoController.text),
        distancia: double.parse(_distanciaController.text),
        apelido: _apelidoController.text,
      );

      if (widget.isIncluir) {
        _inserirPlaneta(novoPlaneta);
      } else {
        _alterarPlaneta(novoPlaneta);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Planeta'), elevation: 3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value == null || value.isEmpty ? 'Insira o nome' : null,
                ),
                TextFormField(
                  controller: _tamanhoController,
                  decoration: const InputDecoration(labelText: 'Tamanho (km)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (value == null || double.tryParse(value) == null) ? 'Valor inválido' : null,
                ),
                TextFormField(
                  controller: _distanciaController,
                  decoration: const InputDecoration(labelText: 'Distância (km)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (value == null || double.tryParse(value) == null) ? 'Valor inválido' : null,
                ),
                TextFormField(
                  controller: _apelidoController,
                  decoration: const InputDecoration(labelText: 'Apelido'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(onPressed: submitForm, child: const Text('Salvar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
