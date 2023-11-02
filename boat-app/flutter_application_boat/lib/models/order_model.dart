class Order {
  int? orderId;
  int? boatId;
  int? userId;
  DateTime? bookingDate;
  DateTime? fromDate;
  DateTime? toDate;
  int? durationInHours;
  double? price;
  String? customerName;
  String? customerEmail;
  String? shipDestination;
  int? supplierId;
  double? stats;
  List<Payment>? payment;
  FeedBack? feedBack;
  int? paymentType;
  Order(
      {this.orderId,
      this.boatId,
      this.userId,
      this.bookingDate,
      this.fromDate,
      this.toDate,
      this.durationInHours,
      this.price,
      this.customerName,
      this.customerEmail,
      this.shipDestination,
      this.supplierId,
      this.stats,
      this.payment,
      this.feedBack,
      this.paymentType});

  Order.fromMap(Map<String, dynamic> map) {
    orderId = map['orderId'];
    boatId = map['boatId'];
    userId = map['userId'];
    bookingDate = map['bookingDate'];
    fromDate = map['fromDate'];
    toDate = map['toDate'];
    durationInHours = map['durationInHours'];
    price = map['price'];
    customerName = map['customerName'];
    customerEmail = map['customerEmail'];
    shipDestination = map['shipDestination'];
    supplierId = map['supplierId'];
    stats = map['stats'];
    if (map['payment'] != null) {
      payment = [];
      map['payment'].forEach((v) {
        payment!.add(new Payment.fromMap(v));
      });
    }
    feedBack =
        map['feedBack'] != null ? new FeedBack.fromMap(map['feedBack']) : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['boatId'] = this.boatId;
    data['userId'] = this.userId;
    data['bookingDate'] = this.bookingDate;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['durationInHours'] = this.durationInHours;
    data['price'] = this.price;
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    data['shipDestination'] = this.shipDestination;
    data['supplierId'] = this.supplierId;
    data['stats'] = this.stats;
    if (this.payment != null) {
      data['payment'] = this.payment!.map((v) => v.toMap()).toList();
    }
    if (this.feedBack != null) {
      data['feedBack'] = this.feedBack!.toMap();
    }
    return data;
  }
}

class FeedBack {
  int? id;
  String? notes;
  double? rating;
  DateTime? publishDate;
  int? active;

  FeedBack({this.id, this.notes, this.rating, this.publishDate, this.active});

  FeedBack.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    notes = map['notes'];
    rating = map['rating'];
    publishDate = map['publishDate'];
    active = map['active'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['rating'] = this.rating;
    data['publishDate'] = this.publishDate;
    data['active'] = this.active;
    return data;
  }
}

class Payment {
  int? id;
  int? allowedStatus;
  double? price;

  Payment({this.id, this.allowedStatus, this.price});

  Payment.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    allowedStatus = map['allowedStatus'];
    price = map['price'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['allowedStatus'] = this.allowedStatus;
    data['price'] = this.price;
    return data;
  }
}

class PaymentType {
  int? id;
  String? paymentName;
  int? status;

  PaymentType({this.id, this.paymentName, this.status});

  PaymentType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    paymentName = map['paymentName'];
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentName'] = this.paymentName;
    data['status'] = this.status;
    return data;
  }
}
