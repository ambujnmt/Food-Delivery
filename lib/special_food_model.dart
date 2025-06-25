class SideItem {
  final int id;
  final String itemName;
  final String itemImage;
  final String itemPrice;
  final String productId;
  final List<Question> questions;

  SideItem({
    required this.id,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.productId,
    required this.questions,
  });

  factory SideItem.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List? ?? [];
    List<Question> questions = questionsList.map((q) => Question.fromJson(q)).toList();
    return SideItem(
      id: json['id'],
      itemName: json['item_name'],
      itemImage: json['item_image'],
      itemPrice: json['item_price'],
      productId: json['product_id'],
      questions: questions,
    );
  }
}

class Question {
  final int id;
  final int sideItemId;
  final String question;
  final List<Option> options;

  Question({
    required this.id,
    required this.sideItemId,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List? ?? [];
    List<Option> options = optionsList.map((o) => Option.fromJson(o)).toList();
    return Question(
      id: json['id'],
      sideItemId: json['side_item_id'],
      question: json['question'],
      options: options,
    );
  }
}

class Option {
  final int id;
  final int questionId;
  final String name;
  final String image;
  final String size;
  final String price;

  Option({
    required this.id,
    required this.questionId,
    required this.name,
    required this.image,
    required this.size,
    required this.price,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      questionId: json['question_id'],
      name: json['name'],
      image: json['image'],
      size: json['size'],
      price: json['price'],
    );
  }
}

class OftenBoughtWithGroup {
  final int id;
  final int productId;
  final String name;
  final List<OftenBoughtWithOption> options;

  OftenBoughtWithGroup({
    required this.id,
    required this.productId,
    required this.name,
    required this.options,
  });

  factory OftenBoughtWithGroup.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List? ?? [];
    List<OftenBoughtWithOption> options = optionsList.map((o) => OftenBoughtWithOption.fromJson(o)).toList();
    return OftenBoughtWithGroup(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      options: options,
    );
  }
}

class OftenBoughtWithOption {
  final int id;
  final int optionGroupId;
  final String name;
  final String price;
  final String size;
  final String image;

  OftenBoughtWithOption({
    required this.id,
    required this.optionGroupId,
    required this.name,
    required this.price,
    required this.size,
    required this.image,
  });

  factory OftenBoughtWithOption.fromJson(Map<String, dynamic> json) {
    return OftenBoughtWithOption(
      id: json['id'],
      optionGroupId: json['option_group_id'],
      name: json['name'],
      price: json['price'],
      size: json['size'],
      image: json['image'],
    );
  }
}