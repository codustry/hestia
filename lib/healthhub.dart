import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Custom Exception for the plugin,
/// thrown whenever a Health Data Type is requested,
/// when not available on the current platform
class HealthDataNotAvailableException implements Exception {
  HealthDataType _dataType;
  PlatformType _platformType;

  HealthDataNotAvailableException(this._dataType, this._platformType);

  String toString() {
    return "Method ${_dataType.toString()} not implemented for platform ${_platformType.toString()}";
  }
}

/// Extracts the string value from an enum
String enumToString(enumItem) => enumItem.toString().split('.')[1];

/// List of all units.
enum HealthDataUnit {
  KILOGRAMS,
  PERCENTAGE,
  METERS,
  COUNT,
  BEATS_PER_MINUTE,
  MILLISECONDS,
  CALORIES,
  DEGREE_CELSIUS,
  NO_UNIT,
  SIEMENS,
  MILLIMETER_OF_MERCURY,
  MILLIGRAM_PER_DECILITER
}

/// List of all available data types.
enum HealthDataType {

  // Body Measurements
  HEIGHT, // .height (iOS 8.0+)
  WEIGHT, // .bodyMass (iOS 8.0+)
  BODY_MASS_INDEX, // .bodyMassIndex (iOS 8.0+)
  BODY_FAT_PERCENTAGE, // .bodyFatPercentage (iOS 8.0+)
  WAIST_CIRCUMFERENCE, // .waistCircumference (iOS 11.0+)
  
  // Activity
  STEPS, // .stepCount (iOS 8.0+)
  BASAL_ENERGY_BURNED, // .basalEnergyBurned (iOS 8.0+)
  ACTIVE_ENERGY_BURNED, // .activeEnergyBurned (iOS 8.0+)
  BODY_TEMPERATURE, // .bodyTemperature (iOS 8.0+)

  // Blood
  BLOOD_PRESSURE_SYSTOLIC, // .bloodPressureSystolic (iOS 8.0+)
  BLOOD_PRESSURE_DIASTOLIC, // .bloodPressureDiastolic (iOS 8.0+)
  BLOOD_OXYGEN, // .oxygenSaturation (iOS 8.0+)
  BLOOD_GLUCOSE, // .bloodGlucose (iOS 8.0+)
  // BLOOD_PRESSURE, // .bloodPressure (iOS 8.0+)
  BLOOD_ALCOHOL,// .bloodAlcoholContent (iOS 8.0+)

  // Respiratory
  RESPIRATORY_RATE, // .respiratoryRate (iOS 8.0+)
  VO2MAX, // .vo2Max (iOS 11.0+)
  
  // Heart Rate
  HEART_RATE, // .heartRate (iOS 8.0+)
  RESTING_HEART_RATE, // .restingHeartRate (iOS 11.0+)
  WALKING_HEART_RATE, // .walkingHeartRateAverage (iOS 11.0+)
  HIGH_HEART_RATE_EVENT, // .highHeartRateEvent (iOS 12.2+)
  LOW_HEART_RATE_EVENT, // .lowHeartRateEvent (iOS 12.2+)
  IRREGULAR_HEART_RATE_EVENT, // .irregularHeartRhythmEvent (iOS 12.2+)
  HRV_SDNN_HEART_RATE_EVENT, // .heartRateVariabilitySDNN (iOS 11.0+)

  // Hearing
  // ENV_AUDIO_EXPOSURE, // .environmentalAudioExposure (iOS 13.0+)
  // HEADPHONE_AUDIO_EXPOSURE, // .headphoneAudioExposure (iOS 13.0+)

  // Lab and Test Results
  ELECTRODERMAL_ACTIVITY, // .electrodermalActivity (iOS 8.0+)

}

