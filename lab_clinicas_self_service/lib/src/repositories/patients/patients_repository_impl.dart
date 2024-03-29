import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

import './patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final RestClient restClient;
  PatientsRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, PatientModel?>> findPatientByDocument(
      String document) async {
    try {
      final Response(:List data) = await restClient.auth
          .get('/patients', queryParameters: {'document': document});
       
      if(data.isEmpty) {
        return Right(null);
      } 
       return Right(PatientModel.fromJson(data.first));
    } on DioException catch (e, s) {
      log('Erro ao buscar paciente por CPF', error: e, stackTrace: s);
      return Left(RepositoryException());
    }
  }
}
