
class Filter {
  final String name;
  final int? id;
  Filter({required this.name, required this.id});
}

 List<Filter> filterList = [
  Filter(name: "hot", id: 1),
  Filter(name: "new", id: 2),
  Filter(name: "manhua", id: 3),
  Filter(name: "action", id: 4),
  Filter(name: "Supernatural", id: 5)
];
