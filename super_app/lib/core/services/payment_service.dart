class PaymentResult {
  final bool isSuccess;
  final String transactionId;
  final String method;
  final double amount;
  final String? errorMessage;

  const PaymentResult({
    required this.isSuccess,
    required this.transactionId,
    required this.method,
    required this.amount,
    this.errorMessage,
  });
}

class PaymentService {
  PaymentService._();

  static final PaymentService instance = PaymentService._();

  /// Process simulated in-app payment with instant feedback
  Future<PaymentResult> processPayment({
    required double amount,
    required String method, // 'UPI', 'CARD', 'CASH'
    required String module, // 'FOOD', 'RIDE'
  }) async {
    // Simulate brief network roundtrip
    await Future.delayed(const Duration(milliseconds: 650));

    final txnId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    return PaymentResult(
      isSuccess: true,
      transactionId: txnId,
      method: method,
      amount: amount,
    );
  }
}
