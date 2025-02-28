import 'dart:convert';
import 'cliente_listagem_model.dart';
import 'drive_model.dart';
import 'endereco_simples_model.dart';
import 'evento_model.dart';
import 'familiar_model.dart';
import 'processo_model.dart';

class ClienteModel {
  String codigo;
  String nomeCompleto;
  String documento;
  String email;
  String telefone;
  String dataAniversario;
  String logradouro;
  String numero;
  String bairro;
  String cidade;
  String estado;
  String cep;
  String complemento;
  String nomeDaMae;
  String cpfDaMae;
  String sexo;
  String nomeDoPai;
  String cpfDoPai;
  String rg;
  String pis;
  String carteiraDeTrabalho;
  List<String> telefones = [];
  List<String> emails = [];
  List<EnderecoSimplesModel> enderecos = [];
  List<FamiliarModel> familiares = [];

  DriveModel drive;
  List<Evento> eventos = [];
  List<ProcessoModel> processos = [];

  ClienteModel({
    required this.codigo,
    required this.nomeCompleto,
    required this.documento,
    required this.email,
    required this.dataAniversario,
    required this.telefone,
    required this.drive,
    required this.eventos,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.complemento,
    required this.nomeDaMae,
    required this.cpfDaMae,
    required this.sexo,
    required this.processos,
    required this.nomeDoPai,
    required this.cpfDoPai,
    required this.rg,
    required this.pis,
    required this.carteiraDeTrabalho,
    required this.telefones,
    required this.emails,
    required this.enderecos,
    required this.familiares,
  });

  ClienteListagemModel toClienteListagemModel() {
    return ClienteListagemModel(
      codigo: codigo,
      nomeCompleto: nomeCompleto,
      documento: documento,
      whatsapp: telefone,
    );
  }

  ClienteModel copyWith({
    String? codigo,
    String? nomeCompleto,
    String? documento,
    String? email,
    String? telefone,
    String? dataAniversario,
    String? logradouro,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
    String? complemento,
    String? nomeDaMae,
    String? cpfDaMae,
    String? sexo,
    DriveModel? drive,
    List<Evento>? eventos,
    List<ProcessoModel>? processos,
    String? nomeDoPai,
    String? cpfDoPai,
    String? rg,
    String? pis,
    String? carteiraDeTrabalho,
    List<String>? telefones,
    List<String>? emails,
    List<EnderecoSimplesModel>? enderecos,
    List<FamiliarModel>? familiares,
  }) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      documento: documento ?? this.documento,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      drive: drive ?? this.drive,
      eventos: eventos ?? this.eventos,
      dataAniversario: dataAniversario ?? this.dataAniversario,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      complemento: complemento ?? this.complemento,
      nomeDaMae: nomeDaMae ?? this.nomeDaMae,
      cpfDaMae: cpfDaMae ?? this.cpfDaMae,
      sexo: sexo ?? this.sexo,
      processos: processos ?? this.processos,
      nomeDoPai: nomeDoPai ?? this.nomeDoPai,
      cpfDoPai: cpfDoPai ?? this.cpfDoPai,
      rg: rg ?? this.rg,
      pis: pis ?? this.pis,
      carteiraDeTrabalho: carteiraDeTrabalho ?? this.carteiraDeTrabalho,
      telefones: telefones ?? this.telefones,
      emails: emails ?? this.emails,
      enderecos: enderecos ?? this.enderecos,
      familiares: familiares ?? this.familiares,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nomeCompleto': nomeCompleto,
      'documento': documento,
      'email': email,
      'telefone': telefone,
      'drive': drive.toMap(),
      'eventos': eventos.map((x) => x.toMap()).toList(),
      'dataAniversario': dataAniversario,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'complemento': complemento,
      'nomeDaMae': nomeDaMae,
      'cpfDaMae': cpfDaMae,
      'sexo': sexo,
      'processos': processos.map((x) => x.toMap()).toList(),
      'nomeDoPai': nomeDoPai,
      'cpfDoPai': cpfDoPai,
      'rg': rg,
      'pis': pis,
      'carteiraDeTrabalho': carteiraDeTrabalho,
      'telefones': telefones,
      'emails': emails,
      'enderecos': enderecos.map((x) => x.toMap()).toList(),
      'familiares': familiares.map((x) => x.toMap()).toList(),
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      codigo: map['codigo'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',
      documento: map['documento'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      dataAniversario: map['dataNascimento'] ?? '',
      logradouro: (map['logradouro'] ?? '').toString(),
      numero: (map['numero'] ?? '').toString(),
      bairro: (map['bairro'] ?? '').toString(),
      cidade: (map['cidade'] ?? '').toString(),
      estado: (map['estado'] ?? '').toString(),
      cep: (map['cep'] ?? '').toString(),
      complemento: (map['complemento'] ?? '').toString(),
      nomeDaMae: (map['nomeMae'] ?? '').toString(),
      cpfDaMae: (map['cpfMae'] ?? '').toString(),
      sexo: (map['sexo'] ?? '').toString(),
      drive: DriveModel(arquivos: []),
      eventos: List<Evento>.from(
          map['eventos']?.map((x) => Evento.fromMap(x)) ?? []),
      processos: List<ProcessoModel>.from(
          map['processos']?.map((x) => ProcessoModel.fromMap(x)) ?? []),
      nomeDoPai: (map['paiNome'] ?? '').toString(),
      cpfDoPai: (map['cpfPai'] ?? '').toString(),
      rg: (map['rg'] ?? '').toString(),
      pis: (map['pis'] ?? '').toString(),
      carteiraDeTrabalho: (map['carteiraTrabalho'] ?? '').toString(),
      telefones: List<String>.from(map['telefones'] ?? []),
      emails: List<String>.from(map['emails'] ?? []),
      enderecos: List<EnderecoSimplesModel>.from(
          map['enderecos']?.map((x) => EnderecoSimplesModel.fromMap(x)) ?? []),
      familiares: List<FamiliarModel>.from(
          map['familiares']?.map((x) => FamiliarModel.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClienteModel.fromJson(String source) =>
      ClienteModel.fromMap(json.decode(source));
}
