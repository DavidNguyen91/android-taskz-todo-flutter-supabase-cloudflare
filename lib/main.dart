import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/supabase_auth_repository.dart';
import 'data/repositories/supabase_task_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/task_repository.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase Client with safe anon credentials
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  final client = Supabase.instance.client;

  // Dependency Inversion: Construct concrete repositories conforming to interfaces
  final IAuthRepository authRepository = SupabaseAuthRepository(client: client);
  final ITaskRepository taskRepository = SupabaseTaskRepository(client: client);

  // Presentation State Controllers
  final authController = AuthController(authRepository: authRepository);
  final taskController = TaskController(taskRepository: taskRepository);

  runApp(TodoApp(
    authController: authController,
    taskController: taskController,
  ));
}

/// Root Application Widget with Apple iOS aesthetic themes.
class TodoApp extends StatelessWidget {
  final AuthController authController;
  final TaskController taskController;

  const TodoApp({
    super.key,
    required this.authController,
    required this.taskController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: ListenableBuilder(
        listenable: authController,
        builder: (context, _) {
          if (authController.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (authController.isAuthenticated) {
            return HomeScreen(
              authController: authController,
              taskController: taskController,
            );
          }

          return LoginScreen(
            authController: authController,
          );
        },
      ),
    );
  }
}
