class RegisterAttemp {
  final bool isError;
  final String resultCode;

  RegisterAttemp({
    this.isError,
    this.resultCode
  });

  String getErrorMessage() {
    switch (resultCode) {
      case 'auth/invalid-email':        return 'Formato del email inválido.';
      case 'auth/email-already-in-use': return 'El email introducido ya está en uso.';
      case 'auth/weak-password':        return 'La contraseña introducida no es segura.';
      default:                          return 'Se ha producido un error, por favor, inténtelo de nuevo.';
    }
  }
}