/// Map a [HealthDataType] to a [HealthDataUnit].
const Map<HealthDataType, HealthDataUnit> _dataTypeToUnit = {
  // Body Measurements
  HealthDataType.HEIGHT: HealthDataUnit.METERS,
  HealthDataType.WEIGHT: HealthDataUnit.KILOGRAMS,
  HealthDataType.BODY_MASS_INDEX: HealthDataUnit.NO_UNIT,
  HealthDataType.BODY_FAT_PERCENTAGE: HealthDataUnit.PERCENTAGE,
  HealthDataType.WAIST_CIRCUMFERENCE: HealthDataUnit.METERS,
  // Activity
  HealthDataType.STEPS: HealthDataUnit.COUNT,
  HealthDataType.BASAL_ENERGY_BURNED: HealthDataUnit.CALORIES,
  HealthDataType.ACTIVE_ENERGY_BURNED: HealthDataUnit.CALORIES,
  HealthDataType.BODY_TEMPERATURE: HealthDataUnit.DEGREE_CELSIUS,
  // Blood
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_OXYGEN: HealthDataUnit.PERCENTAGE,
  HealthDataType.BLOOD_GLUCOSE: HealthDataUnit.MILLIGRAM_PER_DECILITER,
  // HealthDataType.BLOOD_PRESSURE: HealthDataUnit.NO_UNIT,
  HealthDataType.BLOOD_ALCOHOL: HealthDataUnit.NO_UNIT,
  // Respiratory
  HealthDataType.RESPIRATORY_RATE: HealthDataUnit.NO_UNIT,
  HealthDataType.VO2MAX: HealthDataUnit.NO_UNIT,
  // Heart Rates
  HealthDataType.HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.RESTING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.WALKING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.HIGH_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.LOW_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.HRV_SDNN_HEART_RATE_EVENT: HealthDataUnit.MILLISECONDS,
  // Hearing
  // HealthDataType.ENV_AUDIO_EXPOSURE: HealthDataUnit.NO_UNIT,
  // HealthDataType.HEADPHONE_AUDIO_EXPOSURE: HealthDataUnit.NO_UNIT,
  // Lab and Test Results
  HealthDataType.ELECTRODERMAL_ACTIVITY: HealthDataUnit.SIEMENS,
};

/// List of data types available on iOS
const List<HealthDataType> _dataTypesIOS = [
  // Body Measurements
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.WAIST_CIRCUMFERENCE,
  // Activity
  HealthDataType.STEPS,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BODY_TEMPERATURE,
  // Blood
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_GLUCOSE,
  // HealthDataType.BLOOD_PRESSURE,
  HealthDataType.BLOOD_ALCOHOL,
  // Respiratory
  HealthDataType.RESPIRATORY_RATE,
  HealthDataType.VO2MAX,
  // Heart Rates
  HealthDataType.HEART_RATE,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.WALKING_HEART_RATE,
  HealthDataType.HIGH_HEART_RATE_EVENT,
  HealthDataType.LOW_HEART_RATE_EVENT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  HealthDataType.HRV_SDNN_HEART_RATE_EVENT,
  // Hearing
  // HealthDataType.ENV_AUDIO_EXPOSURE,
  // HealthDataType.HEADPHONE_AUDIO_EXPOSURE,
  // Lab and Test Results
  HealthDataType.ELECTRODERMAL_ACTIVITY,
];

/// List of data types available on Android
const List<HealthDataType> _dataTypesAndroid = [
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.STEPS,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.HEART_RATE,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_GLUCOSE,
];

enum PlatformType { IOS, ANDROID }

/// A [HealthDataPoint] object corresponds to a data point captures from GoogleFit or Apple HealthKit
class HealthDataPoint {
  num value;
  String unit;
  int dateFrom;
  int dateTo;
  String dataType;
  String platform;

  HealthDataPoint(this.value, this.unit, this.dateFrom, this.dateTo,
      this.dataType, this.platform);

  HealthDataPoint.fromJson(Map<String, dynamic> json) {
    try {
      value = json['value'];
      unit = json['unit'];
      dateFrom = json['date_from'];
      dateTo = json['date_to'];
      dataType = json['data_type'];
      platform = json['platform_type'];
    } catch (error) {
      print(error);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['data_type'] = this.dataType;
    data['platform_type'] = this.platform;
    return data;
  }

  String toString() => '${this.runtimeType} - '
      'value: $value, '
      'unit: $unit, '
      'date_from: $dateFrom, '
      'dateFrom: $dateFrom, '
      'dateTo: $dateTo, '
      'dataType: $dataType, '
      'platform: $platform';
}

/// Main class for the Plugin
class Health {
  static const MethodChannel _channel = const MethodChannel('flutter_health');

