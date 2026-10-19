abstract interface class AuthWithEmailAndPasswordInterface<Model> {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> verifyEmail();

  Future<Model?> getCurrentUser();

  Future<void> signOut();
}
