class SimpleUser {
  final int? id;
  final String? nom;
  final String? prenom;
  final String? email;
  final String? role;

  SimpleUser({
    this.id,
    this.nom,
    this.prenom,
    this.email,
    this.role,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['id'] as int?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'motDePasse': password,
    };
  }
}

class LoginResponse {
  final String? token;
  final String? refreshToken;
  final SimpleUser? user;

  LoginResponse({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] != null ? SimpleUser.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String nom;
  final String prenom;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.nom,
    required this.prenom,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom,
    };
  }
}
