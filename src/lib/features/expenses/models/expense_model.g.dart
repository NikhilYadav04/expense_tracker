// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      expenseDate: DateTime.parse(json['expense_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'amount': instance.amount,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'expense_date': instance.expenseDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'Food',
  ExpenseCategory.travel: 'Travel',
  ExpenseCategory.shopping: 'Shopping',
  ExpenseCategory.bills: 'Bills',
  ExpenseCategory.others: 'Others',
};
