import 'package:flutter/material.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import 'user_card.dart';

class UserGrid extends StatelessWidget {
  final List<UserEntity> users;
  final Function(int)? onUserTap;

  const UserGrid({super.key, required this.users, this.onUserTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar número de columnas basado en el ancho
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
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
            return UserCard(
              user: user,
              onTap: onUserTap != null ? () => onUserTap!(user.id) : null,
            );
          },
        );
      },
    );
  }
}
