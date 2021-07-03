class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';
  static const colAddress = 'address';
  static const colAmount = 'amount';

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    address = map[colAddress];
    mobile = map[colMobile];
    amount = map[colAmount];
  }

  int id;
  String name;
  String address;
  String mobile;
  String amount;
  Contact({this.id, this.name, this.address, this.mobile, this.amount});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colAddress: address,
      colMobile: mobile,
      colAmount: amount
    };
    if (id != null) map[colId] = id;
    return map;
  }
}
