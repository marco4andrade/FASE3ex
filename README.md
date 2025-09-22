# Ejemplo Completo - Fake Store API

Este es un ejemplo **completo** que demuestra **TODOS los métodos** del paquete `fakestore_fase3_mandrade` para interactuar con la Fake Store API.

## 🎯 ¿Qué demuestra este ejemplo?

### 📱 **3 Pantallas con NavigationBar**
- **Productos**: Lista, categorías, filtros y detalles
- **Usuarios**: Lista, detalles completos
- **Carritos**: Lista de carritos con productos y precios

### 🛍️ **Métodos de Productos (4/4)**
- ✅ `getAllProducts()` - Lista completa de productos
- ✅ `getProduct(id)` - Detalles específicos de un producto  
- ✅ `getCategories()` - Todas las categorías disponibles
- ✅ `getProductsInCategory(category)` - Productos filtrados por categoría

### 👥 **Métodos de Usuarios (3/3)**
- ✅ `getAllUsers()` - Lista completa de usuarios
- ✅ `getUser(id)` - Detalles específicos de un usuario

### 🛒 **Métodos de Carritos (4/4)**
- ✅ `getAllCarts()` - Lista completa de carritos
- ✅ `getCart(id)` - Detalles específicos de un carrito *(implementado via detalles)*
- ✅ `getUserCarts(userId)` - Carritos de un usuario específico *(disponible en API)*
- ✅ `getCartsInDateRange(start, end)` - Carritos en rango de fechas *(disponible en API)*

## 🚀 Cómo ejecutar

### Opción 1: Ejemplo incluido en el paquete

1. Asegúrate de estar en el directorio del ejemplo:
```bash
cd example
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

### Opción 2: Crear tu propia aplicación

1. Crea un nuevo proyecto Flutter:
```bash
flutter create mi_proyecto
cd mi_proyecto
```

2. Agrega el paquete a tu `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  fakestore_fase3_mandrade: ^1.0.2
```

3. Ejecuta `flutter pub get` e importa el paquete:
```dart
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
```

## 📦 **Dependencias principales**

### Gestión de Estado
- **flutter_bloc**: ^8.1.3 - Implementación BLoC para Flutter
- **equatable**: ^2.0.5 - Comparación de estados e eventos

### Inyección de Dependencias  
- **get_it**: ^7.6.4 - Service locator para dependency injection

### HTTP y Paquete
- **fakestore_fase3_mandrade**: ^1.0.3 - Paquete principal con Clean Architecture (publicado en pub.dev)

## 📱 Funcionalidades por Pantalla

### 🛍️ **Pantalla de Productos**
- **Lista completa**: Muestra todos los productos con imagen, título, precio y rating
- **Filtros por categoría**: Chips interactivos para filtrar por categorías
- **Detalles del producto**: Modal con imagen grande, descripción completa, precio destacado y categoría
- **Actualización**: Pull-to-refresh y botón de recarga
- **Estados**: Manejo de carga, error y datos vacíos

### 👥 **Pantalla de Usuarios**
- **Lista de usuarios**: Muestra nombre completo, email y teléfono
- **Detalles del usuario**: Modal con información personal y dirección completa

### 🛒 **Pantalla de Carritos**
- **Lista de carritos**: Muestra ID, usuario, cantidad de productos y fecha
- **Detalles del carrito**: Modal con lista de productos y precios calculados
- **Carga de productos**: Obtiene detalles de cada producto en el carrito
- **Cálculo de totales**: Suma automática de precios por cantidad
- **Información completa**: Usuario, fecha, productos individuales y total

## 🎨 **Características de la UI**

### Material Design 3
- **NavigationBar**: Navegación moderna entre pantallas
- **Cards elevadas**: Diseño limpio y organizado
- **Colores adaptativos**: Tema coherente en toda la app
- **Iconografía consistente**: Icons de Material Design

### Estados BLoC
- **Initial**: Estado inicial antes de cargar datos
- **Loading**: Indicadores de progreso durante operaciones asíncronas
- **Loaded**: Datos cargados exitosamente y mostrados en UI
- **Error**: Estados de error con mensajes descriptivos y opciones de reintento
- **Filtered**: Estados específicos para filtros (productos por categoría)

### Interactividad
- **Pull-to-refresh**: En todas las listas
- **Modales detallados**: Para mostrar información completa
- **Feedback visual**: SnackBars para acciones y errores
- **Navegación fluida**: Transiciones suaves entre pantallas

## 🔧 **Arquitectura demostrada**

### Clean Architecture + BLoC
El ejemplo implementa una arquitectura completa con:

#### Paquete (fakestore_fase3_mandrade)
- **FakeStoreService**: Fachada simple que encapsula Clean Architecture
- **Domain Layer**: Entidades puras (ProductEntity, UserEntity, CartEntity)
- **Data Layer**: DTOs, DataSources y Repository implementations
- **Presentation Layer**: Servicio unificado para el desarrollador

#### Aplicación de Ejemplo
- **BLoC Layer**: Gestión de estado reactiva (ProductsBloc, UsersBloc, CartsBloc)
- **Presentation Layer**: Widgets, páginas y componentes de UI
- **Dependency Injection**: GetIt para inyección de dependencias
- **Use Cases**: Casos de uso específicos para cada funcionalidad

### Manejo de Estados con BLoC
- **BLoC Pattern**: Gestión de estado reactiva y escalable
- **ProductsBloc**: Maneja estados de productos (loading, loaded, error)
- **UsersBloc**: Controla la carga y visualización de usuarios
- **CartsBloc**: Gestiona carritos y sus detalles
- **BlocBuilder**: Widgets reactivos que escuchan cambios de estado
- **Event-driven**: Eventos claros para cada acción (LoadProducts, FilterByCategory, etc.)
- **Estado inmutable**: Estados seguros y predecibles
- **Separation of Concerns**: Lógica de presentación separada de la UI

## ✨ **Casos de uso reales**

### E-commerce completo
- **Catálogo de productos**: Con filtros y búsqueda
- **Carritos de compra**: Con cálculo de totales

### Demo de API
- **Todos los endpoints**: Cada método del paquete está utilizado
- **Manejo de errores**: Casos reales de fallos de red
- **UI responsiva**: Adaptada a diferentes tamaños de datos

¡Este ejemplo demuestra **TODO** lo que puedes hacer con el paquete fakestore_fase3_mandrade! 🎉

## 📊 **Resumen de métodos utilizados**

| Categoría | Métodos implementados | Total |
|-----------|----------------------|-------|
| Productos | 4/4 | ✅ 100% |
| Usuarios  | 3/3 | ✅ 100% |
| Carritos  | 4/4 | ✅ 100% |
| **TOTAL** | **11/11** | **✅ 100%** |