  static PlatformType _platformType =
      Platform.isAndroid ? PlatformType.ANDROID : PlatformType.IOS;

  /// Check if a given data type is available on the platform
  static bool isDataTypeAvailable(HealthDataType dataType) =>
      _platformType == PlatformType.ANDROID
          ? _dataTypesAndroid.contains(dataType)
          : _dataTypesIOS.contains(dataType);

  // Request access to GoogleFit/Apple HealthKit
  static Future<bool> requestAuthorization() async {
    final bool isAuthorized =
        await _channel.invokeMethod('requestAuthorization');
    return isAuthorized;
  }

  // Calculate the BMI using the last observed height and weight values.
  static Future<List<HealthDataPoint>> _androidBodyMassIndex(
      DateTime startDate, DateTime endDate) async {
    List<HealthDataPoint> heights =
        await getHealthDataFromType(startDate, endDate, HealthDataType.HEIGHT);
    List<HealthDataPoint> weights =
        await getHealthDataFromType(startDate, endDate, HealthDataType.WEIGHT);

    num bmiValue =
        weights.last.value / (heights.last.value * heights.last.value);

    HealthDataType dataType = HealthDataType.BODY_MASS_INDEX;
    HealthDataUnit unit = _dataTypeToUnit[dataType];

    HealthDataPoint bmi = HealthDataPoint(
        bmiValue,
        enumToString(unit),
        startDate.millisecond,
        endDate.millisecond,
        enumToString(dataType),
        PlatformType.ANDROID.toString());

    return [bmi];
  }

  static HealthDataPoint processDataPoint(
      var dataPoint, HealthDataType dataType, HealthDataUnit unit) {
    // Set the platform_type and data_type fields
    dataPoint["platform_type"] = _platformType.toString();

    // Set the [DataType] fields
    dataPoint["data_type"] = enumToString(dataType);

    // Overwrite unit with a Flutter Unit
    dataPoint["unit"] = enumToString(unit);

    // Convert to JSON, and then to HealthData object
    return HealthDataPoint.fromJson(Map<String, dynamic>.from(dataPoint));
  }

  // Main function for fetching health data
  static Future<List<HealthDataPoint>> getHealthDataFromType(
      DateTime startDate, DateTime endDate, HealthDataType dataType) async {
    // If not implemented on platform, throw an exception
    if (!isDataTypeAvailable(dataType)) {
      throw new HealthDataNotAvailableException(dataType, _platformType);
    }

    // If BodyMassIndex is requested on Android, calculate this manually in Dart
    else if (dataType == HealthDataType.BODY_MASS_INDEX &&
        _platformType == PlatformType.ANDROID) {
      return _androidBodyMassIndex(startDate, endDate);
    }

    // Set parameters for method channel request
    Map<String, dynamic> args = {
      'dataTypeKey': enumToString(dataType),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch
    };

    List<HealthDataPoint> healthData = new List();
    HealthDataUnit unit = _dataTypeToUnit[dataType];

    try {
      List fetchedDataPoints = await _channel.invokeMethod('getData', args);

      /// Process each data point received
      for (var dataPoint in fetchedDataPoints) {
//        /// Set the platform_type and data_type fields
//        dataPoint["platform_type"] = _platformType.toString();
//
//        /// Set the [DataType] fields
//        dataPoint["data_type"] = enumToString(dataType);
//
//        /// Overwrite unit with a Flutter Unit
//        dataPoint["unit"] = enumToString(unit);

        // Convert to JSON, and then to HealthData object
        HealthDataPoint data = processDataPoint(dataPoint, dataType, unit);
//            HealthDataPoint.fromJson(Map<String, dynamic>.from(dataPoint));
        healthData.add(data);
      }
    } catch (error) {
      print(error);
    }
    return healthData;
  }
}
