class Category {
  String name;

  Category({required this.name});
}
  List<Category> categoryList = [
    Category(name: "Hành động"),
    Category(name: "Regression"),
    Category(name: "Giật gân"),
    Category(name: "Nữ phản diện"),
    Category(name: "Hài"),
    Category(name: "Murim"),
    Category(name: "Trồng trọt"),
    Category(name: "Gates"),
    Category(name: "Đầu trường sinh tử"),
    Category(name: "Khoa học viễn tưởng"),
    Category(name: "Đời thường"),
    Category(name: "Lãng mạn"),
    Category(name: "Nền văn minh")
  ];

class MCPersonality {
  String personality;

  MCPersonality({required this.personality});
}

 List<MCPersonality> mcTraitlist = [
    MCPersonality(personality: "Can đảm"),
    MCPersonality(personality: "Thông minh"),
    MCPersonality(personality: "Hèn nhát"),
    MCPersonality(personality: "Tích cực"),
  ];


class Gender {
  String gender;
  Gender({required this.gender});
}

 List<Gender> genderList = [
   Gender(gender: "Male"),
   Gender(gender: "Female"),
   Gender(gender: "Other"),
  ];

