class OrganizationNode {
  final String name;
  final String id;
  final bool isRoot;
  final String? parentId;
  final int level;
  final List<OrganizationNode> children;
  List<Map<String, String>> users;
  bool isExpanded = false;

  OrganizationNode({
    required this.name,
    required this.id,
    required this.isRoot,
    this.parentId,
    required this.level,
    required this.children,
    this.users = const [],
    this.isExpanded = false,
  });
}
