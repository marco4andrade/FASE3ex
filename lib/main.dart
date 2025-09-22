import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/injection_container.dart' as di;
import 'presentation/bloc/products/products_bloc.dart';
import 'presentation/bloc/users/users_bloc.dart';
import 'presentation/bloc/carts/carts_bloc.dart';
import 'presentation/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar inyección de dependencias
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // BLoC Providers usando inyección de dependencias
        BlocProvider<ProductsBloc>(create: (_) => di.sl<ProductsBloc>()),
        BlocProvider<UsersBloc>(create: (_) => di.sl<UsersBloc>()),
        BlocProvider<CartsBloc>(create: (_) => di.sl<CartsBloc>()),
      ],
      child: MaterialApp(
        title: 'Clean Architecture - Fake Store API',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
