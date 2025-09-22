import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/products/products_bloc.dart';
import '../bloc/products/products_event.dart';
import '../bloc/products/products_state.dart';
import '../../core/responsive_utils.dart';
import '../widgets/products/products_widgets.dart';
import '../widgets/common/common_widgets.dart';

/// Página de gestión de productos usando BLoC pattern
///
/// Implementa Clean Architecture respetando principios SOLID:
/// - SRP: Únicamente responsable de la UI de productos
/// - OCP: Extensible para nuevas funcionalidades sin modificar código existente
/// - DIP: Depende de abstracciones (BLoC) no de implementaciones concretas
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Cargar productos y categorías al inicializar
    context.read<ProductsBloc>().add(const LoadAllProducts());
    context.read<ProductsBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filtro por categorías
          _buildCategoryFilter(),
          // Lista de productos
          Expanded(child: _buildProductsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductActions(context),
        child: const Icon(Icons.add),
        tooltip: 'Acciones de producto',
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (previous, current) =>
          current is ProductsLoaded || current is ProductsLoading,
      builder: (context, state) {
        if (state is ProductsLoaded && state.categories.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por categoría:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = null);
                          context.read<ProductsBloc>().add(
                            const LoadAllProducts(),
                          );
                        }
                      },
                    ),
                    ...state.categories.map(
                      (category) => FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                            context.read<ProductsBloc>().add(
                              LoadProductsByCategory(category),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductsList() {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (previous, current) =>
          current is ProductsLoading ||
          current is ProductsLoaded ||
          current is ProductsError,
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const LoadingWidget(message: 'Cargando productos...');
        }

        if (state is ProductsError) {
          return ErrorDisplayWidget(
            message: 'Error: ${state.message}',
            onRetry: () {
              if (_selectedCategory != null) {
                context.read<ProductsBloc>().add(
                  LoadProductsByCategory(_selectedCategory!),
                );
              } else {
                context.read<ProductsBloc>().add(const LoadAllProducts());
              }
            },
          );
        }

        if (state is ProductsLoaded) {
          if (state.products.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              message: 'No hay productos disponibles',
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Determinar el tipo de layout basado en el ancho
              final isLargeScreen = constraints.maxWidth > 1200;
              final isMediumScreen = constraints.maxWidth > 800;

              if (isLargeScreen || isMediumScreen) {
                // Vista de grid para pantallas medianas y grandes
                return ProductGrid(
                  products: state.products,
                  onProductTap: (productId) =>
                      _showProductDetails(context, productId),
                );
              } else {
                // Vista de lista para pantallas pequeñas
                return ProductList(
                  products: state.products,
                  onProductTap: (productId) =>
                      _showProductDetails(context, productId),
                );
              }
            },
          );
        }

        return const EmptyStateWidget(
          icon: Icons.shopping_bag_outlined,
          message: 'Seleccione una acción para ver productos',
        );
      },
    );
  }

  void _showProductActions(BuildContext context) {
    ResponsiveUtils.showResponsiveModal(
      context: context,
      title: 'Acciones de Productos',
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Recargar todos los productos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedCategory = null);
                context.read<ProductsBloc>().add(const LoadAllProducts());
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Recargar categorías'),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(const LoadCategories());
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar producto por ID'),
              onTap: () {
                Navigator.pop(context);
                _showProductIdDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showProductIdDialog(BuildContext context) {
    final controller = TextEditingController();

    ResponsiveUtils.showResponsiveModal(
      context: context,
      title: 'Buscar Producto',
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'ID del producto',
                  hintText: 'Ingrese el ID (1-20)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.dispose();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final id = int.tryParse(controller.text);
                      if (id != null && id > 0) {
                        Navigator.pop(context);
                        context.read<ProductsBloc>().add(LoadProduct(id));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor ingrese un ID válido'),
                          ),
                        );
                      }
                      controller.dispose();
                    },
                    child: const Text('Buscar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, int productId) {
    context.read<ProductsBloc>().add(LoadProduct(productId));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (previous, current) =>
              current is ProductsLoaded && current.selectedProduct != null ||
              current is ProductsError ||
              current is ProductsLoading,
          builder: (context, state) {
            if (state is ProductsLoaded && state.selectedProduct != null) {
              final product = state.selectedProduct!;
              return Dialog(
                insetPadding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header con título y botón cerrar
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      // Contenido del producto
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagen del producto
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Precio
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                ),
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Información del producto
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      'Categoría',
                                      product.category,
                                      Icons.category,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInfoCard(
                                      'Calificación',
                                      '${product.rating.rate} ⭐ (${product.rating.count})',
                                      Icons.star,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Descripción
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Text(
                                  product.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Botón de acción
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Cerrar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProductsError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error al cargar el producto: ${state.message}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            }

            return const Dialog(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando producto...'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
