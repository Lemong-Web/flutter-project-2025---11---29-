
class Filter {
  final String name;
  final int? id;
  Filter({required this.name, required this.id});
}

 List<Filter> filterList = [
  Filter(name: "hot", id: 1),
  Filter(name: "Mới", id: 2),
  Filter(name: "manhua", id: 3),
  Filter(name: "Hành động", id: 4),
  Filter(name: "Siêu nhiên", id: 5),
  Filter(name: "Được đề xuất", id: 6)
];
