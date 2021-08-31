import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kulina/bloc/cubit/product_cubit.dart';
import 'package:kulina/presentation/product_list_view.dart';
import 'package:kulina/service/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<ProductCubit>(create: (_) => ProductCubit(),
      child: ProductListView()));
  }
}


