import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pppd_project/models/dates_first_appeal_data.dart';
import 'package:pppd_project/models/medical_card_data.dart';
import 'package:pppd_project/models/medical_speciality_data.dart';
import 'package:pppd_project/models/patient_data.dart';
import 'package:pppd_project/models/provided_assistance_data.dart';
import 'package:pppd_project/models/schedule_data.dart';
import 'package:pppd_project/models/service_data.dart';
import 'package:pppd_project/models/type_of_medical_care_data.dart';
import 'package:pppd_project/models/user_data.dart';
import 'package:pppd_project/models/appeals_data.dart';

// Класс работы с API
class NetworkServices {
  final dio = Dio(); // Переменная содержащая HTTP клиент
  final String baseUrl =
      "https://pppdapi.azurewebsites.net/api/"; // Базовая ссылка на API

// Фукнция POST запроса, вызывающая отправку сообщения с кодом на почту указанную пользователем
  Future<String> changePasswordCodeSend(
    String email,
  ) async {
    try {
      final response = await dio.post("${baseUrl}accounts/sendMail/$email");
      return response.data;
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос всех аккаунтов
  Future<List<UserData>> getUsers() async {
    try {
      Response response = await Dio().get("${baseUrl}accounts");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listUsers = getData.map((i) => UserData.fromJSON(i)).toList();
        return listUsers;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос аккаунта для авторизации
  Future<List<UserData>> getUserCheckPassword(String? login, String? password) async {
    try {
      Response response = await Dio().get("${baseUrl}accounts/$login/$password");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listUsers = getData.map((i) => UserData.fromJSON(i)).toList();
        return listUsers;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }


// PUT запрос изменяющий данные аккаунта пользователя
  Future<UserData?> editUser(
      {required UserData userData, required int id}) async {
    try {
      Response response = await dio.put(
        baseUrl + '/accounts/$id',
        data: userData.toJson(),
      );
    } catch (e) {
      print('Error creating: $e');
    }

    return userData;
  }

// POST запрос добавляющий нового пользователя
  Future<UserData?> createUser({required UserData userData}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/accounts',
        data: userData.toJson(),
      );
    } on DioError catch (e) {
      print('Error creating user: $e');
      userData.login = 'Пользоватеть уже существует';
      return userData;
    }

    return userData;
  }

// POST запрос добавляющий новую медкарту
  Future<MedicalCardData?> createMedicalCard(
      {required MedicalCardData medicalCardData}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/medicalcards',
        data: medicalCardData.toJson(),
      );
    } on DioError catch (e) {
      print('Error creating: ${e.response!.data}');
    }

    return medicalCardData;
  }

// GET запрос медкарт
  Future<List<MedicalCardData>> getMedicalCard() async {
    try {
      Response response = await Dio().get("${baseUrl}medicalcards");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listMedicalCards =
            getData.map((i) => MedicalCardData.fromJSON(i)).toList();
        return listMedicalCards;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// POST запрос создающий пациента
  Future<PatientData?> createPatient({required PatientData patientData}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/patients',
        data: patientData.toJson(),
      );
    } catch (e) {
      print('Error creating: $e');
    }

    return patientData;
  }

// GET запрос пациентов
  Future<List<PatientData>> getPatient() async {
    try {
      Response response = await Dio().get("${baseUrl}patients");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listPatients = getData.map((i) => PatientData.fromJSON(i)).toList();
        return listPatients;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос обращений
  Future<List<AppealData>> getAppeals() async {
    try {
      Response response = await Dio().get("${baseUrl}servicesrendereds");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listAppeals = getData.map((i) => AppealData.fromJSON(i)).toList();
        return listAppeals;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// POST запрос создающий обращение
  Future<AppealData?> createAppeal({required AppealData appealInfo}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/servicesrendereds',
        data: appealInfo.toJson(),
      );
    } catch (e) {
      print('Error creating appeal: $e');
    }

    return appealInfo;
  }

// POST запрос создающий дату первичного обращения
  Future<DateFirstAppealData?> createDateFirstRendering(
      {required DateFirstAppealData dateFirstAppealData}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/datesfirstrendereds',
        data: dateFirstAppealData.toJson(),
      );
    } catch (e) {
      print('Error creating: $e');
    }

    return dateFirstAppealData;
  }

// PUT запрос изменяющий обращения
  Future<AppealData?> editAppeal(
      {required AppealData appealInfo, required int id}) async {
    try {
      Response response = await dio.put(
        baseUrl + '/servicesrendereds/$id',
        data: appealInfo.toJson(),
      );
    } catch (e) {
      print('Error creating: $e');
    }

    return appealInfo;
  }

// DELETE запрос удаляющий обращение
  Future deleteAppeals(int id) async {
    try {
      Response response = await Dio().delete("${baseUrl}servicesrendereds/$id");
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        throw Exception('delete failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
      return e.response!.data;
    }
  }

// DELETE запрос удаляющий оказанные усулги
  Future clearAssistance(int id) async {
    try {
      Response response =
          await Dio().delete("${baseUrl}ProvidedAssistances/$id");
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
      return e.response!.data;
    }
  }

// GET запрос оказанных усулг и мед помощи
  Future<List<ProvidedAssistanceData>> getProvidedAssistance() async {
    try {
      Response response = await Dio().get("${baseUrl}providedassistances");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listProvided =
            getData.map((i) => ProvidedAssistanceData.fromJSON(i)).toList();
        return listProvided;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// POST запрос добавляющий оказанные усулги к обращению
  Future<ProvidedAssistanceData?> createAssistance(
      {required ProvidedAssistanceData providedAssistanceData}) async {
    try {
      Response response = await dio.post(
        baseUrl + '/providedassistances',
        data: providedAssistanceData.toJson(),
      );
    } catch (e) {
      print('Error creating: $e');
    }

    return providedAssistanceData;
  }

// GET запрос услуг
  Future<List<ServiceData>> getServices() async {
    try {
      Response response = await Dio().get("${baseUrl}services");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listServices = getData.map((i) => ServiceData.fromJSON(i)).toList();
        return listServices;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос специальностей врачей, вместе с информацией о самих врачах
  Future<List<MedicalSpecialityData>> getAllInfoDocotor() async {
    try {
      Response response = await Dio().get("${baseUrl}medicalspecialties");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listDoctorInfo =
            getData.map((i) => MedicalSpecialityData.fromJSON(i)).toList();
        return listDoctorInfo;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос расписания врачей
  Future<List<ScheduleData>> getDocotorSchedule() async {
    try {
      Response response = await Dio().get("${baseUrl}schedules");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listSchedules =
            getData.map((i) => ScheduleData.fromJSON(i)).toList();
        return listSchedules;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос дат первичного обращения
  Future<List<DateFirstAppealData>> getDateFirstAppeal() async {
    try {
      Response response = await Dio().get("${baseUrl}datesfirstrendereds");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listdates =
            getData.map((i) => DateFirstAppealData.fromJSON(i)).toList();
        return listdates;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос пациентов
  Future<List<PatientData>> getPatients() async {
    try {
      Response response = await Dio().get("${baseUrl}patients");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listPatients = getData.map((i) => PatientData.fromJSON(i)).toList();
        return listPatients;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }

// GET запрос видов медицинской помощи
  Future<List<TypeOfMedicalCareData>> getMedicalCares() async {
    try {
      Response response = await Dio().get("${baseUrl}typeofmedicalcares");
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listCares =
            getData.map((i) => TypeOfMedicalCareData.fromJSON(i)).toList();
        return listCares;
      } else {
        throw Exception('Load failed!');
      }
    } on DioError catch (e) {
      debugPrint(e.response!.data);
      return e.response!.data;
    }
  }
}
