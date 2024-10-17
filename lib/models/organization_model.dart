class OrganizationState {
  final String id;
  final String name;
  final bool isRoot;
  final String? parentId;
  final int level;
  final List<OrganizationState> subOrganizations;
  bool isExpanded;

  OrganizationState({
    required this.id,
    required this.name,
    required this.isRoot,
    this.parentId,
    required this.level,
    required this.subOrganizations,
    this.isExpanded = false,
  });
}
