enum VehicleType {
  threeWheeler('THREE_WHEELER'),
  fourWheeler('FOUR_WHEELER');

  const VehicleType(this.value);
  final String value;
}

enum VehicleBodyType {
  open('OPEN'),
  closed('CLOSED');

  const VehicleBodyType(this.value);
  final String value;
}

enum FuelType {
  diesel('DIESEL'),
  petrol('PETROL'),
  ev('EV'),
  cng('CNG');

  const FuelType(this.value);
  final String value;
}