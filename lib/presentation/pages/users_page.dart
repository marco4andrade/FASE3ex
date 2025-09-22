import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import '../bloc/users/users_bloc.dart';
import '../bloc/users/users_event.dart';
import '../bloc/users/users_state.dart';
import '../../core/responsive_utils.dart';

/// Página de gestión de usuarios usando BLoC pattern
///
/// Implementa Clean Architecture respetando principios SOLID:
/// - SRP: Únicamente responsable de la UI de usuarios
/// - OCP: Extensible para nuevas funcionalidades sin modificar código existente
/// - DIP: Depende de abstracciones (BLoC) no de implementaciones concretas
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios al inicializar
    context.read<UsersBloc>().add(const LoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUsersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserActions(context),
        child: const Icon(Icons.person_add),
        tooltip: 'Acciones de usuario',
      ),
    );
  }

  Widget _buildUsersList() {
    return BlocBuilder<UsersBloc, UsersState>(
      buildWhen: (previous, current) =>
          current is UsersLoading ||
          current is UsersLoaded ||
          current is UsersError,
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<UsersBloc>().add(const LoadAllUsers());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is UsersLoaded) {
          if (state.users.isEmpty) {
            return const Center(
              child: Text(
                'No hay usuarios disponibles',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Vista de grid para pantallas grandes (tablet/desktop)
                return _buildGridLayout(state.users, constraints);
              } else {
                // Vista de lista para móviles
                return _buildListLayout(state.users);
              }
            },
          );
        }

        return const Center(
          child: Text('Seleccione una acción para ver usuarios'),
        );
      },
    );
  }

  Widget _buildGridLayout(List<UserEntity> users, BoxConstraints constraints) {
    // Determinar número de columnas basado en el ancho
    int crossAxisCount;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 3;
    } else if (constraints.maxWidth > 900) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildListLayout(List<UserEntity> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                '${user.name.firstName[0]}${user.name.lastName[0]}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text('${user.name.firstName} ${user.name.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user.email}'),
                Text('Usuario: ${user.username}'),
                Text('Teléfono: ${user.phone}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showUserDetails(context, user.id),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showUserDetails(context, user.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y nombre
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Text(
                      '${user.name.firstName[0]}${user.name.lastName[0]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.name.firstName} ${user.name.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '@${user.username}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Información de contacto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.email, user.email),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.phone, user.phone),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_on,
                      '${user.address.city}, ${user.address.street}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showUserActions(BuildContext context) {
    ResponsiveUtils.showResponsiveModal(
      context: context,
      title: 'Acciones de Usuarios',
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Recargar usuarios'),
              onTap: () {
                Navigator.pop(context);
                context.read<UsersBloc>().add(const LoadAllUsers());
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar usuario por ID'),
              onTap: () {
                Navigator.pop(context);
                _showUserIdDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showUserIdDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar Usuario'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'ID del usuario',
              hintText: 'Ingrese el ID (1-10)',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final id = int.tryParse(controller.text);
                if (id != null && id > 0) {
                  Navigator.pop(context);
                  context.read<UsersBloc>().add(LoadUser(id));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingrese un ID válido'),
                    ),
                  );
                }
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetails(BuildContext context, int userId) {
    context.read<UsersBloc>().add(LoadUser(userId));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<UsersBloc, UsersState>(
          buildWhen: (previous, current) =>
              current is UsersLoaded && current.selectedUser != null ||
              current is UsersError,
          builder: (context, state) {
            if (state is UsersLoaded && state.selectedUser != null) {
              final user = state.selectedUser!;
              return AlertDialog(
                title: Text('${user.name.firstName} ${user.name.lastName}'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailRow('ID', user.id.toString()),
                      _buildDetailRow('Email', user.email),
                      _buildDetailRow('Usuario', user.username),
                      _buildDetailRow('Teléfono', user.phone),
                      const SizedBox(height: 16),
                      const Text(
                        'Dirección:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Calle',
                        '${user.address.street} ${user.address.number}',
                      ),
                      _buildDetailRow('Ciudad', user.address.city),
                      _buildDetailRow('Código Postal', user.address.zipCode),
                      _buildDetailRow(
                        'Coordenadas',
                        'Lat: ${user.address.geolocation.latitude}, Lng: ${user.address.geolocation.longitude}',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            }

            if (state is UsersError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error al cargar el usuario: ${state.message}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            }

            return const AlertDialog(
              content: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
