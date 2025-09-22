import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import '../bloc/carts/carts_bloc.dart';
import '../bloc/carts/carts_event.dart';
import '../bloc/carts/carts_state.dart';
import '../../core/responsive_utils.dart';

/// Página de gestión de carritos usando BLoC pattern
///
/// Implementa Clean Architecture respetando principios SOLID:
/// - SRP: Únicamente responsable de la UI de carritos
/// - OCP: Extensible para nuevas funcionalidades sin modificar código existente
/// - DIP: Depende de abstracciones (BLoC) no de implementaciones concretas
class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<CartsPage> createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar carritos al inicializar
    context.read<CartsBloc>().add(const LoadAllCarts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCartsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCartActions(context),
        child: const Icon(Icons.shopping_cart),
        tooltip: 'Acciones de carrito',
      ),
    );
  }

  Widget _buildCartsList() {
    return BlocBuilder<CartsBloc, CartsState>(
      builder: (context, state) {
        if (state is CartsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartsError) {
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
                    context.read<CartsBloc>().add(const LoadAllCarts());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is CartsLoaded) {
          if (state.carts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay carritos disponibles',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                // Vista de grid para pantallas extra grandes
                return _buildGridLayout(state.carts, constraints);
              } else if (constraints.maxWidth > 800) {
                // Vista de dos columnas para pantallas grandes
                return _buildWideLayout(state.carts);
              } else {
                // Vista de lista para móviles
                return _buildMobileLayout(state.carts);
              }
            },
          );
        }

        return const Center(
          child: Text('Seleccione una acción para ver carritos'),
        );
      },
    );
  }

  void _showCartActions(BuildContext context) {
    ResponsiveUtils.showResponsiveModal(
      context: context,
      title: 'Acciones de Carritos',
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Recargar carritos'),
              onTap: () {
                Navigator.pop(context);
                context.read<CartsBloc>().add(const LoadAllCarts());
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar carrito por ID'),
              onTap: () {
                Navigator.pop(context);
                _showCartIdDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text('Carritos por usuario'),
              onTap: () {
                Navigator.pop(context);
                _showCartsByUserDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCartIdDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar Carrito'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'ID del carrito',
              hintText: 'Ingrese el ID (1-7)',
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
                  context.read<CartsBloc>().add(LoadCart(id));
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

  void _showCartsByUserDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Carritos por Usuario'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'ID del usuario',
              hintText: 'Ingrese el ID del usuario (1-10)',
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
                final userId = int.tryParse(controller.text);
                if (userId != null && userId > 0) {
                  Navigator.pop(context);
                  context.read<CartsBloc>().add(LoadCartsByUser(userId));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor ingrese un ID de usuario válido',
                      ),
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

  Widget _buildGridLayout(List<CartEntity> carts, BoxConstraints constraints) {
    // Grid de 2 columnas para pantallas extra grandes
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return _buildCartCard(cart);
      },
    );
  }

  Widget _buildWideLayout(List<CartEntity> carts) {
    // Vista de una columna con layout más amplio
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: _buildWideCartTile(cart),
        );
      },
    );
  }

  Widget _buildMobileLayout(List<CartEntity> carts) {
    // Vista compacta para móviles
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        final totalItems = cart.products.fold<int>(
          0,
          (sum, product) => sum + product.quantity,
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                cart.id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text('Carrito #${cart.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuario ID: ${cart.userId}'),
                Text('Total de productos: $totalItems'),
                Text('Fecha: ${_formatDate(cart.date)}'),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Productos:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...cart.products.map(
                      (product) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              product.productId.toString(),
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text('Producto ID: ${product.productId}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Cantidad: ${product.quantity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Productos únicos: ${cart.products.length}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Total: $totalItems',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartCard(CartEntity cart) {
    final totalItems = cart.products.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del carrito
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    cart.id.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carrito #${cart.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Usuario ID: ${cart.userId}',
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
            // Información del carrito
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Productos únicos',
                    cart.products.length.toString(),
                    Icons.shopping_bag,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Total items',
                    totalItems.toString(),
                    Icons.inventory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Fecha',
              _formatDate(cart.date),
              Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            // Lista compacta de productos
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: cart.products.length,
                itemBuilder: (context, index) {
                  final product = cart.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            product.productId.toString(),
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Producto ${product.productId}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.quantity}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCartTile(CartEntity cart) {
    final totalItems = cart.products.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header expandido
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    cart.id.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carrito #${cart.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Usuario ID: ${cart.userId} • ${_formatDate(cart.date)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalItems',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'Total items',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Productos en formato horizontal
            const Text(
              'Productos en el carrito:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cart.products.length,
                itemBuilder: (context, index) {
                  final product = cart.products[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                product.productId.toString(),
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cantidad: ${product.quantity}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
