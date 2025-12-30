import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

enum ExpenseCategory {
  @JsonValue('Food')
  food,
  @JsonValue('Travel')
  travel,
  @JsonValue('Shopping')
  shopping,
  @JsonValue('Bills')
  bills,
  @JsonValue('Others')
  others;

  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.others:
        return 'Others';
    }
  }
}

@JsonSerializable()
class ExpenseModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String title;
  final double amount;
  final ExpenseCategory category;
  @JsonKey(name: 'expense_date')
  final DateTime expenseDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.expenseDate,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
