import 'dart:convert';

PaymentResponseModel paypalResponseModelFromJson(String str) =>
    PaymentResponseModel.fromJson(json.decode(str));

String paypalResponseModelToJson(PaymentResponseModel data) =>
    json.encode(data.toJson());

class PaymentResponseModel {
  final String? payerId;
  final String? paymentId;
  final String? token;
  final String? status;
  final Data? data;

  PaymentResponseModel({
    this.payerId,
    this.paymentId,
    this.token,
    this.status,
    this.data,
  });

  PaymentResponseModel copyWith({
    String? payerId,
    String? paymentId,
    String? token,
    String? status,
    Data? data,
  }) =>
      PaymentResponseModel(
        payerId: payerId ?? this.payerId,
        paymentId: paymentId ?? this.paymentId,
        token: token ?? this.token,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentResponseModel(
        payerId: json["payerID"],
        paymentId: json["paymentId"],
        token: json["token"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "payerID": payerId,
        "paymentId": paymentId,
        "token": token,
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final String? id;
  final String? intent;
  final String? state;
  final String? cart;
  final Payer? payer;
  final List<Transaction>? transactions;

  Data({
    this.id,
    this.intent,
    this.state,
    this.cart,
    this.payer,
    this.transactions,
  });

  Data copyWith({
    String? id,
    String? intent,
    String? state,
    String? cart,
    Payer? payer,
    List<Transaction>? transactions,
  }) =>
      Data(
        id: id ?? this.id,
        intent: intent ?? this.intent,
        state: state ?? this.state,
        cart: cart ?? this.cart,
        payer: payer ?? this.payer,
        transactions: transactions ?? this.transactions,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        intent: json["intent"],
        state: json["state"],
        cart: json["cart"],
        payer: json["payer"] == null ? null : Payer.fromJson(json["payer"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "intent": intent,
        "state": state,
        "cart": cart,
        "payer": payer?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Payer {
  final String? paymentMethod;
  final String? status;
  final PayerInfo? payerInfo;

  Payer({
    this.paymentMethod,
    this.status,
    this.payerInfo,
  });

  Payer copyWith({
    String? paymentMethod,
    String? status,
    PayerInfo? payerInfo,
  }) =>
      Payer(
        paymentMethod: paymentMethod ?? this.paymentMethod,
        status: status ?? this.status,
        payerInfo: payerInfo ?? this.payerInfo,
      );

  factory Payer.fromJson(Map<String, dynamic> json) => Payer(
        paymentMethod: json["payment_method"],
        status: json["status"],
        payerInfo: json["payer_info"] == null
            ? null
            : PayerInfo.fromJson(json["payer_info"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
        "status": status,
        "payer_info": payerInfo?.toJson(),
      };
}

class PayerInfo {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? payerId;
  final ShippingAddress? shippingAddress;
  final String? countryCode;

  PayerInfo({
    this.email,
    this.firstName,
    this.lastName,
    this.payerId,
    this.shippingAddress,
    this.countryCode,
  });

  PayerInfo copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? payerId,
    ShippingAddress? shippingAddress,
    String? countryCode,
  }) =>
      PayerInfo(
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        payerId: payerId ?? this.payerId,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        countryCode: countryCode ?? this.countryCode,
      );

  factory PayerInfo.fromJson(Map<String, dynamic> json) => PayerInfo(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        payerId: json["payer_id"],
        shippingAddress: json["shipping_address"] == null
            ? null
            : ShippingAddress.fromJson(json["shipping_address"]),
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "payer_id": payerId,
        "shipping_address": shippingAddress?.toJson(),
        "country_code": countryCode,
      };
}

class ShippingAddress {
  final String? recipientName;
  final String? line1;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? countryCode;

  ShippingAddress({
    this.recipientName,
    this.line1,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
  });

  ShippingAddress copyWith({
    String? recipientName,
    String? line1,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
  }) =>
      ShippingAddress(
        recipientName: recipientName ?? this.recipientName,
        line1: line1 ?? this.line1,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        countryCode: countryCode ?? this.countryCode,
      );

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        recipientName: json["recipient_name"],
        line1: json["line1"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "recipient_name": recipientName,
        "line1": line1,
        "city": city,
        "state": state,
        "postal_code": postalCode,
        "country_code": countryCode,
      };
}

class Transaction {
  final Amount? amount;
  final Payee? payee;
  final String? description;
  final String? softDescriptor;
  final ItemList? itemList;

  Transaction({
    this.amount,
    this.payee,
    this.description,
    this.softDescriptor,
    this.itemList,
  });

  Transaction copyWith({
    Amount? amount,
    Payee? payee,
    String? description,
    String? softDescriptor,
    ItemList? itemList,
  }) =>
      Transaction(
        amount: amount ?? this.amount,
        payee: payee ?? this.payee,
        description: description ?? this.description,
        softDescriptor: softDescriptor ?? this.softDescriptor,
        itemList: itemList ?? this.itemList,
      );

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
        payee: json["payee"] == null ? null : Payee.fromJson(json["payee"]),
        description: json["description"],
        softDescriptor: json["soft_descriptor"],
        itemList: json["item_list"] == null
            ? null
            : ItemList.fromJson(json["item_list"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount?.toJson(),
        "payee": payee?.toJson(),
        "description": description,
        "soft_descriptor": softDescriptor,
        "item_list": itemList?.toJson(),
      };
}

class Amount {
  final String? total;
  final String? currency;
  final Details? details;

  Amount({
    this.total,
    this.currency,
    this.details,
  });

  Amount copyWith({
    String? total,
    String? currency,
    Details? details,
  }) =>
      Amount(
        total: total ?? this.total,
        currency: currency ?? this.currency,
        details: details ?? this.details,
      );

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        total: json["total"],
        currency: json["currency"],
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "currency": currency,
        "details": details?.toJson(),
      };
}

class Details {
  final String? subtotal;
  final String? shipping;
  final String? insurance;
  final String? handlingFee;
  final String? shippingDiscount;
  final String? discount;

  Details({
    this.subtotal,
    this.shipping,
    this.insurance,
    this.handlingFee,
    this.shippingDiscount,
    this.discount,
  });

  Details copyWith({
    String? subtotal,
    String? shipping,
    String? insurance,
    String? handlingFee,
    String? shippingDiscount,
    String? discount,
  }) =>
      Details(
        subtotal: subtotal ?? this.subtotal,
        shipping: shipping ?? this.shipping,
        insurance: insurance ?? this.insurance,
        handlingFee: handlingFee ?? this.handlingFee,
        shippingDiscount: shippingDiscount ?? this.shippingDiscount,
        discount: discount ?? this.discount,
      );

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        subtotal: json["subtotal"],
        shipping: json["shipping"],
        insurance: json["insurance"],
        handlingFee: json["handling_fee"],
        shippingDiscount: json["shipping_discount"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "subtotal": subtotal,
        "shipping": shipping,
        "insurance": insurance,
        "handling_fee": handlingFee,
        "shipping_discount": shippingDiscount,
        "discount": discount,
      };
}

class ItemList {
  final List<Item>? items;

  ItemList({
    this.items,
  });

  ItemList copyWith({
    List<Item>? items,
  }) =>
      ItemList(
        items: items ?? this.items,
      );

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  final String? name;
  final String? price;
  final String? currency;
  final String? tax;
  final int? quantity;
  final dynamic imageUrl;

  Item({
    this.name,
    this.price,
    this.currency,
    this.tax,
    this.quantity,
    this.imageUrl,
  });

  Item copyWith({
    String? name,
    String? price,
    String? currency,
    String? tax,
    int? quantity,
    dynamic imageUrl,
  }) =>
      Item(
        name: name ?? this.name,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        tax: tax ?? this.tax,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        price: json["price"],
        currency: json["currency"],
        tax: json["tax"],
        quantity: json["quantity"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "currency": currency,
        "tax": tax,
        "quantity": quantity,
        "image_url": imageUrl,
      };
}

class Payee {
  final String? merchantId;
  final String? email;

  Payee({
    this.merchantId,
    this.email,
  });

  Payee copyWith({
    String? merchantId,
    String? email,
  }) =>
      Payee(
        merchantId: merchantId ?? this.merchantId,
        email: email ?? this.email,
      );

  factory Payee.fromJson(Map<String, dynamic> json) => Payee(
        merchantId: json["merchant_id"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "merchant_id": merchantId,
        "email": email,
      };
}
