import 'package:file_picker/file_picker.dart';

import '../../models/modelo_model.dart';
import '../../models/variaveis_substituicao_model.dart';
import '../../shared/either.dart';

abstract class ModelosRepository {
  Future<Either<String, List<ModeloModel>>> getModelos();
  Future<Either<String, ModeloModel>> criarModelo(
    ModeloModel modelo,
    PlatformFile documento,
  );
  Future<Either<String, ModeloModel>> atualizarModelo(
    ModeloModel modelo,
    PlatformFile? documento,
  );

  Future<Either<String, String>> obterPreviewModelo(ModeloModel modelo);

  Future<Either<String, String>> gerarDocumentoApartirDoModeloParaOCliente({
    required String modeloCodigo,
    required String clienteCodigo,
  });

  Future<Either<String, String>> excluirModelo(String modeloCodigo);

  Future<Either<String, List<VariaveisSubstituicaoModel>>>
      obterVariaveisSubstituicao();

  Future<Either<String, String>> downloadDocumentoPDF(String linkDownloadPDF);
}
