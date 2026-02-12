class PaymentUtil {
  //card images
  // list index wise imageOf = discover(0),DCI(1),china union pay(2),american express(3),visa(4),mastercard(5),jcb(6),eftpos(7),default(8)
  static List<String> cardImages = [
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=Discover.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=DCI.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=China%20UnionPay%20(CUP).svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=American%20Express.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=Visa%20Card.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=Master%20Card.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=JCB.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=eftpos.svg",
    "https://1system.nyc3.cdn.digitaloceanspaces.com/icons/payment_icons/Type=Default.svg"
  ];

  static String? getCardImage(String? cardName) {
    switch (cardName) {
      case "discover":
        return cardImages[0];
      case "dci":
        return cardImages[1];
      case "unionpay":
        return cardImages[2];
      case "amex":
        return cardImages[3];
      case "visa":
        return cardImages[4];
      case "mastercard":
        return cardImages[5];
      case "jcb":
        return cardImages[6];
      case "eftos":
        return cardImages[7];
      default:
        return cardImages[8];
    }
  }
}
