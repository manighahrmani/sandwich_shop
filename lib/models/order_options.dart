class OrderOptions {
  final String kitchenNote;
  final bool nutFree;
  final bool glutenFree;
  final bool noOnions;

  const OrderOptions({
    this.kitchenNote = '',
    this.nutFree = false,
    this.glutenFree = false,
    this.noOnions = false,
  });
}
