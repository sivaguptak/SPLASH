enum UserRole { customer, shopOwner, admin }

class Guards {
  // TODO: wire to real auth/roles
  static bool canAccessShop(UserRole? role, {bool approved = true}) =>
      role == UserRole.shopOwner && approved;
  static bool canAccessAdmin(UserRole? role) => role == UserRole.admin;
}
