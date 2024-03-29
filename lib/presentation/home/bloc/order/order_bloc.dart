import 'package:apps_kasir_resto/core/extensions/string_ext.dart';
import 'package:apps_kasir_resto/data/datasources/auth_local_datasource.dart';
import 'package:apps_kasir_resto/data/datasources/product_local_datasource.dart';
import 'package:apps_kasir_resto/presentation/home/models/order_model.dart';
import 'package:apps_kasir_resto/presentation/home/models/product_quantity.dart';
import 'package:bloc/bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';



part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());

      //save to local storage
      //  this.id,
      // required this.subTotal,
      // required this.paymentAmount,
      // required this.tax,
      // required this.discount,
      // required this.serviceCharge,
      // required this.total,
      // required this.paymentMethod,
      // required this.totalItem,
      // required this.idKasir,
      // required this.namaKasir,
      // required this.transactionTime,
      // required this.isSync,
      // required this.orderItems,

      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price! * element.quantity));
      final total = subTotal + event.tax + event.serviceCharge - event.discount;

      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDataSource().getAuthData();

      final dataInput = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        serviceCharge: event.serviceCharge,
        total: total,
        paymentMethod: 'Cash',
        totalItem: totalItem,
        idKasir: userData.user!.id!,
        namaKasir: userData.user!.name!,
         transactionTime: DateFormat.yMd().format(DateTime.now()),
        isSync: 0,
        orderItems: event.items,
      );

      await ProductLocalDatasource.instance.saveOrder(dataInput);

      emit(_Loaded(
        dataInput,
      ));
    });
  }
}
