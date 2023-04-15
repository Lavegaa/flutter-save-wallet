/**
 * json_annotation이라는 라이브러리로 직렬화 한다는데 generate가 안됨
 * flutter pub run build_runner build
 * 위 명령어 쓰면 된다고 함
 * https://pub.dev/packages/json_annotation
 */

// import 'package:json_annotation/json_annotation.dart';

// part 'example.g.dart';

// @JsonSerializable()
// class Person {
//   final String firstName;
//   @JsonKey(includeIfNull: false)
//   final String? middleName;
//   final String lastName;

//   @JsonKey(name: 'date-of-birth')
//   final DateTime dateOfBirth;

//   @JsonKey(name: 'last-order')
//   final DateTime? lastOrder;

//   List<Order> orders;

//   Person(
//     this.firstName,
//     this.lastName,
//     this.dateOfBirth, {
//     this.middleName,
//     this.lastOrder,
//     List<Order>? orders,
//   }) : orders = orders ?? <Order>[];

//   factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

//   Map<String, dynamic> toJson() => _$PersonToJson(this);
// }

// @JsonSerializable(includeIfNull: false)
// class Order {
//   int? count;
//   int? itemNumber;
//   bool? isRushed;
//   Item? item;

//   @JsonKey(
//       name: 'prep-time',
//       fromJson: _durationFromMilliseconds,
//       toJson: _durationToMilliseconds)
//   Duration? prepTime;

//   @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
//   final DateTime date;

//   Order(this.date);

//   factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

//   Map<String, dynamic> toJson() => _$OrderToJson(this);

//   static Duration? _durationFromMilliseconds(int? milliseconds) =>
//       milliseconds == null ? null : Duration(milliseconds: milliseconds);

//   static int? _durationToMilliseconds(Duration? duration) =>
//       duration?.inMilliseconds;

//   static DateTime _dateTimeFromEpochUs(int us) =>
//       DateTime.fromMicrosecondsSinceEpoch(us);

//   static int? _dateTimeToEpochUs(DateTime? dateTime) =>
//       dateTime?.microsecondsSinceEpoch;
// }

// @JsonSerializable()
// class Item {
//   int? count;
//   int? itemNumber;
//   bool? isRushed;

//   Item();

//   factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

//   Map<String, dynamic> toJson() => _$ItemToJson(this);
// }

// @JsonLiteral('data.json')
// Map get glossaryData => _$glossaryDataJsonLiteral;