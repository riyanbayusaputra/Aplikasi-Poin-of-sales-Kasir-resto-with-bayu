import 'package:apps_kasir_resto/data/datasources/auth_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:apps_kasir_resto/data/models/response/product_response_model.dart';
import '../../core/constants/variables.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-product');
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to get products');
    }
  }
}
