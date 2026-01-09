class StoreOrderConfirmationRepository {
  const StoreOrderConfirmationRepository();

  Future<void> confirmOrder() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
