// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
class OrderHistoryModel {
  String? message;
  bool? status;
  List<OrderHistory>? orderHistory;

  OrderHistoryModel({this.message, this.status, this.orderHistory});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['orderHistory'] != null) {
      orderHistory = <OrderHistory>[];
      json['orderHistory'].forEach((v) {
        orderHistory!.add(OrderHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (orderHistory != null) {
      data['orderHistory'] = orderHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderHistory {
  int? id;
  int? userId;
  int? userAddressId;
  String? orderNumber;
  String? totalAmount;
  String? status;
  String? specialInstruction;
  String? orderDate;
  String? orderTime;
  User? user;
  UserAddress? userAddress;
  List<Details>? details;

  OrderHistory({
    this.id,
    this.userId,
    this.userAddressId,
    this.orderNumber,
    this.totalAmount,
    this.status,
    this.specialInstruction,
    this.orderDate,
    this.orderTime,
    this.user,
    this.userAddress,
    this.details,
  });

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userAddressId = json['user_address_id'];
    orderNumber = json['order_number'];
    totalAmount = json['total_amount'];
    status = json['status'];
    specialInstruction = json['special_instruction'];
    orderDate = json['order_date'];
    orderTime = json['order_time'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userAddress =
        json['user_address'] != null
            ? UserAddress.fromJson(json['user_address'])
            : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_address_id'] = userAddressId;
    data['order_number'] = orderNumber;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['special_instruction'] = specialInstruction;
    data['order_date'] = orderDate;
    data['order_time'] = orderTime;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userAddress != null) {
      data['user_address'] = userAddress!.toJson();
    }
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;

  User({this.id, this.name, this.email, this.mobile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    return data;
  }
}

class UserAddress {
  int? id;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? postalCode;
  String? latitude;
  String? longitude;
  String? phone;

  UserAddress({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.phone,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['city'] = city;
    data['state'] = state;
    data['postal_code'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    return data;
  }

  // Method to return formatted address
  String getFormattedAddress() {
    if (addressLine1 != null &&
        addressLine2 != null &&
        city != null &&
        state != null &&
        postalCode != null) {
      return '$addressLine1, $addressLine2, $city, $state - $postalCode';
    }
    return 'Not found';
  }
}

class Details {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  String? price;
  String? amount;
  String? orderDate;
  String? orderTime;
  Product? product;

  Details({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
    this.amount,
    this.orderDate,
    this.orderTime,
    this.product,
  });

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    amount = json['amount'];
    orderDate = json['order_date'];
    orderTime = json['order_time'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['amount'] = amount;
    data['order_date'] = orderDate;
    data['order_time'] = orderTime;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  int? unitId;
  String? price;
  String? image;
  Unit? unit;

  Product({
    this.id,
    this.name,
    this.description,
    this.unitId,
    this.price,
    this.image,
    this.unit,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    unitId = json['unit_id'];
    price = json['price'];
    image = json['image'];
    unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['unit_id'] = unitId;
    data['price'] = price;
    data['image'] = image;
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    return data;
  }
}

class Unit {
  int? id;
  String? name;
  String? code;
  String? description;

  Unit({this.id, this.name, this.code, this.description});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}
